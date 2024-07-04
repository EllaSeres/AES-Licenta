library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity RX_Module is -- RX Module
Generic (
   Baud_Rate  : integer;   -- Effective Baud Rate of the protocol [bps]
   CLK_Period : integer    -- Input clock period [ns]
);   
Port(	
   CLK_Input    : in std_logic;                                                
   RST_Input    : in std_logic;
   Baud_Trigger : in std_logic; 
   RX_in        : in std_logic;
   Word_Valid   : out std_logic;       
   Data_Output  : out std_logic_vector ( 7 downto 0 );
   RX_Error     : out std_logic;
   Clear        : out std_logic
);
End RX_Module;

Architecture Behavioral of RX_Module is

constant Half_Sample_Counter_Size : integer := integer(ceil(log2(real((10**9)/(Baud_Rate*CLK_Period))))); -- Calculate the required bitsize of the sync counter
constant Half_Sample_Counter_Init : integer := integer(ceil(real((10**9)/(Baud_Rate*CLK_Period*2))));     -- Calculate the init/reset value of the sync counter
constant RX_Counter_Init : std_logic_vector ( 4 downto 0 ) := std_logic_vector ( to_unsigned (7, 5));

Type RX_FSM is (Check_Line, Sync, Debounce, Receive_Data);
signal State : RX_FSM := Check_Line;

signal RX_Data      : std_logic_vector ( 7 downto 0 );
signal Sync_Counter : std_logic_vector ( Half_Sample_Counter_Size downto 0 ) := std_logic_vector ( to_unsigned (Half_Sample_Counter_Init, Half_Sample_Counter_Size+1));
signal RX_Counter   : std_logic_vector ( 4 downto 0 ) := RX_Counter_Init;

signal Clear_Flag   : std_logic := '1';
signal Err_Flag     : std_logic := '0';
signal Send_Word    : std_logic := '0';

begin

Process (CLK_Input, RST_Input)
begin
if rising_edge (CLK_Input) then
   if Send_Word = '1' then
      Data_Output <= RX_Data;
	  Word_Valid  <= '1';
   else
     -- Data_Output <= (others => '0');
	  Word_Valid  <= '0';
   end if;
   
   if RST_Input = '1' then
      Sync_Counter <= std_logic_vector ( to_unsigned (Half_Sample_Counter_Init, Half_Sample_Counter_Size+1));
	  Clear_Flag   <= '1';
	  Send_Word    <= '0';
	  State        <= Check_Line;
	  RX_Data      <= (others => '0');
   else    
      Case State is
	    when Check_Line => -- Check if the line is 
		  if RX_in = '1' then
		     State <= Sync;
		  end if;
		  Clear_Flag   <= '1';
		  Sync_Counter <= std_logic_vector ( to_unsigned (Half_Sample_Counter_Init, Half_Sample_Counter_Size+1));
		  Send_Word    <= '0';
		  Err_Flag     <= '0';
		  RX_Counter   <= RX_Counter_Init;
		  RX_Data      <= (others => '0');
		  
		when Sync => -- The FSM will always re-sync when receiving a new word; Sync = move the sampling moment in the middle of the bit
		  if RX_in = '0' then
		     if Sync_Counter(Sync_Counter'high) = '1' then
			    Clear_Flag   <= '0';
				State        <= Receive_Data;
			 else
			    Sync_Counter <= std_logic_vector (unsigned (Sync_Counter) - 1); 
			 end if;
		  end if;
		  
		when Debounce =>
		  if Baud_Trigger = '0' then
		     State <= Receive_Data;
		  end if;
		  
		when Receive_Data =>
		  if Baud_Trigger = '1' then
             if RX_Counter (RX_Counter'high) = '1' then 
                if RX_in = '1' then			 
			       Send_Word  <= '1';
				else
				   Err_Flag   <= '1';
				end if;
				State      <= Check_Line;
             else
			    RX_Counter <= std_logic_vector ( unsigned (RX_Counter) - 1);
				for i in 0 to 6 loop
				   RX_Data (i) <= RX_Data (i+1);
				end loop;
				RX_Data (7)      <= RX_in;
				State            <= Debounce;
             end if;			 
		  end if;
		  
	  End Case;
   end if;
   
end if;
end process;

Clear    <= Clear_Flag;
RX_Error <= Err_Flag;

End Behavioral; 
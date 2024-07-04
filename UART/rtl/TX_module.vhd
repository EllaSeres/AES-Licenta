library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity TX_module is -- TX Module
Port(	
   CLK_Input    : in std_logic;                                                
   RST_Input    : in std_logic;
   Transmit     : in std_logic;       
   Baud_Trigger : in std_logic;  
   Data_Input   : in std_logic_vector ( 7 downto 0 );
   Busy         : out std_logic;
   TX_Out       : out std_logic
);
End TX_module;                                       

Architecture Behavioral of TX_module is

constant TX_Counter_Init : std_logic_vector ( 4 downto 0 ) := std_logic_vector ( to_unsigned (8, 5));

Type TX_FSM is (Idle, Debounce, Transmit_Data);
signal State : TX_FSM := Idle;
signal TX_Register : std_logic_vector ( 9 downto 0 ) := (others => '0');
signal TX_Counter  : std_logic_vector ( 4 downto 0 ) := TX_Counter_Init;
signal TX_int      : std_logic := '0';
signal Busy_int    : std_logic := '1';
--signal Delay_SR    : std_logic_vector ( 15 downto 0 ) := (others => '0');

begin

Process (CLK_Input,RST_Input)
begin
if rising_edge (CLK_Input) then
   if RST_Input = '1' then
      TX_int      <= '1';
	  TX_Register <= (others => '0');
	  State       <= Idle;
	  Busy_int    <= '1';
   else
      Case State is
	    when Idle =>
		  TX_int      <= '1';
		  TX_Counter  <= TX_Counter_Init;
		  TX_Register (9) <= '1';
		  TX_Register (0) <= '0';
		  if Transmit = '1' then
		     TX_Register ( 8 downto 1 ) <= Data_Input;
             State       <= Debounce;	
             Busy_int    <= '1';	
             -- Delay_SR    <= (others => '1');			 
		  else
		     
		     Busy_int    <= '0';--Delay_SR (0);
			 -- for i in 1 to 15 loop
			    -- Delay_SR (i-1) <= Delay_SR (i);
			 -- end loop;
			 -- Delay_SR (15) <= '0';
		  end if;
		  
		  -- if Baud_Trigger = '1' then
		     -- Busy_int    <= '0';
          -- end if;
		  		  
        when Debounce => 
		  if Baud_Trigger = '0' then
		     State <= Transmit_Data;
          end if;
		  
        when Transmit_Data =>
		  if Baud_Trigger = '1' then
		    if TX_Counter ( TX_Counter'high ) = '1' then
		       State    <= Idle;
		    else
			   for i in 1 to 9 loop
			     TX_Register (i-1) <= TX_Register (i);
			   end loop;
			   State      <= Debounce;
			   TX_Counter <= std_logic_vector ( unsigned (TX_Counter) - 1);
		    end if;
			TX_int     <= TX_Register (0);
		  end if;
		  
        when others =>		
		
	  End Case;
   end if;
end if;
end process;

TX_Out <= TX_int;
Busy   <= Busy_int;

End Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity BRG is -- Baud Rate Generator
Generic (
   Baud_Rate  : integer;   -- Effective Baud Rate of the protocol [bps]
   CLK_Period : integer   -- Input clock period [ns]
);
Port(	
   CLK_Input  : in std_logic;
   RST_Input  : in std_logic;
   Trigger    : out std_logic
);
End BRG;                                       

Architecture Behavioral of BRG is

constant Baud_Counter_Size : integer := integer(ceil(log2(real((10**9)/(Baud_Rate*CLK_Period))))); -- Calculate the required bitsize of the main counter
constant Baud_Counter_Init : integer := integer(ceil(real((10**9)/(Baud_Rate*CLK_Period))));       -- Calculate the init/reset value of the main counter

signal Baud_Counter : std_logic_vector ( Baud_Counter_Size downto 0 ) := 
                      std_logic_vector ( to_unsigned (Baud_Counter_Init-2,Baud_Counter_Size+1));     -- Main counter for the baud rate
signal Trigger_int  : std_logic := '0';                                                            -- internal Trigger signal

begin

Process (CLK_Input, RST_Input)
begin
if rising_edge ( CLK_Input ) then
   if RST_Input = '1' then
      Trigger_int  <= '0';
	  Baud_Counter <= std_logic_vector ( to_unsigned (Baud_Counter_Init-2,Baud_Counter_Size+1));
   else
      if Baud_Counter(Baud_Counter'high) = '1' then
	     Trigger_int  <= '1';
		 Baud_Counter <= std_logic_vector ( to_unsigned (Baud_Counter_Init-2,Baud_Counter_Size+1));
	  else
	     Trigger_int  <= '0';
		 Baud_Counter <= std_logic_vector (unsigned (Baud_Counter) - 1);
	  end if;
   end if;
end if;
end process;

Trigger <= Trigger_int;

end Behavioral;
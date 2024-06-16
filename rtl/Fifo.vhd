
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fifo is
Generic (
Reset_Pol_W      : std_logic := '1';   -- Active polarity for the Reset signal A (W)
Reset_Pol_R      : std_logic := '1';   -- Active polarity for the Reset signal B (R)
Sync_Reset       : boolean   := True;
Width            : natural   := 8;     -- Input/Output data bit size
Depth            : natural   := 8;     -- Number of FIFO elements = 2**FIFO_Depth
A_Full_Treshold  : natural   := 1;       
A_Empty_Treshold : natural   := 1;  
Read_Protect     : boolean   := False; -- Set to True if Writing and Reading from the same address is not allowed 
Sync_Read        : boolean   := True   -- Set to True to add a register after reading data from the memory -> Might reduce performance to gain stability
                                       --     This mode is always Read Protected
);
Port (
-- Input A
A_CLK      : in std_logic;                                     -- Input Clock
A_Wr       : in std_logic;                                     -- Write Strobe
A_Data     : in std_logic_vector (Width - 1 downto 0);         -- Input Data
A_Full     : out std_logic;                                    -- FIFO Full
A_AFull    : out std_logic;                                   -- FIFO Almost Full
A_Reset    : in std_logic;                                     -- Synchronous Reset

-- Output B
B_CLK      : in std_logic;                                     -- Output Clock
B_Rd       : in std_logic;                                     -- Read Strobe
B_Rd_Valid : out std_logic;                                    -- Read Valid Flag -> Always Active on '1'!
B_Data     : out std_logic_vector (Width - 1 downto 0);        -- Output Data
B_Empty    : out std_logic;                                    -- FIFO Empty
B_AEmpty   : out std_logic;                                    -- FIFO Almost Empty
B_Reset    : in std_logic                                      -- Synchronous Reset
);
end ;

architecture Behavioral of Fifo is

signal Wptr_Last    : std_logic_vector ( Depth downto 0 );
signal Wptr         : std_logic_vector ( Depth downto 0 );
signal Diff_Full    : std_logic_vector ( Depth downto 0 );
signal Full_Check   : std_logic;
signal Write_Strobe : std_logic;

signal Rptr         : std_logic_vector ( Depth downto 0 );
signal Rptr_Next    : std_logic_vector ( Depth downto 0 );
signal Raddr        : std_logic_vector ( Depth - 1 downto 0 );
signal Diff_Empty   : std_logic_vector ( Depth downto 0 );
signal Empty_Check  : std_logic;
signal Read_Strobe  : std_logic;

Type mem is array (0 to 2**Depth - 1) of std_logic_vector (Width - 1 downto 0);
signal Memory : mem;

begin

-- Register the Write Address
Process (A_CLK, A_Reset)
begin
if (A_Reset = Reset_Pol_W) and (not Sync_Reset) then
	Wptr_Last     <= (others => '1');
	Wptr          <= (others => '0');
elsif rising_edge (A_CLK) then
   if (A_Reset = Reset_Pol_W) and (Sync_Reset) then 
		Wptr_Last     <= (others => '1');
		Wptr          <= (others => '0');
	else
		if Write_Strobe = '1' then
			Wptr_Last     <= Wptr;
			Wptr          <= std_logic_vector (unsigned (Wptr) + 1);
		end if;	
	end if;	
end if;
End process;

-- Write Strobe logic
Write_Strobe <= A_Wr and (not Full_Check);	

-- Full flag logic
Diff_full  <= std_logic_vector ( unsigned (Wptr) - unsigned (Rptr) );
Full_Check <= Diff_full (Diff_full'high);	
A_Full     <= Full_Check;

AFULL_Flag_Enabled: if A_Full_Treshold > 0 generate
	signal Diff_Afull : std_logic_vector (Wptr'range);
	signal AFull_int  : std_logic;
begin
	Diff_Afull <= std_logic_vector (unsigned (Wptr) - unsigned (Rptr) + A_Full_Treshold);
	AFull_int  <= Diff_Afull (Diff_Afull'high);
	A_AFull    <= AFull_int;
End Generate;

AFULL_Flag_Disabled: if A_Full_Treshold = 0 generate
	A_AFull <= '0';
End Generate;
			 

-- Write to the FIFO
Process (A_CLK)
begin
if rising_edge (A_CLK) then
   if Write_Strobe = '1' then
      Memory (to_integer(unsigned(Wptr(Wptr'high - 1 downto 0)))) <= A_Data;
	end if;	
end if;
End process;

-- Read Strobe logic
Read_Strobe    <= B_Rd and (not Empty_Check);
B_Rd_Valid     <= Read_Strobe;				

-- Register the Read Address 
Process (B_CLK, B_Reset)
begin
if (B_Reset = Reset_Pol_R) and (not Sync_Reset) then
	Rptr      <= (others => '0');
	Rptr_Next <= std_logic_vector (to_unsigned (1, Rptr_Next'length));
elsif rising_edge (B_CLK) then
	if (B_Reset = Reset_Pol_R) and (Sync_Reset) then 
		Rptr      <= (others => '0');
	    Rptr_Next <= std_logic_vector (to_unsigned (1, Rptr_Next'length));
	else	
		if Read_Strobe = '1' then
			Rptr      <= Rptr_Next;
			Rptr_Next <= std_logic_vector (unsigned (Rptr_Next) + 1);
		end if;	
	end if;	
end if;
End process;

-- Empty flag logic
Diff_empty  <= std_logic_vector ( unsigned (Wptr_last) - unsigned (Rptr) );
Empty_Check <= Diff_empty (Diff_empty'high);
B_Empty     <= Empty_Check;

AEmpty_Flag_Enabled: if A_Empty_Treshold > 0 generate
	signal Diff_AEmpty : std_logic_vector (Rptr'range);
	signal AEmpty_int  : std_logic;
begin
	Diff_AEmpty  <= std_logic_vector ( unsigned (Wptr_last) - unsigned (Rptr) - A_Empty_Treshold);
	AEmpty_int   <= Diff_AEmpty (Diff_AEmpty'high);
	B_AEmpty     <= AEmpty_int;
End generate;

AEmpty_Flag_Disabled: if A_Empty_Treshold = 0 generate
	B_AEmpty <= '0';
End generate;
					
-- Read from the memory
Process (B_CLK)
begin
if rising_edge (B_CLK) then
    B_Data <= Memory (to_integer(unsigned(Raddr)));
end if;
End process;

Raddr <= Rptr_next (Rptr_next'high - 1 downto 0) when Read_Strobe = '1' else Rptr (Rptr'high - 1 downto 0);
						

end Behavioral;
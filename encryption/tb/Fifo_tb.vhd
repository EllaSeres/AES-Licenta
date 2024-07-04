library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity Fifo_tb is
end entity;
  
architecture sim of Fifo_tb is
  
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    --constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	constant ClockPeriod : time := 10 ns;
	constant roundnr     : std_logic_vector(3 downto 0) := x"1";
  
    signal clk                 : std_logic := '1';
    signal reset               : std_logic := '0';
	
    signal Reset_Pol_W         : std_logic := '1';   
    signal Reset_Pol_R         : std_logic := '1';  
    signal Sync_Reset          : boolean   := True;
    signal Width               : natural   := 8;     
    signal Depth               : natural   := 8;     
    signal A_Full_Treshold     : natural   := 1;       
    signal A_Empty_Treshold    : natural   := 1;  
    signal Read_Protect        : boolean   := False; 
    signal Sync_Read           : boolean   := True ;

    signal A_CLK      :  std_logic;                                     -- Input Clock
    signal A_Wr       :  std_logic;                                     -- Write Strobe
    signal A_Data     :  std_logic_vector (Width - 1 downto 0);         -- Input Data
    signal A_Full     :  std_logic;                                    -- FIFO Full
    signal A_AFull    :  std_logic;                                   -- FIFO Almost Full
    signal A_Reset    :  std_logic;                                     -- Synchronous Reset


    signal B_CLK      :  std_logic;                                     -- Output Clock
    signal B_Rd       :  std_logic;                                     -- Read Strobe
    signal B_Rd_Valid :  std_logic;                                    -- Read Valid Flag -> Always Active on '1'!
    signal B_Data     :  std_logic_vector (Width - 1 downto 0);        -- Output Data
    signal B_Empty    :  std_logic;                                    -- FIFO Empty
    signal B_AEmpty   :  std_logic;                                    -- FIFO Almost Empty
    signal B_Reset    :  std_logic                                     	
                                     
  
begin
    
    -- The Device Under Test (DUT)
    i_Gfunction : entity work.Gfunction(rtl)
	generic map (
		                       
		Reset_Pol_W       =>     Reset_Pol_W,   
		Reset_Pol_R       =>     Reset_Pol_R,
		Sync_Reset        =>     Sync_Reset,
		Width             =>     Width ,
		Depth             =>     Depth,
		A_Full_Treshold   =>     A_Full_Treshold,
		A_Empty_Treshold  =>     A_Empty_Treshold,
		Read_Protect      =>     Read_Protect,
		Sync_Read         =>     Sync_Read
			
	)
    port map (
	
	        A_CLK    =>   clk,
	        A_Wr     =>   A_Wr,  
	        A_Data   =>   A_Data, 
	        A_Full   =>   A_Full,
	        A_AFull  =>   A_AFull,
	        A_Reset  =>   reset,
	
			B_CLK       =>  clk,
			B_Rd        =>  B_Rd ,
			B_Rd_Valid  =>  B_Rd_Valid,
		    B_Data      =>  B_Data ,
			B_Empty     =>  B_Empty, 
			B_AEmpty    =>  B_AEmpty,
			B_Reset     =>  reset
		    
		);
  
  
    -- Process for generating clock
    clk <= not clk after ClockPeriod / 2;
	
	process(clk) is
    begin
		 if rising_edge(Clk) then
			if reset = '0' then
			else
			   if A_Full = '0' then
			   else
			   
			   end if
			end if;
		 end if;
        
    end process;
	
    -- Testbench sequence
    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
  
        -- Take the DUT out of reset
        reset <= '1';
		wait until rising_edge(clk);
        wait until rising_edge(clk);
		
        wait;
    end process;
  
end architecture;
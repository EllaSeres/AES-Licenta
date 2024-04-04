library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity MixColumn_tb is
end entity;
  
architecture sim of MixColumn_tb is
  
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
  
    signal clk          : std_logic := '1';
    signal reset        : std_logic := '0';
    signal inputmatrix  : matrix := (
    (X"85", X"6E", X"61", X"3C"),
    (X"19", X"13", X"E0", X"82"),
    (X"BC", X"26", X"85", X"EA"),
    (X"ED", X"8F", X"F6", X"C2")
   ); 
    signal outputmatrix : matrix ;
  
begin
    
    -- The Device Under Test (DUT)
    i_MixColumn : entity work.MixColumn(rtl)
    port map (
        clk          => clk,
        reset        => reset,
        inputmatrix  => inputmatrix,
		outputmatrix => outputmatrix
		);
  
    -- Process for generating clock
    clk <= not clk after ClockPeriod / 2;
	
	
    -- Testbench sequence
    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
  
        -- Take the DUT out of reset
        reset <= '1';
  
        wait;
    end process;
  
end architecture;
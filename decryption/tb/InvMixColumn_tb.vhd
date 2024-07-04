library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity InvMixColumn_tb is
end entity;
  
architecture sim of InvMixColumn_tb is
  
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    constant ClockPeriod : time := 10 ns;
  
    signal clk          : std_logic := '1';
    signal reset        : std_logic := '0';
	signal enable       : std_logic := '0';
	signal done         : std_logic ;
    signal inputmatrix  : matrix := (
    (X"47", X"40", X"A3", X"4C"),
    (X"37", X"D4", X"70", X"9F"),
    (X"94", X"E4", X"3A", X"42"),
    (X"ED", X"A5", X"A6", X"BC")
   ); 
    signal outputmatrix : matrix ;
  
begin
    
    -- The Device Under Test (DUT)
    i_InvMixColumn : entity work.InvMixColumn(rtl)
    port map (
        clk          => clk,
        reset        => reset,
		enable       => enable,
		done         => done,
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
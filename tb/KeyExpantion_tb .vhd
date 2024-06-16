library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity KeyExpantion_tb is
end entity;
  
architecture sim of KeyExpantion_tb is
  
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    --constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	constant ClockPeriod : time := 10 ns;
	constant counter    : std_logic_vector(3 downto 0) := x"0";
  
    signal clk                 : std_logic := '1';
    signal reset               : std_logic := '0';
    signal doneks              : std_logic := '0';
    signal enableks            : std_logic := '0';	
    signal inputmatrix         : matrix    :=  (
        (X"2b", X"28", X"ab", X"09"),
        (X"7e", X"ae", X"f7", X"cf"),
        (X"15", X"d2", X"15", X"4f"),
        (X"16", X"a6", X"88", X"3c")
        );     
    signal outputmatrix        : matrix ;
  
begin
    
    -- The Device Under Test (DUT)
    i_KeyExpantion : entity work.KeyExpantion(rtl)
    port map (
        clk          => clk,
        reset        => reset,
		enableks    => enableks,
		counter     => counter,
		doneks      => doneks,
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
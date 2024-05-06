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
	constant roundnr     : std_logic_vector(3 downto 0) := x"8";
  
    signal clk                 : std_logic := '1';
    signal reset               : std_logic := '0';
    signal doneall             : std_logic := '0';	
    signal inputmatrix         : matrix := (
    (X"0f", X"15", X"71", X"c9"),
    (X"47", X"d9", X"e8", X"59"),
    (X"0c", X"b7", X"ad", X"d6"),
    (X"af", X"7f", X"67", X"98")
    );  
    signal outputmatrix        : matrix ;
  
begin
    
    -- The Device Under Test (DUT)
    i_KeyExpantion : entity work.KeyExpantion(rtl)
    port map (
        clk          => clk,
        reset        => reset,
		doneall      => doneall,
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
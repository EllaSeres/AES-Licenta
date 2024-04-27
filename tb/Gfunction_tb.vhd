library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity Gfunction_tb is
end entity;
  
architecture sim of Gfunction_tb is
  
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	constant roundnr     : std_logic_vector(3 downto 0) := x"8";
  
    signal clk                 : std_logic := '1';
    signal reset               : std_logic := '0';
    signal inputarray          : MatrixRoworColumn := (x"7F",x"8D",x"29",x"2F");
    signal outputarray         : MatrixRoworColumn;
  
begin
    
    -- The Device Under Test (DUT)
    i_Gfunction : entity work.Gfunction(rtl)
	generic map(
	   roundnr => roundnr
	)
    port map (
        clk          => clk,
        reset        => reset,
        inputarray  => inputarray,
		outputarray => outputarray
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
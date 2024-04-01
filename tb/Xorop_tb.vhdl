library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity Xorop_tb is
end entity;
  
architecture sim of Xorop_tb is
  
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
  
    signal clk          : std_logic := '1';
    signal reset        : std_logic := '0';
    signal matrixword   : matrix ;
	signal matrixkey    : matrix;
    signal outputmatrix : matrix ;
  
begin
    
    -- The Device Under Test (DUT)
    i_ShiftRow : entity work.ShiftRow(rtl)
    port map (
        clk          => clk,
        reset        => reset,
        matrixword   => matrixword,
		matrixkey    => matrixkey,
		outputmatrix => outputmatrix
		);
  
    -- Process for generating clock
    clk <= not clk after ClockPeriod / 2;
	
	-- Matrix initalization
	process is
        variable value : natural := 16;
    begin
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                matrixword(i, j) <= std_logic_vector(to_unsigned(value, matrixword(i, j)'length));
                value := value + 1;
            end loop;
        end loop;
        wait;
    end process;
	
	-- Matrix initalization
	process is
        variable value : natural := 0;
    begin
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                matrixkey(i, j) <= std_logic_vector(to_unsigned(value, matrixkey(i, j)'length));
                value := value + 1;
            end loop;
        end loop;
        wait;
    end process;
  
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
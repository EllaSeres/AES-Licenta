library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity rUART_tb is
end entity;
  
architecture sim of rUART_tb is

    
  
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    --constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	constant ClockPeriod : time := 10 ns;
	constant counter     : std_logic_vector(3 downto 0) := x"0";
    
    -- signal clk                    : std_logic := '1';
    -- signal reset                  : std_logic := '0';
    -- signal inputmatrixaes         : matrix := (
    -- (X"01", X"89", X"fe", X"76"),
    -- (X"23", X"ab", X"dc", X"54"),
    -- (X"45", X"cd", X"ba", X"32"),
    -- (X"67", X"ef", X"98", X"10")
    -- );  
	-- signal key                    : matrix :=  (
    -- (X"0f", X"47", X"0c", X"af"),
    -- (X"15", X"d9", X"b7", X"7f"),
    -- (X"71", X"e8", X"ad", X"67"),
    -- (X"c9", X"59", X"d6", X"98")
    -- );  
    -- signal outputmatrixaes        : matrix ;

    signal i_clk                    : std_logic;
    signal i_reset                  : std_logic;
    signal i_inputmatrixaes         : matrix;
	signal i_key                    : matrix;
    signal o_outputmatrixaes        : matrix;
    signal i_input_en               : std_logic;
    signal o_done                   : std_logic;

    constant Input_Matrix_0 : matrix := (
        (X"ff", X"08", X"69", X"64"),
        (X"0b", X"53", X"34", X"14"),
        (X"84", X"bf", X"ab", X"8f"),
        (X"4a", X"7c", X"43", X"b9")
        ); 

    Component rUART is
--  Generic ( );
    generic(
        Clock_Freq     : integer   := 25e6;
        Baud_Rate      : integer   := 115200;
		Reset_Polarity : std_logic := '1'
    );
    --  Port ( );
    port(
        clock          : in  std_logic;
        reset          : in  std_logic;
        Rx             : in  std_logic;
        data_valid     : out std_logic;
        data_out       : out std_logic_vector(7 downto 0)
    );
end Component rUART;

begin
    
    -- The Device Under Test (DUT)
   rUART_instantiation : rUART
	Generic Map(
		Clock_Freq     => Clock_Freq,
		Baud_Rate      => Baud_Rate,
		Reset_Polarity => Reset_Polarity
	)
	Port Map(
		clock          => clock,
		reset          => reset,
		Rx             => Rx,
		data_valid     => Rx_data_out_valid,
		data_out       => Rx_data_out
	);
  
    -- Process for generating clock
    Clock_Generation: Process
    begin
        i_clk <= '0';
        wait for ClockPeriod/2;
        i_clk <= '1';
        wait for ClockPeriod/2;
    end process;
	
    -- Testbench sequence
    Stimuli: process
    begin
        -- Intial conditions
        i_reset            <= '0';
        i_input_en         <= '1';
        i_inputmatrixaes   <= MatrixZero;
        wait for 10*ClockPeriod;

        -- Deactivate the reset
        wait until rising_edge(i_clk);
        i_reset            <= '1';
        wait for 10*ClockPeriod;

        -- Feed matrix 0
        wait until rising_edge(i_clk);
        i_input_en         <= '0';
        i_inputmatrixaes   <= Input_Matrix_0;
		i_key              <= Key_0;
        wait until rising_edge(i_clk);
        i_input_en         <= '1';
        i_inputmatrixaes   <= MatrixZero;

        -- Aditional reset trigger
        --wait until rising_edge (o_done);
       -- wait until rising_edge(i_clk);
       -- i_reset            <= '0';
        --wait for 10*ClockPeriod;
        --wait until rising_edge(i_clk);
       -- i_reset            <= '1';
       -- wait for 10*ClockPeriod;

        -- Feed matrix 0 (again)
       -- wait until rising_edge(i_clk);
        --i_input_en         <= '0';
        --i_inputmatrixaes   <= Input_Matrix_0;
		--i_key              <= Key_0;
        --wait until rising_edge(i_clk);
        --i_input_en         <= '1';
       -- i_inputmatrixaes   <= MatrixZero;
 

        
  
        wait;
    end process;
  
end architecture;
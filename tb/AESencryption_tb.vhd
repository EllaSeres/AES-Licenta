library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity AESencryption_tb is
end entity;
  
architecture sim of AESencryption_tb is

    component AESencryption
    port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_key : in matrix;
        i_input_en : in std_logic;
        i_inputmatrixaes : in matrix;
        o_done : out std_logic;
        o_outputmatrixaes : out matrix
    );
    end component;
  
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
        (X"01", X"89", X"fe", X"76"),
        (X"23", X"ab", X"dc", X"54"),
        (X"45", X"cd", X"ba", X"32"),
        (X"67", X"ef", X"98", X"10")
        ); 

    constant Key_0 : matrix :=  (
        (X"0f", X"47", X"0c", X"af"),
        (X"15", X"d9", X"b7", X"7f"),
        (X"71", X"e8", X"ad", X"67"),
        (X"c9", X"59", X"d6", X"98")
        );     
  
begin
    
    -- The Device Under Test (DUT)
    i_AESencryption : entity work.AESencryption(rtl)
    port map (
        i_clk             => i_clk,
        i_reset           => i_reset,
		i_key             => i_key,
        i_input_en        => i_input_en,
		i_inputmatrixaes  => i_inputmatrixaes,
        o_done            => o_done,
		o_outputmatrixaes => o_outputmatrixaes
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
        wait until rising_edge (o_done);
        wait until rising_edge(i_clk);
        i_reset            <= '0';
        wait for 10*ClockPeriod;
        wait until rising_edge(i_clk);
        i_reset            <= '1';
        wait for 10*ClockPeriod;

        -- Feed matrix 0 (again)
        wait until rising_edge(i_clk);
        i_input_en         <= '0';
        i_inputmatrixaes   <= Input_Matrix_0;
		i_key              <= Key_0;
        wait until rising_edge(i_clk);
        i_input_en         <= '1';
        i_inputmatrixaes   <= MatrixZero;


        
  
        wait;
    end process;
  
end architecture;
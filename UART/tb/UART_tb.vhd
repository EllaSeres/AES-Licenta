library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity UART_tb is
end entity;
  
architecture sim of UART_tb is

    
  
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    --constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	constant ClockPeriod : time := 10 ns;
	constant Baud_Rate  : integer :=115200;
	constant Reset_Polarity : std_logic :='1';
	
    signal clk               : std_logic := '1';
    signal reset             : std_logic := '0';
    signal Rx_data_out       :  std_logic_vector ( 7 downto 0 );
	signal Rx_data_out_valid : std_logic;
    signal Rx                : std_logic;

   signal Tx_data_in        : std_logic_vector ( 7 downto 0 );
   signal Tx_data_in_valid  : std_logic;
   signal Tx_done           : std_logic;
   signal Tx                : std_logic;

    Generic(
Clock_Freq        : integer   := 25e6;
Baud_Rate         : integer   := 115200;
Reset_Polarity    : std_logic := '1'
);
--  Port ( );
Port(
clock             : in std_logic;
reset             : in std_logic;


);
begin


     i_UART : entity work.UART(rtl)
	generic map(
		Clock_Freq  => ClockFrequencyHz ,    
        Baud_Rate   => Baud_Rate  ,    
        Reset_Polarity  => Reset_Polarity  
	)
    port map (
        clock         => clk,
        reset        => reset,
		
		Rx_data_out       => Rx_data_out,
        Rx_data_out_valid =>Rx_data_out,
        Rx                => Rx,

      Tx_data_in        => Tx_data_in,
      Tx_data_in_valid  =>Tx_data_in_valid,
      Tx_done           => Tx_done,
      Tx               =>Tx,
		
	);
    
   
    -- Process for generating clock
    Clock_Generation: Process
    begin
        clk <= '0';
        wait for ClockPeriod/2;
        clk <= '1';
        wait for ClockPeriod/2;
    end process;
	
    -- Testbench sequence
    Stimuli: process
    begin
        -- Intial conditions
        reset            <= '0';
        wait for 10*ClockPeriod;

        -- Deactivate the reset
        wait until rising_edge(i_clk);
        reset            <= '1';
        wait for 10*ClockPeriod;

        -- Feed matrix 0
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
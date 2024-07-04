library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;

entity Final_tb is
end entity;
  
architecture sim of Final_tb is

    
    -- We are using a low clock frequency to speed up the simulation
    constant ClockFrequencyHz : integer := 100; -- 100 Hz
    --constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	constant ClockPeriod : time := 10 ns;
	constant counter     : std_logic_vector(3 downto 0) := x"0";
    
   

    signal i_clk                    : std_logic;
    signal i_reset                  : std_logic;
    signal i_input_en               : std_logic;
    signal o_done                   : std_logic;
	
    signal inputdata          :  DataArray;
    signal inputkey           : DataArray;
    signal switch             :  std_logic := '0';
	signal outputdata         :  DataArray;

    constant Input_Array : DataArray := (
        X"ff", X"08", X"69", X"64",
        X"0b", X"53", X"34", X"14",
        X"84", X"bf", X"ab", X"8f",
        X"4a", X"7c", X"43", X"b9"
        ); 

    constant Key_Array : DataArray:=  (
        X"0f", X"47", X"0c", X"af",
        X"15", X"d9", X"b7", X"7f",
        X"71", X"e8", X"ad", X"67",
        X"c9", X"59", X"d6", X"98"
        );     
  
begin

   
    
    -- The Device Under Test (DUT)
	 i_Final : entity work.Final(rtl)
    port map (
        clk             => i_clk,
        reset           => i_reset,
		enable          => i_input_en,
		done            => o_done,
		inputdata       => inputdata,
		inputkey        => inputkey,
		switch          => switch ,
		outputdata     =>  outputdata
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
        wait for 10*ClockPeriod;

        -- Deactivate the reset
        wait until rising_edge(i_clk);
        i_reset            <= '1';
        wait for 10*ClockPeriod;

        -- Feed matrix 0
        wait until rising_edge(i_clk);
        i_input_en         <= '0';
        inputdata  <= Input_Array;
		inputkey    <= Key_Array;
        wait until rising_edge(i_clk);
        i_input_en         <= '1';
      
	  
       

        
  
        wait;
    end process;
  
end architecture;
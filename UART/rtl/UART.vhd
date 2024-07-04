library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

Entity UART is
--  Generic ( );
Generic(
Clock_Freq        : integer   := 25e6;
Baud_Rate         : integer   := 115200;
Reset_Polarity    : std_logic := '1'
);
--  Port ( );
Port(
clock             : in std_logic;
reset             : in std_logic;

Rx_data_out       : out std_logic_vector ( 7 downto 0 );
Rx_data_out_valid : out std_logic;
Rx                : in std_logic;

Tx_data_in        : in std_logic_vector ( 7 downto 0 );
Tx_data_in_valid  : in std_logic;
Tx_done           : out std_logic;
Tx                : out std_logic
);
End Entity;

Architecture RTL of UART is
-------------------------------------------------------------------------------
---                        Component Declaration                            ---
-------------------------------------------------------------------------------	
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

Component tUART is
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
        data_valid     : in  std_logic;  -- If data_valid is 1 ( button pressed ), go to next state
        data_in        : in  std_logic_vector(7 downto 0);
        data_active    : out std_logic;
        Tx_done        : out std_logic;
        Tx             : out std_logic  -- Tx line
    );
end Component tUART;


Begin


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
	
tUART_instantiation : tUART
	Generic Map(
		Clock_Freq     => Clock_Freq,
		Baud_Rate      => Baud_Rate,
		Reset_Polarity => Reset_Polarity
	)
    Port Map(
        clock          => clock,
        reset          => reset,
        data_valid     => Tx_data_in_valid,
        data_in        => Tx_data_in,
        data_active    => Open,
        Tx_done        => Tx_done,
        Tx             => Tx
    );

End RTL;
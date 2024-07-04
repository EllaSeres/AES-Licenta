-- High speed UART interface with very basic configuration
-- Parity       : None
-- Stop_Bits    : 1
-- Data_Bits    : 8
-- Baud_Rate    : User Defined
-- RST Polarity : '1'
-----------------------------------------------------------
-- Commonly used Baud rates -------------------------------
-- 50      [bit/s]	
-- 110     [bit/s]	
-- 150     [bit/s]	
-- 300     [bit/s]	
-- 1.200   [bit/s]	
-- 2.400   [bit/s]	
-- 4.800   [bit/s]	
-- 9.600   [bit/s]	
-- 19.200  [bit/s]	
-- 38.400  [bit/s]	
-- 57.600  [bit/s]	
-- 115.200 [bit/s]	
-- 230.400 [bit/s]	
-- 460.800 [bit/s]	
-- 921.600 [bit/s]	
-- 2.000.000 [bit/s]
-- 3.000.000 [bit/s]
-----------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity UART_IF is 
Generic (
   Baud_Rate  : integer   := 115200;   -- Effective Baud Rate of the protocol [bps]
   CLK_Period : integer   := 20        -- Input clock period [ns]
);
Port(	
   CLK_Input  : in std_logic;
   RST_Input  : in std_logic;
   
   Data_Input : in std_logic_vector ( 7 downto 0 );  -- Data to transmit
   Transmit   : in std_logic;                        -- Data input valid flag
   Data_Output: out std_logic_vector ( 7 downto 0 ); -- Received data
   Rx_Valid   : out std_logic;                       -- Received Data Valid flag
   
   TX_Busy    : out std_logic;
   RX_Error   : out std_logic;
   
   RX : in std_logic;
   TX : out std_logic
);
End UART_IF;                                       

Architecture Behavioral of UART_IF is

Component RX_Module  -- RX Module
Generic (
   Baud_Rate  : integer;   -- Effective Baud Rate of the protocol [bps]
   CLK_Period : integer    -- Input clock period [ns]
);   
Port(	
   CLK_Input    : in std_logic;                                                
   RST_Input    : in std_logic;
   Baud_Trigger : in std_logic; 
   RX_in        : in std_logic;
   Word_Valid   : out std_logic;       
   Data_Output  : out std_logic_vector ( 7 downto 0 );
   RX_Error     : out std_logic;
   Clear        : out std_logic
);
End Component;

Component TX_module  -- TX Module
Port(	
   CLK_Input    : in std_logic;                                                
   RST_Input    : in std_logic;
   Transmit     : in std_logic;       
   Baud_Trigger : in std_logic;  
   Data_Input   : in std_logic_vector ( 7 downto 0 );
   Busy         : out std_logic;
   TX_Out       : out std_logic
);
End Component;  

Component BRG -- Baud Rate Generator
Generic (
   Baud_Rate  : integer;   -- Effective Baud Rate of the protocol [bps]
   CLK_Period : integer   -- Input clock period [ns]
);
Port(	
   CLK_Input  : in std_logic;
   RST_Input  : in std_logic;
   Trigger    : out std_logic
);
End Component;      

signal RX_Baud_Trigger : std_logic;
signal RX_Baud_RST     : std_logic;
signal RX_Clear        : std_logic;
signal TX_Baud_Trigger : std_logic;


begin

Baud_Rate_Gen_TX: BRG
Generic map (
   Baud_Rate  => Baud_Rate,
   CLK_Period => CLK_Period
)
Port map(
   CLK_Input  => CLK_Input,
   RST_Input  => RST_Input,
   Trigger    => TX_Baud_Trigger
);  

Baud_Rate_Gen_RX: BRG
Generic map (
   Baud_Rate  => Baud_Rate,
   CLK_Period => CLK_Period
)
Port map(
   CLK_Input  => CLK_Input,
   RST_Input  => RX_Baud_RST,
   Trigger    => RX_Baud_Trigger
);         

RX_Comp: RX_module  
Generic map (
   Baud_Rate  => Baud_Rate,
   CLK_Period => CLK_Period
)
Port map(	
   CLK_Input    => CLK_Input,
   RST_Input    => RST_Input,
   Baud_Trigger => RX_Baud_Trigger,
   RX_in        => RX,
   Word_Valid   => Rx_Valid,     
   Data_Output  => Data_Output,
   RX_Error     => RX_Error,
   Clear        => RX_Clear
);

TX_Comp: TX_module  
Port map(	
   CLK_Input    => CLK_Input,
   RST_Input    => RST_Input,
   Transmit     => Transmit,      
   Baud_Trigger => TX_Baud_Trigger,  
   Data_Input   => Data_Input,
   Busy         => TX_Busy,
   TX_Out       => TX
);                         

RX_Baud_RST <= RX_Clear or RST_Input;

End Behavioral;
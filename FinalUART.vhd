library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity FinalUART is
   Generic(
		CLK_Period       : integer   := 10;
		Baud_Rate        : integer   := 115200
		);
	Port(
    clk                : in std_logic;
    reset              : in std_logic; 
	enable             : in std_logic;
	done               : out std_logic;
    donedata           : out std_logic;
	donekey            : out std_logic;
    switch             : in std_logic;
	Rx                 : in std_logic;
	Tx                : out std_logic
	);
end entity;



  
architecture rtl of FinalUART is
       
	    
		signal inputdata     : DataArray;
		signal inputkey      : DataArray;
		signal outputdata    : DataArray;
		signal en            : std_logic;
		signal dn            : std_logic;
		type t_State is ( Idle,Check ,preReset1,preReset2,ByteData2Array,ByteKey2Array,EncrorDcr,Array2Bite,Finish,SetBack);
        signal State : t_State;
		signal Data_Input : std_logic_vector ( 7 downto 0 );
		signal Transmit   :  std_logic;  
		signal Data_Output:  std_logic_vector ( 7 downto 0 );
		signal Rx_Valid   : std_logic; 
		signal TX_Busy    : std_logic;
		signal RX_Error   : std_logic;
		signal notrst     : std_logic := not reset ;
		
		attribute MARK_DEBUG : string;
		
		attribute MARK_DEBUG of reset         : signal is "TRUE";
		attribute MARK_DEBUG of enable        : signal is "TRUE";
		attribute MARK_DEBUG of Tx            : signal is "TRUE";
		attribute MARK_DEBUG of Rx            : signal is "TRUE";
		attribute MARK_DEBUG of donedata      : signal is "TRUE";
		attribute MARK_DEBUG of donekey       : signal is "TRUE";
		attribute MARK_DEBUG of State         : signal is "TRUE";
		attribute MARK_DEBUG of Data_Input    : signal is "TRUE";
		attribute MARK_DEBUG of Transmit      : signal is "TRUE";
		attribute MARK_DEBUG of Data_Output   : signal is "TRUE";
		attribute MARK_DEBUG of switch        : signal is "TRUE";
		attribute MARK_DEBUG of outputdata    : signal is "TRUE";
		attribute MARK_DEBUG of inputdata     : signal is "TRUE";
   
begin
      

	  
      i_Final : entity work.Final(rtl)
		port map (
        clk             => clk,
        reset           => reset,
		enable          => en,
		done            => dn,
		inputdata       => inputdata,
		inputkey        => inputkey,
		switch          => switch ,
		outputdata     =>  outputdata
		);
		
		i_UART_IF : entity work.UART_IF(Behavioral)
		generic map(
		   Baud_Rate => Baud_Rate,
		   CLK_Period => CLK_Period
	      )
        port map (
			CLK_Input   => clk,
			RST_Input   => notrst,
			Data_Input  =>  Data_Input,
		    Transmit    =>  Transmit ,
			Data_Output => Data_Output,
			Rx_Valid    => Rx_Valid,
			TX_Busy    => TX_Busy, 
			RX_Error  =>  RX_Error,
			RX => Rx,
			TX => Tx
        
		);
	
    process(clk) 
		variable i1  : std_logic_vector(4 downto 0) ;
		variable i2  : std_logic_vector(4 downto 0) ;
		variable i3  : std_logic_vector(4 downto 0) ;
		variable done1 : std_logic;
		variable done2 : std_logic;
    begin 
        if rising_edge(clk) then
            if reset = '0' then
              i1 := (others => '0'); -- Reset i
			  i2 := (others => '0'); -- Reset i
			  i3 := (others => '0'); -- Reset i
			  done1 := '0';
			  done2 := '0';
			  done <= '0';
			  en <= '1';
			  State <= preReset1;
			  Transmit <= '0';
			  Data_Input <= (others => '0');
			 
            else
				done     <= '0';
				en      <= '1';
                Transmit <= '0';
				case State is
				   when preReset1 =>
				   Transmit <= '1';
				   Data_Input  <=  X"DE";
				   if TX_Busy = '1' then
				   State <=preReset2;
				   end if;
				   when preReset2 =>
				   if TX_Busy = '0' then
				      Transmit <= '1';
					  Data_Input  <=  X"DE";
					  State <=Idle;
					end if;
				    
					when Idle =>
						if enable = '0' then
							State <= Check;	
						end if; 
					when Check =>
						if to_integer(unsigned(i1)) <= 15 then
							 if  Rx_Valid = '1' then
							 State <= ByteData2Array;
							 end if;
						elsif to_integer(unsigned(i2)) <= 15 then
						      donedata <='1';
						      if  Rx_Valid = '1' then
								State <= ByteKey2Array;
							 end if;
						elsif done1 = '0' then
						     donekey <= '1';
						     en <= '0';
							 State<= EncrorDcr;
						elsif  to_integer(unsigned(i3)) <= 15 then
						   if   to_integer(unsigned(i3)) = 0 then
							 State <= Array2Bite;
						   elsif TX_Busy ='0' then
							    State <= Array2Bite;
						   end if;
						elsif done2 =  '0'  then
						     State <= Finish;
						else
						     State <= SetBack;
						end if;
			   
			        when ByteData2Array  =>
						 inputdata(to_integer(unsigned(i1))) <= Data_Output;
						 i1 := std_logic_vector(unsigned(i1) + 1); 
						 State <= Check;
					 when ByteKey2Array  =>
						 inputkey(to_integer(unsigned(i2))) <= Data_Output;
						 i2 := std_logic_vector(unsigned(i2) + 1); 
						 State <= Check;
					
                    when EncrorDcr  =>
					    if dn = '1' then
						   done1 := '1';
						   State <= Check;
						end if;
					 when Array2Bite =>
					       Transmit<= '1';
					       Data_Input<= outputdata(to_integer(unsigned(i3)));
						   if TX_Busy = '1' then
						   i3:= std_logic_vector(unsigned(i3) + 1); 
						   State <= Check;
						   end if;
			        when Finish =>
						done2 := '1';
						done <= '1';
					    State <= Check;
						
					when SetBack =>
						done1 := '0';
						done2 := '0';
					    i1 := (others => '0');	
                        i2 := (others => '0');
                        i3 := (others => '0');	
                        donedata <= '0';
						donekey <= '0';
					    State <= Idle;
						
                    when others =>
				        State <= Idle;  						
			    end case;			  			
        end if;
      end if;
    end process;
         
end architecture;
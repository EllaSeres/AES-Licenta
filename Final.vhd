library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity Final is
	Port(
    clk                : in std_logic;
    reset              : in std_logic; 
	enable             : in std_logic;
	done               : out std_logic;
    inputdata          : in DataArray;
    inputkey           : in DataArray;
    switch             : in std_logic;
	outputdata         : out DataArray );
end entity;

  
architecture rtl of Final is
       
	    signal inputmatrix : matrix;
		signal outputmatrix1   : matrix;
		signal outputmatrix2   : matrix;
		signal keymatrix   : matrix;
		signal idlearray   : DataArray;
		signal idlekey     : DataArray;
		signal enableen     : std_logic;
		signal  doneen     : std_logic;
		signal enablede     : std_logic;
		signal  donede      : std_logic;
		type t_State is ( Idle,Check ,Array2Matrix,Key2Matrix,Encr,Decr,Matrix2ArrayEncr,Matrix2ArrayDecr,Finish,SetBack);
        signal State : t_State;
		
   
begin
     i_AESencryption : entity work.AESencryption(rtl)
		port map (
			i_clk             => clk,
			i_reset           => reset,
			i_key             => keymatrix,
			i_input_en        => enableen,
			i_inputmatrixaes  => inputmatrix,
			o_done            => doneen,
			o_outputmatrixaes => outputmatrix1
			);
		
		 i_AESdecryption : entity work.AESdecryption(rtl)
			port map (
				i_clk             => clk,
				i_reset           => reset,
				i_key             => keymatrix,
				i_input_en        => enablede,
				i_inputmatrixaes  => inputmatrix,
				o_done            => donede,
				o_outputmatrixaes => outputmatrix2
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
              inputmatrix <= ((others => (others => '0')),(others => (others => '0')),(others => (others => '0')),(others => (others => '0')));
			  keymatrix <= ((others => (others => '0')),(others => (others => '0')),(others => (others => '0')),(others => (others => '0')));
              i1 := (others => '0'); -- Reset i
			  i2 := (others => '0'); -- Reset i
			  i3 := (others => '0'); -- Reset i
			  done1 := '0';
			  done2 := '0';
			  done <= '0';
			  enableen <= '1';
			  enablede <= '1';
			  State <= Idle;
            else
				done <= '0';
				enableen <= '1';
				enablede <= '1';
				case State is
					when Idle =>
						if enable = '0' then
							idlearray <= inputdata;
							idlekey <= inputkey;
							State <= Check;	
						end if; 
					when Check =>
						if to_integer(unsigned(i1)) <= 15 then
							 State <= Array2Matrix;
						elsif to_integer(unsigned(i2)) <= 15 then
						     State <= Key2Matrix;
						elsif switch = '0' then
						    if done1 = '0' then
						     enableen <='0';
							 State <= Encr;
							elsif to_integer(unsigned(i3)) <= 15 then
								State <= Matrix2ArrayEncr;
							elsif done2= '0' then
								State <= Finish;
							else 
							    State <= SetBack;
							end if;
						elsif switch ='1' then
							if done1 = '0' then
						     enablede <='0';
							 State <= Decr;
							elsif to_integer(unsigned(i3)) <= 15 then
								State <= Matrix2ArrayDecr;
							elsif done2= '0' then
								State <= Finish;
							else 
							    State <= SetBack;
							end if;
						end if;
			   
			        when Array2Matrix =>
						 for k in 0 to 3 loop
							for j in 0 to 3 loop
									inputmatrix(k,j) <= idlearray(to_integer(unsigned(i1)));
									i1 := std_logic_vector(unsigned(i1) + 1); 
							 end loop;
						 end loop;
					     	State <= Check;
					 when Key2Matrix =>
						 for k in 0 to 3 loop
							for j in 0 to 3 loop
									keymatrix(k,j) <= idlekey(to_integer(unsigned(i2)));
									i2 := std_logic_vector(unsigned(i2) + 1); 
							 end loop;
						 end loop;
						 	State <= Check;
					when Encr=>
						if doneen = '1' then
							done1 := '1';
							State <= Check;
						end if;
					when Decr=>
						if donede = '1' then
							done1 := '1';
							State <= Check;
						end if;
                    when Matrix2ArrayEncr =>
					 for k in 0 to 3 loop
							for j in 0 to 3 loop
									idlearray(to_integer(unsigned(i3))) <= outputmatrix1(k,j);
									i3 := std_logic_vector(unsigned(i3) + 1); 
							 end loop;
						 end loop;
						  	State <= Check;
					 when Matrix2ArrayDecr =>
					 for k in 0 to 3 loop
							for j in 0 to 3 loop
									idlearray(to_integer(unsigned(i3))) <= outputmatrix2(k,j);
									i3 := std_logic_vector(unsigned(i3) + 1); 
							 end loop;
						 end loop;
						  	State <= Check;
			        when Finish =>
						done2 := '1';
						done <= '1';
						outputdata<= idlearray;
						done  <= '1';
					    State <= Check;
						
					when SetBack =>
						done1 := '0';
						done2 := '0';
						inputmatrix <= ((others => (others => '0')),(others => (others => '0')),(others => (others => '0')),(others => (others => '0')));
						keymatrix <= ((others => (others => '0')),(others => (others => '0')),(others => (others => '0')),(others => (others => '0')));
						
					    i1 := (others => '0');	
                        i2 := (others => '0');
                        i3 := (others => '0');							
					    State <= Idle;
						
                    when others =>
				        State <= Idle;  						
			    end case;			  			
        end if;
      end if;
    end process;
         
end architecture;
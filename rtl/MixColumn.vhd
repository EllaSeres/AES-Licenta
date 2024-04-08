library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity MixColumn is
	Port(
    clk                : in std_logic;
    reset              : in std_logic;  
    inputmatrix        : in  matrix ;
    outputmatrix       : out matrix 	);
end entity;

  
architecture rtl of MixColumn is
       
	    signal resultmatrix : matrix;
		signal const1  : std_logic_vector (7 downto 0):= "00000001";
		signal const2  : std_logic_vector (7 downto 0):= "00000010";	
		signal const3  : std_logic_vector (7 downto 0):= "00000011";
		type ist_array is array (0 to 3) of std_logic_vector(7 downto 0);  
			
		
		
		procedure Mix(
								signal element1                    :  in  std_logic_vector(7 downto 0);
								signal element2                    :  in  std_logic_vector(7 downto 0);
								signal element3                    :  in  std_logic_vector(7 downto 0);
								signal element4                    :  in  std_logic_vector(7 downto 0);
								signal constant1                   :  in  std_logic_vector(7 downto 0);
								signal constant2                   :  in  std_logic_vector(7 downto 0);
								signal constant3                   :  in  std_logic_vector(7 downto 0);
								signal constant4                   :  in  std_logic_vector(7 downto 0);
								signal outputvalue                 :  out  std_logic_vector(7 downto 0)
							    ) is
								
								variable final                     :    std_logic_vector(8 downto 0):= "000000000";
							    variable elements                  :    ist_array:= (element1,element2,element3,element4);
                                variable element                   :    std_logic_vector(8 downto 0):= "000000000";
								variable const                     :    ist_array := (constant1,constant2,constant3,constant4);
								

								variable ireducablepolinomial      :    std_logic_vector(8 downto 0) := "100011011";
								
								
								
		 begin
		 
			for  i in 0 to 3 loop
			   
				if const(i) = "00000001" then
					element:='0' & elements(i);
					final := final xor element;
				elsif const(i) = "00000010" then
					element:=elements(i) & '0';
					final := final xor element;
				else
				   element:='0' & elements(i);
				   final := final xor element;
				   element:=elements(i) & '0';
				   final := final xor element;
					
				end if;	
					
			end loop;
			
			 if final(final'high )= '1' then
				final := final xor ireducablepolinomial;
			 end if; 
			    outputvalue <= final(7 downto 0); 
				
        end procedure;
  
begin

    process(clk) 
	variable done                      :    std_logic := '0'	;
    begin  
        if rising_edge(Clk) then
            if reset = '0' then
                
            else
			   if done = '0' then
			       --First row of output matrix
                	Mix(inputmatrix(0,0),inputmatrix(1,0),inputmatrix(2,0),inputmatrix(3,0), const2,const3,const1,const1,resultmatrix(0,0));
					Mix(inputmatrix(0,1),inputmatrix(1,1),inputmatrix(2,1),inputmatrix(3,1), const2,const3,const1,const1,resultmatrix(0,1));
					Mix(inputmatrix(0,2),inputmatrix(1,2),inputmatrix(2,2),inputmatrix(3,2), const2,const3,const1,const1,resultmatrix(0,2));
					Mix(inputmatrix(0,3),inputmatrix(1,3),inputmatrix(2,3),inputmatrix(3,3), const2,const3,const1,const1,resultmatrix(0,3));
					
					--Second row of output matrix
					Mix(inputmatrix(0,0),inputmatrix(1,0),inputmatrix(2,0),inputmatrix(3,0), const1,const2,const3,const1,resultmatrix(1,0));
					Mix(inputmatrix(0,1),inputmatrix(1,1),inputmatrix(2,1),inputmatrix(3,1), const1,const2,const3,const1,resultmatrix(1,1));
					Mix(inputmatrix(0,2),inputmatrix(1,2),inputmatrix(2,2),inputmatrix(3,2), const1,const2,const3,const1,resultmatrix(1,2));
					Mix(inputmatrix(0,3),inputmatrix(1,3),inputmatrix(2,3),inputmatrix(3,3), const1,const2,const3,const1,resultmatrix(1,3));
					
					--Third row of output matrix
					Mix(inputmatrix(0,0),inputmatrix(1,0),inputmatrix(2,0),inputmatrix(3,0), const1,const1,const2,const3,resultmatrix(2,0));
					Mix(inputmatrix(0,1),inputmatrix(1,1),inputmatrix(2,1),inputmatrix(3,1), const1,const1,const2,const3,resultmatrix(2,1));
					Mix(inputmatrix(0,2),inputmatrix(1,2),inputmatrix(2,2),inputmatrix(3,2), const1,const1,const2,const3,resultmatrix(2,2));
					Mix(inputmatrix(0,3),inputmatrix(1,3),inputmatrix(2,3),inputmatrix(3,3), const1,const1,const2,const3,resultmatrix(2,3));
					
					--Forth row of output matrix
					Mix(inputmatrix(0,0),inputmatrix(1,0),inputmatrix(2,0),inputmatrix(3,0), const3,const1,const1,const2,resultmatrix(3,0));
					Mix(inputmatrix(0,1),inputmatrix(1,1),inputmatrix(2,1),inputmatrix(3,1), const3,const1,const1,const2,resultmatrix(3,1));
					Mix(inputmatrix(0,2),inputmatrix(1,2),inputmatrix(2,2),inputmatrix(3,2), const3,const1,const1,const2,resultmatrix(3,2));
					Mix(inputmatrix(0,3),inputmatrix(1,3),inputmatrix(2,3),inputmatrix(3,3), const3,const1,const1,const2,resultmatrix(3,3));
					done:='1';
                end if;
			
            end if;
        end if;
    end process;
         outputmatrix <= resultmatrix;
end architecture;
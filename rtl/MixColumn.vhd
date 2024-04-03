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
		signal const1  : std_logic (8 downto 0)= "000000001";
		signal const2  : std_logic (8 downto 0)= "000000010";	
		signal const3  : std_logic (8 downto 0)= "000000011";
		
		
		procedure Mix(
								signal element1                    :  in  std_logic_vector(7 downto 0);
								signal element2                    :  in  std_logic_vector(7 downto 0);
								signal element3                    :  in  std_logic_vector(7 downto 0);
								signal element4                    :  in  std_logic_vector(7 downto 0);
								signal constant1                   :  in  std_logic_vector(8 downto 0);
								signal constant2                   :  in  std_logic_vector(8 downto 0);
								signal constant3                   :  in  std_logic_vector(8 downto 0);
								signal constant4                   :  in  std_logic_vector(8 downto 0);
								signal outputvalue                 :  out  std_logic_vector(8 downto 0);
							    ) is
								signal element91                   :    std_logic_vector(8 downto 0);
								signal element92                   :    std_logic_vector(8 downto 0);
								signal element93                   :    std_logic_vector(8 downto 0);
								signal element94                   :    std_logic_vector(8 downto 0);
								signal final                       :    std_logic_vector(8 downto 0);
								constant ireducablepolinomial      :    std_logic_vector(8 downto 0) = "111010011"
								
								
								
		 begin
		 
		 element91 <= '0' & element1;
		 element92 <= '0' & element2;
		 element93 <= '0' & element3;
		 element94 <= '0' & element4;
		 element91 <= std_logic_vector(unsigned(constant1) * unsigned(element91))(8 downto 0);
		 element92 <= std_logic_vector(unsigned(constant2) * unsigned(element92))(8 downto 0);
		 element93 <= std_logic_vector(unsigned(constant3) * unsigned(element93))(8 downto 0);
		 element94 <= std_logic_vector(unsigned(constant4) * unsigned(element94))(8 downto 0);
		 final     <= element91 xor element92 xor element93 xor element94;
		 if final'high = '1' then
		    final <= final xor ireducablepolinomial;
		 end if;
		 outputvalue <= final(7 downto 0);    
		end procedure;
  
begin

    process(clk) 
    begin  
        if rising_edge(Clk) then
            if reset = '0' then
                
            else
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
			
            end if;
        end if;
    end process;
         outputmatrix <= resultmatrix;
end architecture;
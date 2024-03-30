library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity ShiftRow is
	Port(
    clk                : in std_logic;
    reset              : in std_logic; 
    inputmatrix         : in  matrix ;
    outputmatrix       : out matrix 	);
end entity;

  
architecture rtl of ShiftRow is
       
	    signal resultmatrix : matrix;
		type ist_array is array (0 to 3) of std_logic_vector(7 downto 0);
		signal output       :  ist_array;
		
		procedure ShiftInOneRow(
								constant nr        :   in       std_logic_vector(3 downto 0);
								signal onerow      :   in       ist_arry;
								signal output      :   out      ist_array) is
								signal i           : std_logic_vector(3 downto 0) = "0000";
								signal j           : std_logic_vector(3 downto 0) = "0000";
								
        begin
		    j <= k;
			while to_integer(unsigned(i)) <= 3
				if    to_integer(unsigned(i)) <= (onerow'length-1) - to_integer(unsigned(k))
			       output(i) <= output(j);
				   i <= std_logic_vector(unsigned(i) + 1);
				   j <= std_logic_vector(unsigned(j) + 1);
				   if to_integer(unsigned(i)) = (onerow'length-1) - to_integer(unsigned(k))
				       j= "0000"
				   end if;
				else
				    output(i) <= output(j);
			        i <= std_logic_vector(unsigned(i) + 1);
				    j <= std_logic_vector(unsigned(j) + 1);
				end if;
			end loop;
		end procedure;
  
begin

    process(clk) 
    begin = 
        if rising_edge(Clk) then
            if reset = '0' then
                
            else
                resultmatrix(0) <= inputmatrix(0) 
			    ShiftInOneRow(std_logic_vector(unsigned(1)),inputmatrix(1),resultmatrix(1));
				ShiftInOneRow(std_logic_vector(unsigned(2)),inputmatrix(2),resultmatrix(2));
                ShiftInOneRow(std_logic_vector(unsigned(3)),inputmatrix(3),resultmatrix(3));				
			end loop;
            end if;
        end if;
    end process;
         outputmatrix <= resultmatrix;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity KeyExpansion is
	Port(
    clk                : in std_logic;
    reset              : in std_logic; 
    inputmatrix         : in  matrix ;
    outputmatrix       : out matrix 	);
end entity;

  
architecture rtl of KeyExpansion is
       
	    signal resultmatrix : matrix;
		type ist_array8 is array (0 to 3) of std_logic_vector(7 downto 0);
		
		
   procedure ShiftInOneRow(
								constant nr     : in std_logic_vector(3 downto 0);
								variable onerow   : in ist_array8;
								variable output   : inout ist_array8
								) is
								variable shift_amount : integer range 0 to 3 := to_integer(unsigned(nr));
								
	begin
			 for i in 0 to 3 loop
				if i + shift_amount >= 4 then
					output(i) := onerow(i + shift_amount - 4);
				else
					output(i) := onerow(i + shift_amount);
					
				end if;
			end loop;
				 
	end procedure;
  
begin

    process(clk) 
	    variable inputrow: ist_array8;
		variable outputrow:ist_array8;
		type ist_array4 is array (0 to 3) of std_logic_vector(3 downto 0);
		variable increment : ist_array4 :=(
            "0000",
            "0001",
            "0010",
            "0011"
        );
		
    begin 
        if rising_edge(Clk) then
            if reset = '0' then
              resultmatrix <= ((others => (others => '0')),(others => (others => '0')),(others => (others => '0')),(others => (others => '0')));

            else
			for i in 0 to 3 loop
			    
				for j in 0 to 3 loop
					inputrow(j):=inputmatrix(i,j);
				end loop;
				
				if i = 0 then
				     outputrow := inputrow;
				else
					ShiftInOneRow(increment(i),inputrow,outputrow);
				end if;
				
				for j in 0 to 3 loop
					resultmatrix(i,j) <= outputrow(j);
				end loop;
                				
			end loop; 
               			
        end if;
      end if;
    end process;
         outputmatrix <= resultmatrix;
end architecture;
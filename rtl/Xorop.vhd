library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity Xorop is
	Port(
    clk                : in std_logic;
    reset              : in std_logic; 
    matrixword         : in  matrix ;
	matrixkey          : in matrix;
    outputmatrix       : out matrix 	);
end entity;

  
architecture rtl of Xorop is
       
	    signal resultmatrix : matrix;
  
begin

    process(clk) 
    begin
        if rising_edge(Clk) then
            if reset = '0' then
                
            else
                for i in 0 to 3 loop
					for j in 0 to 3 loop
					   resultmatrix(i,j) = matrixword(i,j) xor matrixkey(i,j);
					end loop;
                end loop;
            end if;
        end if;
    end process;
         outputmatrix <= resultmatrix;
end architecture;
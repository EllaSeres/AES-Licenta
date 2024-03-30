library ieee;
use  ieee.std_logic_1164.all;

package matrixform is
  type Matrix is array (0 to 3,0 to 3)
  of std_logic_vector  (7 downto 0 );
end package;

--def memorie or bram 
--xor deodata
--declar tot in package
--la counter evita natura,integer
-- trashold pe 0 , nu se respecta gen

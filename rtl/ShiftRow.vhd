library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity ShiftRow is
	Port(
    clk                : in std_logic;
    reset              : in std_logic; 
	enable             : in std_logic;
	done               : out std_logic;
    inputmatrix        : in  matrix ;
    outputmatrix       : out matrix 	);
end entity;

  
architecture rtl of ShiftRow is
       
	    signal resultmatrix : matrix;
		signal idlematrix   : matrix;
		type ist_array8 is array (0 to 3) of std_logic_vector(7 downto 0);
		type t_State is ( Idle,Check ,ShiftState,Finish,SetBack);
        signal State : t_State;
		
   procedure ShiftInOneRow(
								constant nr       : in std_logic_vector(3 downto 0);
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
		variable i  : std_logic_vector(2 downto 0) ;
		variable done1 : std_logic;
    begin 
        if rising_edge(clk) then
            if reset = '0' then
              resultmatrix <= ((others => (others => '0')),(others => (others => '0')),(others => (others => '0')),(others => (others => '0')));
              i := (others => '0'); -- Reset i
			  done1 := '0';
			  done <= '0';
			  State <= Idle;
            else
				done <= '0';
				case State is
					when Idle =>
						if enable = '0' then
							idlematrix <= inputmatrix;
							State <= Check;	
						end if; 
					when Check =>
						if to_integer(unsigned(i)) /= 4 then
							 State <= ShiftState;
						else
							if done1 = '0' then
								State <= Finish;
							else 
								State <= SetBack;
							end if;
						end if;
			   
			        when ShiftState =>
						for j in 0 to 3 loop
							inputrow(j):=idlematrix(to_integer(unsigned(i)),j);
						end loop;
					
						if to_integer(unsigned(i)) = 0 then
							outputrow := inputrow;
						else
							ShiftInOneRow(increment(to_integer(unsigned(i))),inputrow,outputrow);
						end if;
					
						for j in 0 to 3 loop
							resultmatrix(to_integer(unsigned(i)),j) <= outputrow(j);
						end loop;
						i := std_logic_vector(unsigned(i) + 1); 
						State <= Check;
						
			        when Finish =>
						done1 := '1';
						outputmatrix <= resultmatrix;
						done  <= '1';
					    State <= Check;
						
					when SetBack =>
						done1 := '0';
					    i := (others => '0');						
					    State <= Idle;
						
                    when others =>
				        State <= Idle;  						
			    end case;			  			
        end if;
      end if;
    end process;
         outputmatrix <= resultmatrix;
end architecture;
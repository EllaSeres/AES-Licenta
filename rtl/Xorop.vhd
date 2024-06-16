library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity Xorop is
	Port(
    clk                : in std_logic;
    reset              : in std_logic; 
	enable             : in std_logic;
	done               : out std_logic;
    matrixword         : in  matrix ;
	matrixkey          : in matrix;
    outputmatrix       : out matrix 	);
end entity;

  
architecture rtl of Xorop is
       
	    signal resultmatrix : matrix;
		signal idlematrix   : matrix;
		signal idlekey      : matrix;
		type t_State is ( Idle, Check ,XorState,Finish,SetBack);
        signal State : t_State;
  
begin

    process(clk) 
				variable i     : std_logic_vector(2 downto 0) ;
				variable done1 : std_logic;
    begin
        if rising_edge(clk) then
            if reset = '0' then
                 resultmatrix <= ((others => (others => '0')),(others => (others => '0')),(others => (others => '0')),(others => (others => '0')));
                 i := (others => '0'); 
				 done1 := '0';
				 done <= '0';
				 State <= Idle;
				 
            else
   --            if enable=  '0' then
   				done <= '0';
				case State is
					when Idle =>
						if enable = '0' then
							idlematrix <= matrixword;
							idlekey    <= matrixkey;
							State <= Check;	
						end if; 

					when Check =>
--						done <= '0';
						if to_integer(unsigned(i)) /= 4 then
							State <= XorState;
						else
							if done1 = '0' then
								State <= Finish;
							else 
								State <= SetBack;
							end if;
						end if;
			   
			        when XorState =>
						for j in 0 to 3 loop
							resultmatrix(to_integer(unsigned(i)),j) <= idlematrix(to_integer(unsigned(i)),j) xor idlekey(to_integer(unsigned(i)),j);
						end loop;
						i := std_logic_vector(unsigned(i) + 1); 
						State <= Check;
						
			        when Finish =>
						done1 := '1';
						outputmatrix <= resultmatrix;
					    State <= Check;
						
					when SetBack =>
						done1 := '0';
					    i := (others => '0'); 
						done  <= '1';
					    State <= Idle;
						
                    when others =>
				        State <= Idle;  						
			    end case;
					
       --        end if;
            end if;
        end if;
    end process;
         
end architecture;
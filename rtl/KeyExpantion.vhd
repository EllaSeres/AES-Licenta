library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity KeyExpantion is
	Port(
    clk                : in std_logic;
    reset              : in std_logic;
    doneall            : out std_logic;	
    inputmatrix        : in  matrix ;
    outputmatrix       : out matrix );
end entity;

  
architecture rtl of KeyExpantion is
       
	    signal resultmatrix : matrix;
		signal idlematrix   : matrix;
		signal counter :  std_logic_vector(3 downto 0) := x"0"; 
		signal enable  :  std_logic ;
		signal done    :  std_logic ;
		signal w0      :   MatrixRoworColumn;
		signal w1      :   MatrixRoworColumn;
		signal w2      :   MatrixRoworColumn;
		signal w3      :   MatrixRoworColumn;
		signal w4      :   MatrixRoworColumn;
		type t_State is ( Check ,Matrix2Word,Gfun,Xor0,Xor1,Xor2,Xor3,Word2Matrix,Set);
        signal State : t_State;

begin		
		  i_Gfunction : entity work.Gfunction(rtl)
          port map (
          clk          => clk,
          reset        => reset,
		  enable       => enable,
		  done         => done,
		  roundnr      =>  counter,
          inputarray   => w3,
		  outputarray  => w4
		);
		
 
  

    process(clk) 
	   variable done1 :std_logic := '0';
	   variable done2 :std_logic := '0';
	   variable done3 :std_logic:= '0';
	   variable done4 :std_logic:= '0';
	   variable done5 :std_logic:= '0';
	   variable done6 :std_logic:= '0';
	   variable done7 :std_logic:= '0';
	    variable done8 :std_logic:= '0';
	   variable i0  : std_logic_vector(2 downto 0);
	   variable i1  : std_logic_vector(2 downto 0);
	  
    begin 
        if rising_edge(Clk) then
            if reset = '0' then
			   enable <= '1';
			   done1  := '0';
			   done2  := '0';
			   done3  := '0';
			   done4  := '0';
			   done5  := '0';
			   done6  := '0';
			   done7  := '0';
			   done8  := '0';
			   i0 := (others => '0');
			   i1 := (others => '0');
               enable <= '1';
			   idlematrix <= inputmatrix;
			   State  <= Check;
            else
				if to_integer(unsigned(counter)) /= 10 then
					case State is
						when Check =>
							if done1 = '0' then
								if to_integer(unsigned(i0)) /= 4 then
									State   <= Matrix2Word;
								end if;
							elsif done1 = '1' then
							     
								 if done7 = '0' then 
									State <= Gfun;
								 elsif done7 = '1' then
									
								 --elsif enable = '1' then
								    if done2 = '0' then
									   State <= Xor0;
									elsif done3 = '0' then
										State <= Xor1;
									elsif done4 = '0' then
									    State <= Xor2;
									elsif done5 = '0' then
									    State <= Xor3;
									elsif done6 = '0' then
                                           if to_integer(unsigned(i1)) /= 4 then
												State   <= Word2Matrix;
											end if; 									
				                    else
										State <= Set;
									end if;
								 end if;							 
								
							end if;
						when Matrix2Word =>
							if to_integer(unsigned(i0)) = 0 then
								for j in 0 to 3 loop
									w0(j)<=idlematrix(to_integer(unsigned(i0)),j);
								end loop;
								i0 := std_logic_vector(unsigned(i0) + 1);
								State <= Check;
							elsif to_integer(unsigned(i0)) = 1 then
								for j in 0 to 3 loop
									w1(j)<=idlematrix(to_integer(unsigned(i0)),j);
								end loop;
								i0 := std_logic_vector(unsigned(i0) + 1);
								State <= Check;
							elsif to_integer(unsigned(i0)) = 2 then
								 for j in 0 to 3 loop
									w2(j)<=idlematrix(to_integer(unsigned(i0)),j);
								end loop;
								i0 := std_logic_vector(unsigned(i0) + 1);
								State <= Check;
							elsif to_integer(unsigned(i0)) = 3 then
								for j in 0 to 3 loop
									w3(j)<=idlematrix(to_integer(unsigned(i0)),j);
								end loop;
								i0 := std_logic_vector(unsigned(i0) + 1);
								done1 := '1';
								State <= Check;
							end if;
						
						when Gfun =>
						
							enable <= '0';
							if done = '1' then 
							    done7 := '1';
								enable <= '1';
							    State <= Check;
							end if;	
						
						when Xor0 =>
						    for j in 0 to 3 loop
									w0(j)<= w0(j) xor w4(j);
							end loop;
							done2 := '1';
							State <= Check;
						when Xor1 =>
						    for j in 0 to 3 loop
									w1(j)<= w1(j) xor w0(j);
							end loop;
							done3 := '1';
							State <= Check;
						when Xor2 =>
						    for j in 0 to 3 loop
									w2(j)<= w2(j) xor w1(j);
							end loop;
							done4 := '1';
							State <= Check;
						when Xor3 => 
							for j in 0 to 3 loop
									w3(j)<= w3(j) xor w2(j);
							end loop;
							done5 := '1';
							State <= Check;
						when Word2Matrix =>
							if to_integer(unsigned(i1)) = 0 then
								for j in 0 to 3 loop
									resultmatrix(to_integer(unsigned(i1)),j) <= w0(j);
								end loop;
								i1 := std_logic_vector(unsigned(i1) + 1);
								State <= Check;
							elsif to_integer(unsigned(i1)) = 1 then
								for j in 0 to 3 loop
									resultmatrix(to_integer(unsigned(i1)),j) <= w1(j);
								end loop;
								i1 := std_logic_vector(unsigned(i1) + 1);
								State <= Check;
							elsif to_integer(unsigned(i1)) = 2 then
								for j in 0 to 3 loop
									resultmatrix(to_integer(unsigned(i1)),j) <= w2(j);
								end loop;
								i1 := std_logic_vector(unsigned(i1) + 1);
								State <= Check;
							elsif to_integer(unsigned(i1)) = 3 then
								for j in 0 to 3 loop
									resultmatrix(to_integer(unsigned(i1)),j) <= w3(j);
								end loop;
								i1 := std_logic_vector(unsigned(i1) + 1);
								done6 := '1';
								State <= Check;
							end if;
						when Set =>
						   done1  := '0';
						   done2  := '0';
						   done3  := '0';
			               done4  := '0';
			               done5  := '0';
						   done6  := '0';
						   done7  := '0';
			               i0 := (others => '0');
						   i1 := (others => '0');
                           enable <= '1';
						   outputmatrix <= resultmatrix;
						   idlematrix   <= resultmatrix;
						   
						   counter <= std_logic_vector(unsigned(counter) + 1);
			               State  <= Check;
						when others =>
							State <= Check;  
					end case;
				else
				    doneall <= '1';
				end if;   			
            end if;
        end if;
       end process;
end architecture;
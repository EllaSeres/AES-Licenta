library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity InvMixColumn is
	Port(
    clk                : in std_logic;
    reset              : in std_logic; 
    enable             : in std_logic;
    done               : out std_logic;	
    inputmatrix        : in  matrix ;
    outputmatrix       : out matrix 	);
end entity;

  
architecture rtl of InvMixColumn is
       
	    signal resultmatrix : matrix;
		signal idlematrix   : matrix;
		signal const1  : std_logic_vector (7 downto 0):= X"0E";
		signal const2  : std_logic_vector (7 downto 0):=  X"0B" ;	
		signal const3  : std_logic_vector (7 downto 0):= X"0D";
		signal const4    :   std_logic_vector(7 downto 0):= X"09";
		type ist_array is array (0 to 3) of std_logic_vector(7 downto 0); 
        type t_State is ( Idle,Check ,MixState,Finish,SetBack);
        signal State : t_State;		
			
		
		
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
								
								variable final                     :    std_logic_vector(10 downto 0):= "00000000000";
							    variable elements                  :    ist_array:= (element1,element2,element3,element4);
                                variable element                   :    std_logic_vector(10 downto 0):= "00000000000";
								variable const                     :    ist_array := (constant1,constant2,constant3,constant4);
								

								variable ireducablepolinomial1      :    std_logic_vector(10 downto 0) := "00100011011" ;
								variable ireducablepolinomial2      :    std_logic_vector(10 downto 0) := "01000110110";
								variable ireducablepolinomial3      :    std_logic_vector(10 downto 0) := "10001101100";
								
								
								
		 begin
		 
			for  i in 0 to 3 loop
			   
				if const(i) = "00001110" then --0E
							element:= elements(i) & '0' & '0' & '0';
							final := final xor element;
							element:= '0' & elements(i)  & '0' & '0';
							final := final xor element;
							element:= '0' & '0' & elements(i) & '0';
							final := final xor element;	
						elsif const(i) = "00001011" then --0B
							element:= elements(i) & '0' & '0' & '0';
							final := final xor element;
							element:= '0' & '0' & elements(i) & '0';
							final := final xor element;
							element:=  '0' & '0' & '0' & elements(i) ;
							final := final xor element;
						elsif const(i) = "00001101" then --0D
							element:= elements(i) & '0' & '0' & '0';
							final := final xor element;
							element:= '0' & elements(i)  & '0' & '0';
							final := final xor element;
							element:=  '0' & '0' & '0' & elements(i) ;
							final := final xor element;
						else -- 09
							element:= elements(i) & '0' & '0' & '0';
							final := final xor element;
							element:=  '0' & '0' & '0' & elements(i) ;
							final := final xor element;
					
						end if;			
			end loop;
			
			if final(final'high )= '1' then
						final := final xor ireducablepolinomial3;
					end if;
					if final(9) = '1' then
					    final := final xor ireducablepolinomial2;
					end if;
					if final(8)= '1' then
						final := final xor ireducablepolinomial1;
					end if; 
					
					outputvalue <= final(7 downto 0); 
					
			   
				
        end procedure;
  
begin

    process(clk) 
		variable done1 : std_logic;
		variable done2 : std_logic;
    begin  
        if rising_edge(Clk) then
            if reset = '0' then
                done <= '0';
				done1 := '0';
				done2 := '0';
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
						
							if done1 = '0' then
								State <= MixState;
							elsif done2 = '0' then
							    State <= Finish;
							else
							    State <= SetBack;
							end if;
						
			   
			        when MixState =>
						--First row of output matrix
						Mix(idlematrix(0,0),idlematrix(1,0),idlematrix(2,0),idlematrix(3,0), const1,const2,const3,const4,resultmatrix(0,0));
						Mix(idlematrix(0,1),idlematrix(1,1),idlematrix(2,1),idlematrix(3,1), const1,const2,const3,const4,resultmatrix(0,1));
						Mix(idlematrix(0,2),idlematrix(1,2),idlematrix(2,2),idlematrix(3,2), const1,const2,const3,const4,resultmatrix(0,2));
						Mix(idlematrix(0,3),idlematrix(1,3),idlematrix(2,3),idlematrix(3,3), const1,const2,const3,const4,resultmatrix(0,3));
						
						--Second row of output matrix
						Mix(idlematrix(0,0),idlematrix(1,0),idlematrix(2,0),idlematrix(3,0), const4,const1,const2,const3,resultmatrix(1,0));
						Mix(idlematrix(0,1),idlematrix(1,1),idlematrix(2,1),idlematrix(3,1), const4,const1,const2,const3,resultmatrix(1,1));
						Mix(idlematrix(0,2),idlematrix(1,2),idlematrix(2,2),idlematrix(3,2), const4,const1,const2,const3,resultmatrix(1,2));
						Mix(idlematrix(0,3),idlematrix(1,3),idlematrix(2,3),idlematrix(3,3), const4,const1,const2,const3,resultmatrix(1,3));
						
						--Third row of output matrix
						Mix(idlematrix(0,0),idlematrix(1,0),idlematrix(2,0),idlematrix(3,0), const3,const4,const1,const2,resultmatrix(2,0));
						Mix(idlematrix(0,1),idlematrix(1,1),idlematrix(2,1),idlematrix(3,1), const3,const4,const1,const2,resultmatrix(2,1));
						Mix(idlematrix(0,2),idlematrix(1,2),idlematrix(2,2),idlematrix(3,2), const3,const4,const1,const2,resultmatrix(2,2));
						Mix(idlematrix(0,3),idlematrix(1,3),idlematrix(2,3),idlematrix(3,3), const3,const4,const1,const2,resultmatrix(2,3));
						
						--Forth row of output matrix
						Mix(idlematrix(0,0),idlematrix(1,0),idlematrix(2,0),idlematrix(3,0), const2,const3,const4,const1,resultmatrix(3,0));
						Mix(idlematrix(0,1),idlematrix(1,1),idlematrix(2,1),idlematrix(3,1), const2,const3,const4,const1,resultmatrix(3,1));
						Mix(idlematrix(0,2),idlematrix(1,2),idlematrix(2,2),idlematrix(3,2), const2,const3,const4,const1,resultmatrix(3,2));
						Mix(idlematrix(0,3),idlematrix(1,3),idlematrix(2,3),idlematrix(3,3), const2,const3,const4,const1,resultmatrix(3,3));
							
			        
						
						done1 := '1';
					    State <= Check;
					when Finish =>
					
						done2:= '1';
						done  <= '1';
						outputmatrix <= resultmatrix;
					    State <= Check;
							
					when SetBack =>
						done1 := '0'; 
						done2 := '0'; 
						--done  <= '1';
					    State <= Idle;
						
                    when others =>
				        State <= Idle;  						
			    end case;
            end if;
        end if;
    end process;
         
end architecture;
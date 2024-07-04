library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity AESencryption is
	Port(
    i_clk                   : in std_logic; --! Main clock input
    i_reset                 : in std_logic;
	i_key                   : in matrix;
	i_input_en              : in std_logic;
    i_inputmatrixaes        : in  matrix ;
	o_done                  : out std_logic;
    o_outputmatrixaes       : out matrix );
end entity;

  
architecture rtl of AESencryption is
       
	    signal resultmatrix : matrix;
		--signal idlematrix   : matrix;
		signal enablexop    :  std_logic ;
		signal donexop      :  std_logic ;
		signal enablesub    :  std_logic;
		signal donesub      :  std_logic;
		signal enablemix    :  std_logic;
		signal donemix      :  std_logic;
		signal enablesr     :  std_logic;
		signal donesr       :  std_logic;
		signal enableks     :  std_logic;
		signal doneks       :  std_logic;
		signal matrixor     : matrix;
	    signal idlekey      : matrix;
		signal idlekey2     : matrix;
		signal matrixsub    : matrix; 
		signal matrixsr     : matrix;
		signal matrixmc     : matrix;
		signal matrixmc_o   : matrix;
		signal matrixor_o   : matrix;
	    signal idlekey_o    : matrix;
		signal matrixsub_o  : matrix;
		signal matrixsr_o   : matrix;
		signal counter      :  std_logic_vector(3 downto 0) := "0000"; 
		type t_State is ( Idle, Check,AddRoundKey,Subbyte,ShiftRow,MixColumn,Change,KeyExpantion,Set);
        signal State : t_State;

begin		
		i_Xorop : entity work.Xorop(rtl)
        port map (
          clk          => i_clk,
          reset        => i_reset,
		  enable       => enablexop,
		  done         => donexop,
		  matrixword   =>  matrixor,   
	      matrixkey    =>  idlekey,    
          outputmatrix =>  matrixor_o 
		);
		
		 i_Sbox : entity work.Sbox(rtl)
		port map (
			clk          => i_clk,
			reset        => i_reset,
			enable       => enablesub,
			done         => donesub,
			inputmatrix  => matrixsub,
			outputmatrix => matrixsub_o
		);
		
		 i_ShiftRow : entity work.ShiftRow(rtl)
		 port map (
				clk          => i_clk,
				reset        => i_reset,
				enable       => enablesr,
				done         => donesr,
				inputmatrix  => matrixsr,
				outputmatrix => matrixsr_o
		);
		
		  i_MixColumn : entity work.MixColumn(rtl)
         port map (
        clk          => i_clk,
        reset        => i_reset,
		enable       => enablemix,
		done         => donemix,
        inputmatrix  => matrixmc,
		outputmatrix => matrixmc_o
		 );
  
		
		 i_KeyExpantion : entity work.KeyExpantion(rtl)
		 port map (
			clk          => i_clk,
			reset        => i_reset,
			enableks    => enableks,
			counter     => counter,
			doneks      => doneks,
			inputmatrix  => idlekey2,
			outputmatrix => idlekey_o
		 );
 
  

    process(i_clk) 
	   variable done1 :std_logic := '0';
	   variable done2 :std_logic := '0';
	   variable done3 :std_logic:= '0';
	   variable done4 :std_logic:= '0';
	   variable done5 :std_logic:= '0';
	   variable done6 :std_logic:= '0';
	   variable done7 :std_logic:= '0';
	   variable done8 :std_logic:= '0';
	   
	  
    begin 
        if rising_edge(i_clk) then
            if i_reset = '0' then
			   enablexop <= '1';
			   enablesub <= '1';
			   enablesr  <= '1';
			   enablemix <= '1';
			   enableks  <= '1';
			   o_done    <= '0';
			   done1  := '0';
			   done2  := '0';
			   done3  := '0';
			   done4  := '0';
			   done5  := '0';
			   done6  := '0';
			   done7  := '0';
			   done8  := '0';
			   --matrixor <= i_inputmatrixaes;
			   matrixor <= MatrixZero;
			  -- idlekey  <= key;
			   State    <= Idle;
			   o_outputmatrixaes <= MatrixZero;
            else
			   enablexop <= '1'; 								       -- Disabled by default
			   enableks  <= '1';									   -- Disabled by default
				
			    if unsigned(counter) <= 9 then
					o_done           <= '0';
					case State is
						when Idle =>				
							if i_input_en = '0' then
								matrixor <= i_inputmatrixaes;
								idlekey  <= i_key;
								idlekey2 <= i_key;
								State    <= Check;
							end if;

						when Check =>
						--	if to_integer(unsigned(counter)) = 0 and done1 = '0' then
							if unsigned(counter) = 0 and done1 = '0' then                 -- Same thing as above
								State     <= AddRoundKey;
								enablexop <= '0';
							elsif done2 = '0' then
							     if to_integer(unsigned(counter)) = 0 then
								   done7 := '1';
								 end if;
							     State <=Subbyte;
						    elsif  done3 = '0' then
							     State <= ShiftRow;
							elsif  done4 = '0' then
								if to_integer(unsigned(counter)) /= 9 then
									State <= MixColumn;
								else
								    State <= Change;
								end if;
                            elsif  done5 = '0' then							
						        State    <= KeyExpantion;
								enableks <= '0';
							elsif done6 = '0' then
								 State     <=  AddRoundKey;
								 enablexop <= '0';
							else
							    State <= Set;
						    end if;
						
						when AddRoundKey =>
						--    enablexop <= '0';
							if donexop = '1' then 
							    done1 := '1';
								if to_integer(unsigned(counter)) /= 0 or done7 = '1'then
									done6 := '1';
								end if;
					    -- 		enablexop <= '1';
								matrixsub <= matrixor_o;
							    State <= Check;
							end if;	
						   
						when Subbyte =>
							enablesub <= '0';
							if donesub = '1' then 
							    done2 := '1';
								enablesub <= '1';
								matrixsr <= matrixsub_o;
							    State <= Check;
							end if;	
							
						when ShiftRow => 
						    enablesr <= '0';
							if donesr = '1' then 
							    done3 := '1';
								enablesr <= '1';
								matrixmc <= matrixsr_o;
							    State <= Check;
							end if;	
							
						when MixColumn => 
						    enablemix <= '0';
							if donemix = '1' then 
							    done4 := '1';
								enablemix <= '1';
								matrixor  <= matrixmc_o;
							    State <= Check;
							end if;	
						when Change =>
							matrixor <= matrixsr_o;
							done4 := '1';
							State <= Check;
							
						when KeyExpantion =>
					--	    enableks <= '0';
							if doneks = '1' then 
							    done5 := '1';
					--			enableks <= '1';
								idlekey  <= idlekey_o;
								idlekey2 <= idlekey_o;
							    State    <= Check;
							end if;	
						   
						when Set =>
						   done1  := '0';
						   done2  := '0';
						   done3  := '0';
			               done4  := '0';
			               done5  := '0';
						   done6  := '0';
                           enablexop <= '1';
						   enablesub <= '1';
						   enablesr  <= '1';
						   enablemix <= '1';
						   enableks  <= '1';
						   --idlematrix   <= resultmatrix;
						   counter <= std_logic_vector(unsigned(counter) + 1);
			               State  <= Check;
						when others =>
							State <= Idle;  
					end case;
			  else
					o_outputmatrixaes <= matrixsub;
					o_done            <= '1';
					counter           <= (others => '0');
					State             <= Idle;
			  end if;	
            end if;
        end if;
       end process;
end architecture;
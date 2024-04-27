library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Matrixform.all;
  
entity Gfunction is
   Generic(
    roundnr         : in std_logic_vector(3 downto 0)
	);
	Port(
    clk               : in std_logic;
    reset             : in std_logic; 	
	inputarray        : in  MatrixRoworColumn;
    outputarray       : out MatrixRoworColumn);
	--enable            : in  std_logic;
end entity;

  
architecture rtl of Gfunction is
       
   type ist_array is array (0 to 9) of std_logic_vector(7 downto 0);
   procedure ShiftInOneRow(	
                                variable input   : in  MatrixRoworColumn ;
								variable output  : out MatrixRoworColumn;
								variable done    : out  std_logic
								) is
								
	begin
			 for i in 0 to 3 loop
				if i + 1 >= 4 then
					output(i) := input(i + 1 - 4);
				else
					output(i) := input(i + 1);
					
				end if;
			end loop;
			done := '1';
				 
   end procedure;
   
   procedure Substitution(
								variable input   : in MatrixRoworColumn ;
								variable output   : out MatrixRoworColumn;
								variable done    : out  std_logic 
								) is
							
								
	begin
		 for i in 0 to 3 loop
					   case  input(i)  is
							when x"00" => output(i) := x"63";
							when x"01" => output(i) := x"7c";
							when x"02" => output(i) := x"77";
							when x"03" => output(i) := x"7b";
							when x"04" => output(i) := x"f2";
							when x"05" => output(i) := x"6b";
							when x"06" => output(i) := x"6f";
							when x"07" => output(i) := x"c5";
							when x"08" => output(i) := x"30";
							when x"09" => output(i) := x"01";
							when x"0a" => output(i) := x"67";
							when x"0b" => output(i) := x"2b";
							when x"0c" => output(i) := x"fe";
							when x"0d" => output(i) := x"d7";
							when x"0e" => output(i) := x"ab";
							when x"0f" => output(i) := x"76";
							when x"10" => output(i) := x"ca";
							when x"11" => output(i) := x"82";
							when x"12" => output(i) := x"c9";
							when x"13" => output(i) := x"7d";
							when x"14" => output(i) := x"fa";
							when x"15" => output(i) := x"59";
							when x"16" => output(i) := x"47";
							when x"17" => output(i) := x"f0";
							when x"18" => output(i) := x"ad";
							when x"19" => output(i) := x"d4";
							when x"1a" => output(i) := x"a2";
							when x"1b" => output(i) := x"af";
							when x"1c" => output(i) := x"9c";
							when x"1d" => output(i):= x"a4";
							when x"1e" => output(i) := x"72";
							when x"1f" => output(i) := x"c0";
							when x"20" => output(i) := x"b7";
							when x"21" => output(i) := x"fd";
							when x"22" => output(i) := x"93";
							when x"23" => output(i) := x"26";
							when x"24" => output(i) := x"36";
							when x"25" => output(i) := x"3f";
							when x"26" => output(i) := x"f7";
							when x"27" => output(i) := x"cc";
							when x"28" => output(i) := x"34";
							when x"29" => output(i) := x"a5";
							when x"2a" => output(i) := x"e5";
							when x"2b" => output(i) := x"f1";
							when x"2c" => output(i) := x"71";
							when x"2d" => output(i) := x"d8";
							when x"2e" => output(i) := x"31";
							when x"2f" => output(i) := x"15";
							when x"30" => output(i) := x"04";
							when x"31" => output(i) := x"c7";
							when x"32" => output(i) := x"23";
							when x"33" => output(i) := x"c3";
							when x"34" => output(i) := x"18";
							when x"35" => output(i) := x"96";
							when x"36" => output(i) := x"05";
							when x"37" => output(i) := x"9a";
							when x"38" => output(i) := x"07";
							when x"39" => output(i) := x"12";
							when x"3a" => output(i) := x"80";
							when x"3b" => output(i) := x"e2";
							when x"3c" => output(i) := x"eb";
							when x"3d" => output(i) := x"27";
							when x"3e" => output(i) := x"b2";
							when x"3f" => output(i) := x"75";
							when x"40" => output(i) := x"09";
							when x"41" => output(i) := x"83";
							when x"42" => output(i) := x"2c";
							when x"43" => output(i) := x"1a";
							when x"44" => output(i) := x"1b";
							when x"45" => output(i) := x"6e";
							when x"46" => output(i) := x"5a";
							when x"47" => output(i) := x"a0";
							when x"48" => output(i) := x"52";
							when x"49" => output(i) := x"3b";
							when x"4a" => output(i) := x"d6";
							when x"4b" => output(i) := x"b3";
							when x"4c" => output(i) := x"29";
							when x"4d" => output(i) := x"e3";
							when x"4e" => output(i) := x"2f";
							when x"4f" => output(i) := x"84";
							when x"50" => output(i) := x"53";
							when x"51" => output(i) := x"d1";
							when x"52" => output(i) := x"00";
							when x"53" => output(i) := x"ed";
							when x"54" => output(i) := x"20";
							when x"55" => output(i) := x"fc";
							when x"56" => output(i) := x"b1";
							when x"57" => output(i) := x"5b";
							when x"58" => output(i) := x"6a";
							when x"59" => output(i) := x"cb";
							when x"5a" => output(i) := x"be";
							when x"5b" => output(i) := x"39";
							when x"5c" => output(i) := x"4a";
							when x"5d" => output(i) := x"4c";
							when x"5e" => output(i) := x"58";
							when x"5f" => output(i) := x"cf";
							when x"60" => output(i) := x"d0";
							when x"61" => output(i) := x"ef";
							when x"62" => output(i) := x"aa";
							when x"63" => output(i) := x"fb";
							when x"64" => output(i) := x"43";
							when x"65" => output(i) := x"4d";
							when x"66" => output(i) := x"33";
							when x"67" => output(i) := x"85";
							when x"68" => output(i) := x"45";
							when x"69" => output(i) := x"f9";
							when x"6a" => output(i) := x"02";
							when x"6b" => output(i) := x"7f";
							when x"6c" => output(i) := x"50";
							when x"6d" => output(i) := x"3c";
							when x"6e" => output(i) := x"9f";
							when x"6f" => output(i) := x"a8";
							when x"70" => output(i) := x"51";
							when x"71" => output(i) := x"a3";
							when x"72" => output(i) := x"40";
							when x"73" => output(i) := x"8f";
							when x"74" => output(i) := x"92";
							when x"75" => output(i) := x"9d";
							when x"76" => output(i) := x"38";
							when x"77" => output(i) := x"f5";
							when x"78" => output(i) := x"bc";
							when x"79" => output(i) := x"b6";
							when x"7a" => output(i) := x"da";
							when x"7b" => output(i) := x"21";
							when x"7c" => output(i) := x"10";
							when x"7d" => output(i) := x"ff";
							when x"7e" => output(i) := x"f3";
							when x"7f" => output(i) := x"d2";
							when x"80" => output(i) := x"cd";
							when x"81" => output(i) := x"0c";
							when x"82" => output(i) := x"13";
							when x"83" => output(i) := x"ec";
							when x"84" => output(i) := x"5f";
							when x"85" => output(i) := x"97";
							when x"86" => output(i) := x"44";
							when x"87" => output(i) := x"17";
							when x"88" => output(i) := x"c4";
							when x"89" => output(i) := x"a7";
							when x"8a" => output(i) := x"7e";
							when x"8b" => output(i) := x"3d";
							when x"8c" => output(i) := x"64";
							when x"8d" => output(i) := x"5d";
							when x"8e" => output(i) := x"19";
							when x"8f" => output(i) := x"73";
							when x"90" => output(i) := x"60";
							when x"91" => output(i) := x"81";
							when x"92" => output(i) := x"4f";
							when x"93" => output(i) := x"dc";
							when x"94" => output(i) := x"22";
							when x"95" => output(i) := x"2a";
							when x"96" => output(i) := x"90";
							when x"97" => output(i) := x"88";
							when x"98" => output(i) := x"46";
							when x"99" => output(i) := x"ee";
							when x"9a" => output(i) := x"b8";
							when x"9b" => output(i) := x"14";
							when x"9c" => output(i) := x"de";
							when x"9d" => output(i) := x"5e";
							when x"9e" => output(i) := x"0b";
							when x"9f" => output(i) := x"db";
							when x"a0" => output(i) := x"e0";
							when x"a1" => output(i) := x"32";
							when x"a2" => output(i) := x"3a";
							when x"a3" => output(i) := x"0a";
							when x"a4" => output(i) := x"49";
							when x"a5" => output(i) := x"06";
							when x"a6" => output(i) := x"24";
							when x"a7" => output(i) := x"5c";
							when x"a8" => output(i) := x"c2";
							when x"a9" => output(i) := x"d3";
							when x"aa" => output(i) := x"ac";
							when x"ab" => output(i) := x"62";
							when x"ac" => output(i) := x"91";
							when x"ad" => output(i) := x"95";
							when x"ae" => output(i) := x"e4";
							when x"af" => output(i) := x"79";
							when x"b0" => output(i) := x"e7";
							when x"b1" => output(i) := x"c8";
							when x"b2" => output(i) := x"37";
							when x"b3" => output(i) := x"6d";
							when x"b4" => output(i) := x"8d";
							when x"b5" => output(i) := x"d5";
							when x"b6" => output(i) := x"4e";
							when x"b7" => output(i) := x"a9";
							when x"b8" => output(i) := x"6c";
							when x"b9" => output(i) := x"56";
							when x"ba" => output(i) := x"f4";
							when x"bb" => output(i) := x"ea";
							when x"bc" => output(i) := x"65";
							when x"bd" => output(i) := x"7a";
							when x"be" => output(i) := x"ae";
							when x"bf" => output(i) := x"08";
							when x"c0" => output(i) := x"ba";
							when x"c1" => output(i) := x"78";
							when x"c2" => output(i) := x"25";
							when x"c3" => output(i) := x"2e";
							when x"c4" => output(i) := x"1c";
							when x"c5" => output(i) := x"a6";
							when x"c6" => output(i) := x"b4";
							when x"c7" => output(i) := x"c6";
							when x"c8" => output(i) := x"e8";
							when x"c9" => output(i) := x"dd";
							when x"ca" => output(i) := x"74";
							when x"cb" => output(i) := x"1f";
							when x"cc" => output(i) := x"4b";
							when x"cd" => output(i) := x"bd";
							when x"ce" => output(i) := x"8b";
							when x"cf" => output(i) := x"8a";
							when x"d0" => output(i) := x"70";
							when x"d1" => output(i) := x"3e";
							when x"d2" => output(i) := x"b5";
							when x"d3" => output(i) := x"66";
							when x"d4" => output(i) := x"48";
							when x"d5" => output(i) := x"03";
							when x"d6" => output(i) := x"f6";
							when x"d7" => output(i) := x"0e";
							when x"d8" => output(i) := x"61";
							when x"d9" => output(i) := x"35";
							when x"da" => output(i) := x"57";
							when x"db" => output(i) := x"b9";
							when x"dc" => output(i) := x"86";
							when x"dd" => output(i) := x"c1";
							when x"de" => output(i) := x"1d";
							when x"df" => output(i) := x"9e";
							when x"e0" => output(i) := x"e1";
							when x"e1" => output(i) := x"f8";
							when x"e2" => output(i) := x"98";
							when x"e3" => output(i) := x"11";
							when x"e4" => output(i) := x"69";
							when x"e5" => output(i) := x"d9";
							when x"e6" => output(i) := x"8e";
							when x"e7" => output(i) := x"94";
							when x"e8" => output(i) := x"9b";
							when x"e9" => output(i) := x"1e";
							when x"ea" => output(i) := x"87";
							when x"eb" => output(i) := x"e9";
							when x"ec" => output(i) := x"ce";
							when x"ed" => output(i) := x"55";
							when x"ee" => output(i) := x"28";
							when x"ef" => output(i) := x"df";
							when x"f0" => output(i) := x"8c";
							when x"f1" => output(i) := x"a1";
							when x"f2" => output(i) := x"89";
							when x"f3" => output(i) := x"0d";
							when x"f4" => output(i) := x"bf";
							when x"f5" => output(i) := x"e6";
							when x"f6" => output(i) := x"42";
							when x"f7" => output(i) := x"68";
							when x"f8" => output(i) := x"41";
							when x"f9" => output(i) := x"99";
							when x"fa" => output(i) := x"2d";
							when x"fb" => output(i) := x"0f";
							when x"fc" => output(i) := x"b0";
							when x"fd" => output(i) := x"54";
							when x"fe" => output(i) := x"bb";
							when x"ff" => output(i) := x"16";
							when others => null; 
						end case;
					
                end loop;
			done := '1';
	end procedure;
	
	procedure RoundConstantXor(	
                                variable input   : in MatrixRoworColumn ;
								variable output  : out MatrixRoworColumn;
								constant round   : in std_logic_vector(3 downto 0)								
								
								) is
								variable j  : integer  := to_integer(unsigned(round));
								variable RC :    ist_array :=(x"01",x"02",x"04",x"08",x"10",x"20",x"40",x"80",x"1B",x"36");
								
								
	begin
			for i in 0 to 3 loop
				if i = 0 then
				    output(i):=input(i) xor RC(j);
				else
					output(i):=input(i);
				end if;
			end loop; 
	 
   end procedure;
  
begin
  
    process(clk)
     variable column  : MatrixRoworColumn;
	 variable inp     : MatrixRoworColumn;
     variable done1    :  std_logic := '0'; 
	 variable done2    :  std_logic := '0';
     variable done     :  std_logic := '0';	 
    begin
        if rising_edge(Clk) then
            if reset = '0' then
                done1 := '0';
				done2 := '0';
				done  := '0';
				inp   := inputarray;
				
            else
			  if done = '0' then
               ShiftInOneRow(inp,column,done1);
			   if done1 = '1' then
			        inp := column;
					Substitution(inp,column,done2);
			   end if;
			   
			   if done2 ='1' then
			        inp := column;
					RoundConstantXor(inp,column,roundnr);
			   end if;
			   done := '1';
			   
			  end if;
            end if;
        end if;
		outputarray <= column;
    end process;
         
end architecture;
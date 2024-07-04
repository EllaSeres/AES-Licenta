library ieee;
use  ieee.std_logic_1164.all;

package matrixform is
  type Matrix is array (0 to 3,0 to 3)
  of std_logic_vector  (7 downto 0 );
  
  type MatrixRoworColumn is array (0 to 3)
  of std_logic_vector  (7 downto 0 );
  
  type DataArray is array (0 to 15)
  of std_logic_vector  (7 downto 0 );
  
  
  constant MatrixZero : Matrix := (others => (others => (others => '0')));
  
  component Xorop
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      done      : out std_logic;
      matrixword : in matrix;
      matrixkey : in matrix;
      outputmatrix : out matrix
    );
  end component;

  component Sbox
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      done : out std_logic;
      inputmatrix : in matrix;
      outputmatrix : out matrix
    );
  end component;
  
  component InvSbox
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      done : out std_logic;
      inputmatrix : in matrix;
      outputmatrix : out matrix
    );
  end component;
  
  component ShiftRow
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      done : out std_logic;
      inputmatrix : in matrix;
      outputmatrix : out matrix
    );
  end component;
  
	component InvShiftRow
		port (
		  clk : in std_logic;
		  reset : in std_logic;
		  enable : in std_logic;
		  done : out std_logic;
		  inputmatrix : in matrix;
		  outputmatrix : out matrix
		);
	  end component;
  component InvMixColumn
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      done : out std_logic;
      inputmatrix : in matrix;
      outputmatrix : out matrix
    );
  end component;
  
  component MixColumn
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      done : out std_logic;
      inputmatrix : in matrix;
      outputmatrix : out matrix
    );
  end component;

  component KeyExpantion
    port (
      clk : in std_logic;
      reset : in std_logic;
      enableks : in std_logic;
      counter : in std_logic_vector(3 downto 0);
      doneks : out std_logic;
      inputmatrix : in matrix;
      outputmatrix : out matrix
    );
  end component;

  component Gfunction
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      done : out std_logic;
      roundnr : in std_logic_vector(3 downto 0);
      inputarray : in MatrixRoworColumn;
      outputarray : out MatrixRoworColumn
    );
  end component;

  
end package;



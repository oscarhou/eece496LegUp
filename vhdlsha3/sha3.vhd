library ieee;
use ieee.std_logic_1164.all;
library work;
use work.sha3_types.all;

ENTITY sha3 IS
PORT(inputState :in row;
	  outputState :out row;
	  clk: std_logic;
	  reset:std_logic);
END sha3;

ARCHITECTURE shaArch OF sha3 IS
signal test,test2:lane;
--state registers
COMPONENT shaMemory
	PORT(write_l: in std_logic;
		  outData:out lane;
		  inData: in lane;
		  laneRow: std_logic_vector(2 downto 0);
		  laneCol: std_logic_vector(2 downto 0));
END COMPONENT;
BEGIN

MEM:shaMemory port map ('1', test,test2, "100", "001");
END shaArch;
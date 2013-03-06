library ieee;
use ieee.std_logic_1164.all;
library work;
use work.sha3_types.all;

ENTITY sha3 IS
PORT(inputLane :in lane;
	  outputLane :out lane;
	  clk: std_logic;
	  reset:std_logic);
END sha3;

ARCHITECTURE shaArch OF sha3 IS
signal test:lane;
signal memOut:state;
signal thetaState:row;
--state registers
COMPONENT shaMemory
	PORT(write_l: in std_logic;
		  clk: in std_logic;
		  outData:out state;
		  inData: in lane;
		  laneRow: std_logic_vector(2 downto 0);
		  laneCol: std_logic_vector(2 downto 0));
END COMPONENT;
COMPONENT theta
	PORT(thetaInData: in state;
		  thetaOutData:out row;
		  thetaSelect: in std_logic;
		  clk: std_logic);
END COMPONENT;
BEGIN

MEM:shaMemory port map ('1', clk, memOut,test, "100", "001");
THETASTEP:theta port map(memOut, thetaState, '1', clk);
END shaArch;
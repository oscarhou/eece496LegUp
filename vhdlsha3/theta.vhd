library ieee;
use ieee.std_logic_1164.all;
library work;
use work.sha3_types.all;

ENTITY theta IS
	PORT(thetaInData:in state;
		  thetaOutData:out row;
	     thetaSelect:in std_logic;
		  clk: in std_logic);
END theta;

ARCHITECTURE thetaArch OF theta IS
	SIGNAL thetaSaveState: state;
	SIGNAL C,D: row;
BEGIN

-- Get the C row
ThetaFillC: for i in 0 to 4 generate
	CLoop: C(i) <= thetaInData(i)(0) xor thetaInData(i)(1) xor thetaInData(i)(2) xor thetaInData(i)(3) xor thetaInData(i)(4);
	end generate ThetaFillC;
--	
D(0) <= (C(1)(14 downto 0) & C(1)(15)) xor C(4);
D(1) <= (C(2)(14 downto 0) & C(2)(15)) xor C(0);
D(2) <= (C(3)(14 downto 0) & C(3)(15)) xor C(1);
D(3) <= (C(4)(14 downto 0) & C(4)(15)) xor C(2);
D(4) <= (C(0)(14 downto 0) & C(0)(15)) xor C(3);
thetaOutData <= D;

END thetaArch;
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
library work;
use work.sha3_types.all;

ENTITY theta IS
	PORT(hold:in std_logic;
		 thetaInData:in state;
		 thetaOutData:out row;
		 clk: in std_logic);
END theta;

ARCHITECTURE thetaArch OF theta IS
	SIGNAL thetaSaveState: state;
	SIGNAL internalStart: std_logic;
	SIGNAL C,D: row;
	SIGNAL clkCounter: std_logic_vector (1 downto 0);
	SIGNAL internalReady: std_logic;
BEGIN

--Save the memory registers in an internal state
PROCESS(clk, hold)
BEGIN
	IF (rising_edge(clk) and hold ='0') THEN
		thetaSaveState <= thetaInData;
	END IF;	
END PROCESS;
-- Get the C row

ThetaFillC: for i in 0 to 4 generate
	CLoop: C(i) <= thetaSaveState(0)(i) xor thetaSaveState(1)(i) xor thetaSaveState(2)(i) xor thetaSaveState(3)(i) xor thetaSaveState(4)(i);
end generate ThetaFillC;
	--	
D(0) <= (C(1)(14 downto 0) & C(1)(15)) xor C(4);
D(1) <= (C(2)(14 downto 0) & C(2)(15)) xor C(0);
D(2) <= (C(3)(14 downto 0) & C(3)(15)) xor C(1);
D(3) <= (C(4)(14 downto 0) & C(4)(15)) xor C(2);
D(4) <= (C(0)(14 downto 0) & C(0)(15)) xor C(3);

thetaOutData <= D;


END thetaArch;
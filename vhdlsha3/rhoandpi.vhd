-- Rho and Pi steps of the round function
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

library work;
use work.sha3_types.all;


ENTITY rhoandpi IS
PORT(inState: in state;
	 outState: out row;
	 hold: in std_logic;
	 clk: in std_logic);
END rhoandpi;

ARCHITECTURE rhoAndPiArch OF rhoandpi IS
SIGNAL internalState: state;
SIGNAL memState: state;
SIGNAL internalBState: state;

BEGIN
PROCESS(clk, hold)
BEGIN
	IF (rising_edge(clk) and hold ='0') THEN
		memState <= inState;
	END IF;	
END PROCESS;

internalState(0)(0) <= memState(0)(0);
ROTATE1: for i in 0 to 15 generate
	internalState(0)(1)(i) <= memState(0)(1)((i - 1) mod 16);
	--internalState(0)(1)(i downto 0) <= memState(0)(1)(i downto 1) & '1';
end generate;
ROTATE2: for i in 0 to 15 generate
	internalState(0)(2)(i) <= memState(0)(2)((i - 62) mod 16);
end generate;
ROTATE3: for i in 0 to 15 generate
	internalState(0)(3)(i) <= memState(0)(3)((i - 28) mod 16);
end generate;
ROTATE4: for i in 0 to 15 generate
	internalState(0)(4)(i) <= memState(0)(4)((i - 27) mod 16);
end generate;
ROTATE5: for i in 0 to 15 generate
	internalState(1)(0)(i) <= memState(1)(0)((i - 36) mod 16);
end generate;
ROTATE6: for i in 0 to 15 generate
	internalState(1)(1)(i) <= memState(1)(1)((i - 44) mod 16);
end generate;
ROTATE7: for i in 0 to 15 generate
	internalState(1)(2)(i) <= memState(1)(2)((i - 6) mod 16);
end generate;
ROTATE8: for i in 0 to 15 generate
	internalState(1)(3)(i) <= memState(1)(3)((i - 55) mod 16);
end generate;
ROTATE9: for i in 0 to 15 generate
	internalState(1)(4)(i) <= memState(1)(4)((i - 20) mod 16);
end generate;
ROTATE10: for i in 0 to 15 generate
	internalState(2)(0)(i) <= memState(2)(0)((i - 3) mod 16);
end generate;
ROTATE11: for i in 0 to 15 generate
	internalState(2)(1)(i) <= memState(2)(1)((i - 10) mod 16);
end generate;
ROTATE12: for i in 0 to 15 generate
	internalState(2)(2)(i) <= memState(2)(2)((i - 43) mod 16);
end generate;
ROTATE13: for i in 0 to 15 generate
	internalState(2)(3)(i) <= memState(2)(3)((i - 25) mod 16);
end generate;
ROTATE14: for i in 0 to 15 generate
	internalState(2)(4)(i) <= memState(2)(4)((i - 39) mod 16);
end generate;
ROTATE15: for i in 0 to 15 generate
	internalState(3)(0)(i) <= memState(3)(0)((i - 41) mod 16);
end generate;
ROTATE16: for i in 0 to 15 generate
	internalState(3)(1)(i) <= memState(3)(1)((i - 45) mod 16);
end generate;
ROTATE17: for i in 0 to 15 generate
	internalState(3)(2)(i) <= memState(3)(2)((i - 15) mod 16);
end generate;
ROTATE18: for i in 0 to 15 generate
	internalState(3)(3)(i) <= memState(3)(3)((i - 21) mod 16);
end generate;
ROTATE19: for i in 0 to 15 generate
	internalState(3)(4)(i) <= memState(3)(4)((i - 8) mod 16);
end generate;
ROTATE20: for i in 0 to 15 generate
	internalState(4)(0)(i) <= memState(4)(0)((i - 18) mod 16);
end generate;
ROTATE21: for i in 0 to 15 generate
	internalState(4)(1)(i) <= memState(4)(1)((i - 2) mod 16);
end generate;
ROTATE22: for i in 0 to 15 generate
	internalState(4)(2)(i) <= memState(4)(2)((i - 61) mod 16);
end generate;
ROTATE23: for i in 0 to 15 generate
	internalState(4)(3)(i) <= memState(4)(3)((i - 56) mod 16);
end generate;
ROTATE24: for i in 0 to 15 generate
	internalState(4)(4)(i) <= memState(4)(4)((i - 14) mod 16);
end generate;

BStateY:for y in 0 to 4 generate
	BstateX: for x in 0 to 4 generate
		BstateI: for i in 0 to 15 generate
			--The i can probably be removed
			internalBState((2*x+3*y) mod 5)(y)(i)<=internalState(y)(x)(i);
		end generate;	
	end generate;
end generate;

outState <= internalBState(0);


END rhoAndPiArch;
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
TYPE rotateRow IS ARRAY (0 to 4) OF INTEGER;
TYPE rotateMatrix IS ARRAY (0 to 4) OF rotateRow;
CONSTANT rotateConstants : rotateMatrix := ((0, 1, 62, 28, 27), 
									       (36, 44, 6, 55, 20), 
									       (3, 10, 43, 25, 39),
									       (41, 45, 15, 21, 8),
									       (18, 2, 61, 56, 14));
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

--Technique of performing bitwise rotation manually is adapted from Keccak sample VHDL code
--Available at: http://keccak.noekeon.org/KeccakVHDL-3.1.zip
ROTATEX: for x in 0 to 4 generate
	ROTATEY: for y in 0 to 4 generate
		ROTATEBIT: for i in 0 to 15 generate
			internalBState((2*x+3*y) mod 5)(y)(i) <= memState(y)(x)((i - rotateConstants(y)(x)) mod 16);
		end generate;
	end generate;
end generate;

--BStateY:for y in 0 to 4 generate
--	BstateX: for x in 0 to 4 generate
--			internalBState((2*x+3*y) mod 5)(y)<=internalState(y)(x);
--	end generate;
--end generate;

outState <= internalBState(1);


END rhoAndPiArch;
--Selects the round constants used in the IOTA step
--At the end of each round the round constant is XORed with the lane at position [0][0] of the state
--Round constants can be generated on the fly or pre-computed like so. 
--The precomputed 64 bit round constant values can be found at http://keccak.noekeon.org/specs_summary.html


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;	


ENTITY roundConstants IS
PORT(
    roundCounterIn: in integer;
    roundConstantOut: out std_logic_vector(15 downto 0));

END roundConstants;

ARCHITECTURE roundArch OF roundConstants IS
  SIGNAL roundConstant: std_logic_vector(15 downto 0);
BEGIN

PROCESS (roundCounterIn)
BEGIN
	CASE roundCounterIn IS
		WHEN 0 => roundConstant <= X"0001";
		WHEN 1 => roundConstant <= X"8082";
		WHEN 2 => roundConstant <= X"808A";
		WHEN 3 => roundConstant <= X"8000";
		WHEN 4 => roundConstant <= X"808B";
		WHEN 5 => roundConstant <= X"0001";
		WHEN 6 => roundConstant <= X"8081";
		WHEN 7 => roundConstant <= X"8009";
		WHEN 8 => roundConstant <= X"008A";
		WHEN 9 => roundConstant <=  X"0088";
		WHEN 10 => roundConstant <= X"8009";
		WHEN 11 => roundConstant <= X"000A";
		WHEN 12 => roundConstant <= X"808B";
		WHEN 13 => roundConstant <= X"008B";
		WHEN 14 => roundConstant <= X"8089";
		WHEN 15 => roundConstant <= X"8003";
		WHEN 16 => roundConstant <= X"8002";
		WHEN 17 => roundConstant <= X"0080";
		WHEN 18 => roundConstant <= X"800A";
		WHEN 19 => roundConstant <= X"000A";
		WHEN 20 => roundConstant <= X"8081";
		WHEN OTHERS=> roundConstant <= X"0000";
	END CASE;
END PROCESS;

roundConstantOut <= roundConstant;
END roundArch;

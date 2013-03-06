-- 16 bit register
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.sha3_types.all;


ENTITY shaMemory IS
	PORT(write_l: in std_logic;
		  clk: in std_logic;
		  outData:out state;
		  inData: in lane;
		  laneRow: std_logic_vector(2 downto 0);
		  laneCol: std_logic_vector(2 downto 0));
END shaMemory;

ARCHITECTURE memArch OF shaMemory IS
TYPE regOut IS array (24 downto 0) of std_logic_vector(15 downto 0);
SIGNAL rOut: regOut;
SIGNAL rowEnable, colEnable: std_logic_vector(4 downto 0);

COMPONENT reg16
	PORT(rInData:in lane;
		  rOutData:out lane;
		  enabled:in std_logic;
		  clk:in std_logic;
		  reset:in std_logic);
END COMPONENT;
BEGIN
-- If lanRow == 001 and laneCol == 001 then rowEnable = 01000 and colEnable = 01000
PROCESS(laneRow, laneCol)
BEGIN
	CASE laneRow IS
		WHEN "000" => rowEnable <= "10000";
		WHEN "001" => rowEnable <= "01000";
		WHEN "010" => rowEnable <= "00100";
		WHEN "011" => rowEnable <= "00010";
		WHEN "100" => rowEnable <= "00001";
		WHEN OTHERS => rowEnable <= "XXXXX";
	END CASE;
	
	CASE laneCol IS
		WHEN "000" => colEnable <= "10000";
		WHEN "001" => colEnable <= "01000";
		WHEN "010" => colEnable <= "00100";
		WHEN "011" => colEnable <= "00010";
		WHEN "100" => colEnable <= "00001";
		WHEN OTHERS => colEnable <= "XXXXX";
	END CASE;
END PROCESS;

--Output all of the state, if blocks don't need to use it they don't read it.
GenerateRowOne: for i in 0 to 4 generate
	REGOUT0: outData(0)(i) <= rOut(i);
	end generate GenerateRowOne;
	
GenerateRowTwo: for i in 0 to 4 generate
	REGOUT1: outData(1)(i) <= rOut(i);
	end generate GenerateRowTwo;
	
GenerateRowThree: for i in 0 to 4 generate
	REGOUT1: outData(1)(i) <= rOut(i);
	end generate GenerateRowThree;

GenerateRowFour: for i in 0 to 4 generate
	REGOUT1: outData(1)(i) <= rOut(i);
	end generate GenerateRowFour;

GenerateRowFive: for i in 0 to 4 generate
	REGOUT1: outData(1)(i) <= rOut(i);
	end generate GenerateRowFive;
-- First row of the state
R1:reg16 port map (inData,rOut(0), colEnable(0) and rowEnable(0), clk, '1');
R2:reg16 port map (inData,rOut(1), colEnable(1) and rowEnable(0), clk, '1');
R3:reg16 port map (inData,rOut(2), colEnable(2) and rowEnable(0), clk, '1');
R4:reg16 port map (inData,rOut(3), colEnable(3) and rowEnable(0), clk, '1');
R5:reg16 port map (inData,rOut(4), colEnable(4) and rowEnable(0), clk, '1');
--Second row of the state
R6:reg16 port map (inData,rOut(5), colEnable(0) and rowEnable(1), clk, '1');
R7:reg16 port map (inData,rOut(6), colEnable(1) and rowEnable(1), clk, '1');
R8:reg16 port map (inData,rOut(7), colEnable(2) and rowEnable(1), clk, '1');
R9:reg16 port map (inData,rOut(8), colEnable(3) and rowEnable(1), clk, '1');
R10:reg16 port map (inData,rOut(9), colEnable(4) and rowEnable(1), clk, '1');
-- Third row of the state
R11:reg16 port map (inData,rOut(10), colEnable(0) and rowEnable(2), clk, '1');
R12:reg16 port map (inData,rOut(11), colEnable(1) and rowEnable(2), clk, '1');
R13:reg16 port map (inData,rOut(12), colEnable(2) and rowEnable(2), clk, '1');
R14:reg16 port map (inData,rOut(13), colEnable(3) and rowEnable(2), clk, '1');
R15:reg16 port map (inData,rOut(14), colEnable(4) and rowEnable(2), clk, '1');
-- Fourth row of the state
R16:reg16 port map (inData,rOut(15), colEnable(0) and rowEnable(3), clk, '1');
R17:reg16 port map (inData,rOut(16), colEnable(1) and rowEnable(3), clk, '1');
R18:reg16 port map (inData,rOut(17), colEnable(2) and rowEnable(3), clk, '1');
R19:reg16 port map (inData,rOut(18), colEnable(3) and rowEnable(3), clk, '1');
R20:reg16 port map (inData,rOut(19), colEnable(4) and rowEnable(3), clk, '1');
-- Fifth row of the state
R21:reg16 port map (inData,rOut(20), colEnable(0) and rowEnable(4), clk, '1');
R22:reg16 port map (inData,rOut(21), colEnable(1) and rowEnable(4), clk, '1');
R23:reg16 port map (inData,rOut(22), colEnable(2) and rowEnable(4), clk, '1');
R24:reg16 port map (inData,rOut(23), colEnable(3) and rowEnable(4), clk, '1');
R25:reg16 port map (inData,rOut(24), colEnable(4) and rowEnable(4), clk, '1');

---- First row of the state
--R1:reg16 port map (inData,state(0)(0), colEnable(0) and rowEnable(0), clk, '1');
--R2:reg16 port map (inData,state(0)(1), colEnable(1) and rowEnable(0), clk, '1');
--R3:reg16 port map (inData,state(0)(2), colEnable(2) and rowEnable(0), clk, '1');
--R4:reg16 port map (inData,state(0)(3), colEnable(3) and rowEnable(0), clk, '1');
--R5:reg16 port map (inData,state(0)(4), colEnable(4) and rowEnable(0), clk, '1');
----Second row of the state
--R6:reg16 port map (inData, state(1)(0), colEnable(0) and rowEnable(1), clk, '1');
--R7:reg16 port map (inData, state(1)(1), colEnable(1) and rowEnable(1), clk, '1');
--R8:reg16 port map (inData, state(1)(2), colEnable(2) and rowEnable(1), clk, '1');
--R9:reg16 port map (inData, state(1)(3), colEnable(3) and rowEnable(1), clk, '1');
--R10:reg16 port map (inData, state(1)(4), colEnable(4) and rowEnable(1), clk, '1');
---- Third row of the state
--R11:reg16 port map (inData,state(2)(0), colEnable(0) and rowEnable(2), clk, '1');
--R12:reg16 port map (inData,state(2)(1), colEnable(1) and rowEnable(2), clk, '1');
--R13:reg16 port map (inData,state(2)(2), colEnable(2) and rowEnable(2), clk, '1');
--R14:reg16 port map (inData,state(2)(3), colEnable(3) and rowEnable(2), clk, '1');
--R15:reg16 port map (inData,state(2)(4), colEnable(4) and rowEnable(2), clk, '1');
---- Fourth row of the state
--R16:reg16 port map (inData,state(3)(0), colEnable(0) and rowEnable(3), clk, '1');
--R17:reg16 port map (inData,state(3)(1), colEnable(1) and rowEnable(3), clk, '1');
--R18:reg16 port map (inData,state(3)(2), colEnable(2) and rowEnable(3), clk, '1');
--R19:reg16 port map (inData,state(3)(3), colEnable(3) and rowEnable(3), clk, '1');
--R20:reg16 port map (inData,state(3)(4), colEnable(4) and rowEnable(3), clk, '1');
---- Fifth row of the state
--R21:reg16 port map (inData,state(4)(0), colEnable(0) and rowEnable(4), clk, '1');
--R22:reg16 port map (inData,state(4)(1), colEnable(1) and rowEnable(4), clk, '1');
--R23:reg16 port map (inData,state(4)(2), colEnable(2) and rowEnable(4), clk, '1');
--R24:reg16 port map (inData,state(4)(3), colEnable(3) and rowEnable(4), clk, '1');
--R25:reg16 port map (inData,state(4)(4), colEnable(4) and rowEnable(4), clk, '1');


end memArch;
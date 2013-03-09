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
		  laneCol: std_logic_vector(2 downto 0);
		  reset : in std_logic);
END shaMemory;

ARCHITECTURE memArch OF shaMemory IS
TYPE regOut IS array (24 downto 0) of std_logic_vector(15 downto 0);
SIGNAL rOut: regOut;
SIGNAL rowEnable, colEnable: std_logic_vector(4 downto 0);
SIGNAL enabledReg: std_logic_vector(24 downto 0);

COMPONENT reg16
	PORT(rInData:in lane;
		  rOutData:out lane;
		  enabled:in std_logic;
		  clk:in std_logic;
		  reset:in std_logic);
END COMPONENT;
BEGIN
-- If lanRow == 001 and laneCol == 001 then rowEnable = 01000 and colEnable = 01000
PROCESS(laneRow, laneCol, write_l)
BEGIN
	IF (write_l = '1') THEN
		rowEnable <= "00000";
		colEnable <= "00000";
	ELSE
		CASE laneRow IS
			WHEN "000" => rowEnable <= "10000";
			WHEN "001" => rowEnable <= "01000";
			WHEN "010" => rowEnable <= "00100";
			WHEN "011" => rowEnable <= "00010";
			WHEN "100" => rowEnable <= "00001";
			WHEN OTHERS => rowEnable <= "00000";
		END CASE;
		
		CASE laneCol IS
			WHEN "000" => colEnable <= "10000";
			WHEN "001" => colEnable <= "01000";
			WHEN "010" => colEnable <= "00100";
			WHEN "011" => colEnable <= "00010";
			WHEN "100" => colEnable <= "00001";
			WHEN OTHERS => colEnable <= "00000";
		END CASE;
	END IF;
END PROCESS;

GenerateEnabledRowOne: for i in 0 to 4 generate
	EnabledReg0: enabledReg(4 - i) <= colEnable(i) and rowEnable(4);
	end generate GenerateEnabledRowOne;
GenerateEnabledRowTwo: for i in 0 to 4 generate
	EnabledReg1: enabledReg(4 - i + 5) <= colEnable(i) and rowEnable(3);
	end generate GenerateEnabledRowTwo;
GenerateEnabledRowThree: for i in 0 to 4 generate
	EnabledReg2: enabledReg(4 - i + 10) <= colEnable(i) and rowEnable(2);
	end generate GenerateEnabledRowThree;
	
GenerateEnabledRowFour: for i in 0 to 4 generate
	EnabledReg3: enabledReg(4 - i + 15) <= colEnable(i) and rowEnable(1);
	end generate GenerateEnabledRowFour;
	
GenerateEnabledRowFive: for i in 0 to 4 generate
	EnabledReg4: enabledReg(4 - i + 20) <= colEnable(i) and rowEnable(0);
	end generate GenerateEnabledRowFive;
--Output all of the state, if blocks don't need to use it they don't read it.
GenerateRowOne: for i in 0 to 4 generate
	REGOUT0: outData(0)(i) <= rOut(i);
	end generate GenerateRowOne;
	
GenerateRowTwo: for i in 0 to 4 generate
	REGOUT1: outData(1)(i) <= rOut(i + 5);
	end generate GenerateRowTwo;
	
GenerateRowThree: for i in 0 to 4 generate
	REGOUT1: outData(2)(i) <= rOut(i + 10);
	end generate GenerateRowThree;

GenerateRowFour: for i in 0 to 4 generate
	REGOUT1: outData(3)(i) <= rOut(i + 15);
	end generate GenerateRowFour;

GenerateRowFive: for i in 0 to 4 generate
	REGOUT1: outData(4)(i) <= rOut(i + 20);
	end generate GenerateRowFive;
-- First row of the state
R1:reg16 port map (inData,rOut(0), enabledReg(0), clk, reset);
R2:reg16 port map (inData,rOut(1), enabledReg(1), clk, reset);
R3:reg16 port map (inData,rOut(2), enabledReg(2), clk, reset);
R4:reg16 port map (inData,rOut(3), enabledReg(3), clk, reset);
R5:reg16 port map (inData,rOut(4), enabledReg(4), clk, reset);
--Second row of the state
R6:reg16 port map (inData,rOut(5), enabledReg(5), clk, reset);
R7:reg16 port map (inData,rOut(6), enabledReg(6), clk, reset);
R8:reg16 port map (inData,rOut(7), enabledReg(7), clk, reset);
R9:reg16 port map (inData,rOut(8), enabledReg(8), clk, reset);
R10:reg16 port map (inData,rOut(9), enabledReg(9), clk, reset);
-- Third row of the state
R11:reg16 port map (inData,rOut(10), enabledReg(10), clk, reset);
R12:reg16 port map (inData,rOut(11), enabledReg(11), clk, reset);
R13:reg16 port map (inData,rOut(12), enabledReg(12), clk, reset);
R14:reg16 port map (inData,rOut(13), enabledReg(13), clk, reset);
R15:reg16 port map (inData,rOut(14), enabledReg(14), clk, reset);
-- Fourth row of the state
R16:reg16 port map (inData,rOut(15), enabledReg(15), clk, reset);
R17:reg16 port map (inData,rOut(16), enabledReg(16), clk, reset);
R18:reg16 port map (inData,rOut(17), enabledReg(17), clk, reset);
R19:reg16 port map (inData,rOut(18), enabledReg(18), clk, reset);
R20:reg16 port map (inData,rOut(19), enabledReg(19), clk, reset);
-- Fifth row of the state
R21:reg16 port map (inData,rOut(20), enabledReg(20), clk, reset);
R22:reg16 port map (inData,rOut(21), enabledReg(21), clk, reset);
R23:reg16 port map (inData,rOut(22), enabledReg(22), clk, reset);
R24:reg16 port map (inData,rOut(23), enabledReg(23), clk, reset);
R25:reg16 port map (inData,rOut(24), enabledReg(24), clk, reset);

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
-- 16 bit register
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.sha3_types.all;

ENTITY shaMemory IS
	PORT(write_l: in std_logic;
		  clk,: in std_logic;
		  outData:out lane;
		  inData: in lane;
		  laneRow: std_logic_vector(2 downto 0);
		  laneCol: std_logic_vector(2 downto 0));
END shaMemory;

ARCHITECTURE memArch OF shaMemory IS
SIGNAL enable: std_logic_vector
SIGNAL rowEnable, colEnable: std_logic_vector(4 downto 0);

COMPONENT reg16
	PORT(inData:in lane;
		  outData: out lane;
		  enabled:in std_logic;
		  clk:in std_logic;
		  reset:in std_logic);
END COMPONENT;
BEGIN
-- If lanRow == 001 and laneCol == 001 then rowEnable = 01000 and colEnable = 01000
PROCESS
BEGIN
END PROCESS;

R1:reg16 port map (inData,outData, , clk, '1');
R2:reg16 port map (inData,outData, clk, clk, '1');
R3:reg16 port map (inData,outData, clk, clk, '1');
R4:reg16 port map (inData,outData, clk, clk, '1');
R5:reg16 port map (inData,outData, clk, clk, '1');
R6:reg16 port map (inData,outData, clk, clk, '1');
R7:reg16 port map (inData,outData, clk, clk, '1');
R8:reg16 port map (inData,outData, clk, clk, '1');
R9:reg16 port map (inData,outData, clk, clk, '1');
R10:reg16 port map (inData,outData, clk, clk, '1');
R11:reg16 port map (inData,outData, clk, clk, '1');
R12:reg16 port map (inData,outData, clk, clk, '1');
R13:reg16 port map (inData,outData, clk, clk, '1');
R14:reg16 port map (inData,outData, clk, clk, '1');
R15:reg16 port map (inData,outData, clk, clk, '1');
R16:reg16 port map (inData,outData, clk, clk, '1');
R17:reg16 port map (inData,outData, clk, clk, '1');
R18:reg16 port map (inData,outData, clk, clk, '1');
R19:reg16 port map (inData,outData, clk, clk, '1');
R20:reg16 port map (inData,outData, clk, clk, '1');
R21:reg16 port map (inData,outData, clk, clk, '1');
R22:reg16 port map (inData,outData, clk, clk, '1');
R23:reg16 port map (inData,outData, clk, clk, '1');
R24:reg16 port map (inData,outData, clk, clk, '1');
R25:reg16 port map (inData,outData, clk, clk, '1');

end memArch;
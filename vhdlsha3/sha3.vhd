library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

library work;
use work.sha3_types.all;

ENTITY sha3 IS
PORT(inputLane :in lane;
	  outputLane :out lane;
	  memOutOut: out state;
	  dataOutCount: out integer range 0 to 25;
	  clk: std_logic;
	  reset:std_logic);
END sha3;

ARCHITECTURE shaArch OF sha3 IS
SIGNAL mainState: std_logic_vector(4 downto 0);
SIGNAL dataInCounter :integer range 0 to 25;
SIGNAL colSelect: std_logic_vector(2 downto 0);
SIGNAL rowSelect: std_logic_vector(2 downto 0);
SIGNAL readFromMem: std_logic;
signal memOut:state;
signal thetaState:row;
--state registers
COMPONENT shaMemory
	PORT(write_l: in std_logic;
		  clk: in std_logic;
		  outData:out state;
		  inData: in lane;
		  laneRow: std_logic_vector(2 downto 0);
		  laneCol: std_logic_vector(2 downto 0);
		  reset: in std_logic);
END COMPONENT;
COMPONENT theta
	PORT(thetaInData: in state;
		  thetaOutData:out row;
		  thetaSelect: in std_logic;
		  clk: std_logic);
END COMPONENT;
BEGIN
--PROCESS(dataInCounter)
--
--BEGIN
--	CASE dataInCounter IS
--		WHEN 0 =>
--			rowSelect <= "000";	
--			colSelect <= "000";
--		WHEN 1 =>
--			rowSelect <= "000";
--			colSelect <= "001";
--		WHEN 2 =>
--			rowSelect <= "000";
--			colSelect <= "010";
--		WHEN 3 =>
--			rowSelect <= "000";
--			colSelect <= "010";
--		WHEN 4 =>
--			rowSelect <= "000";
--			colSelect <= "100";
--		WHEN  =>
--			rowSelect <= "000";
--			colSelect <= "100";
--		WHEN OTHERS => 
--			rowSelect <= "000";
--			colSelect <= "000";
--			
--	END CASE;
--END PROCESS;

PROCESS (clk, reset)
BEGIN
	IF (reset = '1') THEN
		mainState <= "00000";
		dataInCounter <= 0;
		colSelect <= "000";
		rowSelect <= "000";
	ELSIF (rising_edge(clk)) THEN
		CASE (mainState) IS
			--First state -- Load data with the initial state;
			WHEN "00000" =>
				readFromMem <= '0';
				if (dataInCounter < 25) then
					mainState <= "00000";
					dataInCounter <= dataInCounter + 1;
					if (colSelect < 4) then
						colSelect <= colSelect + 1;
					else
						colSelect <= "000";
						rowSelect <= rowSelect + 1;
					end if;
				else 
					colSelect <= "111";
					rowSelect <= "111";
					readFromMem <= '1'; 
					mainState <= "00001";
				end if;
			WHEN "00001" =>
				mainState <="00001";
					
			WHEN OTHERS => 
				mainState <= "00000";
		END CASE;
	END IF;
END PROCESS;
memOutOut <= memOut;
dataOutCount <= dataInCounter;
MEM:shaMemory port map (readFromMem, clk, memOut,inputLane, rowSelect, colSelect, reset);
THETASTEP:theta port map(memOut, thetaState, '1', clk);
END shaArch;
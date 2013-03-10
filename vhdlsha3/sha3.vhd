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
	  colOut: out std_logic_vector(2 downto 0);
	  rowOut: out std_logic_vector(2 downto 0);
	  systemState: out std_logic_vector (4 downto 0);
	  thetaStateOut: out row;
	  clk:in std_logic;
	  reset:in std_logic);
END sha3;

ARCHITECTURE shaArch OF sha3 IS
SIGNAL mainState: std_logic_vector(4 downto 0);
SIGNAL dataInCounter :integer range 0 to 25;
SIGNAL colSelect: std_logic_vector(2 downto 0);
SIGNAL rowSelect: std_logic_vector(2 downto 0);
SIGNAL readFromMem: std_logic;
SIGNAL thetaReady: std_logic;
SIGNAL thetaStart: std_logic;
SIGNAL memInput: lane;
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
	PORT(start:in std_logic;
		 reset:in std_logic;
		 ready:out std_logic;
		 thetaInData: in state;
		 thetaOutData:out row;
		 clk:in std_logic);
END COMPONENT;
BEGIN

colOut <= colSelect;
rowOut <= rowSelect;
systemState <= mainState;
thetaStateOut <= thetaState;
PROCESS (clk, reset)
BEGIN
	IF (reset = '1') THEN
		mainState <= "00000";
		colSelect <= "111";
		rowSelect <= "111";
	ELSIF (rising_edge(clk)) THEN
		CASE (mainState) IS
			--First state -- Load data with the initial state;
			WHEN "00000" =>
				readFromMem <= '0';
				memInput <= inputLane;
				if (rowSelect /= "101" ) then
					mainState <= "00000";
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
			--wait for 
			WHEN "00001" =>
				IF (thetaReady = '1') THEN
					mainState <= "00010";
				ELSE
					mainState <= "00001";
				END IF;
			WHEN "00010" =>
				thetaStart <= '1';
				readFromMem <= '0';
				IF (rowSelect /= "101") THEN
					if (colSelect < 4) then
						colSelect <= colSelect + 1;
					else
						colSelect <= "000";
						rowSelect <= rowSelect + 1;
					end if;		
						
					CASE (rowSelect) IS
						WHEN "000" => memInput <= thetaState(0);
						WHEN "001" => memInput <= thetaState(1);
						WHEN "010" => memInput <= thetaState(2);
						WHEN "011" => memInput <= thetaState(3);
						WHEN "100" => memInput <= thetaState(4);
						WHEN OTHERS => readFromMem <= '1';
					END CASE;

				ELSE
					thetaStart <= '0';
					colSelect <= "111";
					rowSelect <= "111";
					readFromMem <= '1'; 
					mainState <= "00011";
				END IF;
						
			WHEN OTHERS => 
				mainState <= "00000";
		END CASE;
	END IF;
END PROCESS;
memOutOut <= memOut;
dataOutCount <= dataInCounter;
MEM:shaMemory port map (readFromMem, clk, memOut,memInput, rowSelect, colSelect, reset);
THETASTEP:theta port map(thetaStart, reset, thetaReady, memOut, thetaState, clk);
END shaArch;
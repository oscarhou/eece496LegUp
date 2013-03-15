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
	  thetaHoldOut:out std_logic;
	  rhoandpiHoldOut: out std_logic;
	  clk:in std_logic;
	  reset:in std_logic);
END sha3;

ARCHITECTURE shaArch OF sha3 IS
SIGNAL mainState: std_logic_vector(4 downto 0);
SIGNAL keccakInternalState : state;
SIGNAL dataInCounter :integer range 0 to 25;
SIGNAL clockCounter: integer;
SIGNAL roundCounter: integer range 0 to 22;
SIGNAL colSelect: std_logic_vector(2 downto 0);
SIGNAL rowSelect: std_logic_vector(2 downto 0);
SIGNAL readFromMem: std_logic;
SIGNAL thetaHold: std_logic;
SIGNAL thetaStart: std_logic;
SIGNAL rhoandpiOutState:state;
SIGNAL rhoandpiHold:std_logic;
SIGNAL roundConstant: std_logic_vector(15 downto 0);
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
	PORT(hold:in std_logic;
		 thetaInData: in state;
		 thetaOutData:out row;
		 clk:in std_logic);
END COMPONENT;
COMPONENT rhoandpi IS
PORT(inState: in state;
	 outState: out state;
	 hold: in std_logic;
	 clk: in std_logic);
END COMPONENT;
BEGIN
--NOTE: The first index of the state is the row index(\/), the second is the column index (-->). 
colOut <= colSelect;
rowOut <= rowSelect;
systemState <= mainState;
thetaStateOut <= thetaState;
PROCESS (clk, reset)
BEGIN
	--RESET state
	IF (reset = '1') THEN
		mainState <= "00000";
		colSelect <= "111";
		rowSelect <= "111";
		rhoandpiHold <= '0';
		thetaHold <= '0';
		roundCounter <= 0;
		clockCounter <= 0;
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
					colSelect <= "000";
					rowSelect <= "000";
					readFromMem <= '1'; 
					keccakInternalState <= memOut;
					mainState <= "00001";
					thetaHold <= '1';
				end if;
			--wait for 2 clocks for signals to settle
			WHEN "00001" =>
				if (clockCounter = 2) then
					mainState <= "00010";
				else
					clockCounter <= clockCounter + 1;
				end if;
			WHEN "00010" =>
				thetaHold <= '1';
				SAVETHETAX: for x in 0 to 4 loop
					SAVETHETAY: for y in 0 to 4 loop
						keccakInternalState(y)(x) <= keccakInternalState(y)(x) xor thetaState(x);
					end loop;
				end loop;
				rhoandpiHold <= '1';
				mainState <= "00011";
			WHEN "00011" =>
				thetaHold <= '0';
				SAVERAPX: for x in 0 to 4 loop
					SAVERAPY: for y in 0 to 4 loop
					 -- A[x,y] = B[x,y] xor ((not B[x+1,y]) and B[x+2,y]), forall (x,y) in (0…4,0…4)
						keccakInternalState(y)(x) <= rhoandpiOutState(y)(x) xor (not(rhoandpiOutState(y)((x + 1) mod 5)) and rhoandpiOutState(y)((x + 2) mod 5));
					end loop;
				end loop;
			WHEN "00100" =>
				keccakInternalState(0)(0) <= keccakInternalState(0)(0) xor roundConstant;
				roundCounter <= roundCounter + 1;
				rhoandpiHold <= '0';
				mainState <= "00001";
			WHEN OTHERS => 
				mainState <= "00000";
		END CASE;
	END IF;
END PROCESS;
--Selects the round constants
PROCESS (roundCounter)
BEGIN
	CASE roundCounter IS
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
--		RC[0] = (Lane)0x0000000000000001;
--    RC[1] = (Lane)0x0000000000008082;
--    RC[2] = (Lane)0x800000000000808A;
--    RC[3] = (Lane)0x8000000080008000;
--    RC[4] = (Lane)0x000000000000808B;
--    RC[5] = (Lane)0x0000000080000001;
--    RC[6] = (Lane)0x8000000080008081;
--    RC[7] = (Lane)0x8000000000008009;
--    RC[8] = (Lane)0x000000000000008A;
--    RC[9] = (Lane)0x0000000000000088;
--    RC[10] = (Lane)0x0000000080008009;
--    RC[11] = (Lane)0x000000008000000A;
--    RC[12] = (Lane)0x000000008000808B;
--    RC[13] = (Lane)0x800000000000008B;
--    RC[14] = (Lane)0x8000000000008089;
--    RC[15] = (Lane)0x8000000000008003;
--    RC[16] = (Lane)0x8000000000008002;
--    RC[17] = (Lane)0x8000000000000080;
--    RC[18] = (Lane)0x000000000000800A;
--    RC[19] = (Lane)0x800000008000000A;
--    RC[20] = (Lane)0x8000000080008081;
--    RC[21] = (Lane)0x8000000000008080;
--    RC[22] = (Lane)0x0000000080000001;
--    RC[23] = (Lane)0x8000000080008008;

	END CASE;
END PROCESS;
thetaHoldOut <= thetaHold;
rhoandpiHoldOut <= rhoandpiHold;
memOutOut <= keccakInternalState;
dataOutCount <= dataInCounter;
MEM:shaMemory port map (readFromMem, clk, memOut,memInput, rowSelect, colSelect, reset);
THETASTEP:theta port map(thetaHold, keccakInternalState, thetaState, clk);
RHOANDPISTEP: rhoandpi port map(keccakInternalState, rhoandpiOutState, rhoandpiHold, clk);
END shaArch;
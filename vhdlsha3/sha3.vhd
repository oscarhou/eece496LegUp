library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

library work;
use work.sha3_types.all;

ENTITY sha3 IS
PORT(inputLane :in lane;
	  memOutOut: out state;
	  colOut: out std_logic_vector(2 downto 0);
	  rowOut: out std_logic_vector(2 downto 0);
	  systemState: out std_logic_vector (4 downto 0);
	  roundConstantOut: out std_logic_vector(15 downto 0);
	  valid:out std_logic;
	  clk:in std_logic;
	  reset:in std_logic);
END sha3;

ARCHITECTURE shaArch OF sha3 IS
SIGNAL mainState: std_logic_vector(4 downto 0);
SIGNAL keccakInternalState : state;
SIGNAL dataInCounter :integer range 0 to 25;
SIGNAL clockCounter: integer;
SIGNAL roundCounter: integer range 0 to 20;
SIGNAL colSelect: std_logic_vector(2 downto 0);
SIGNAL rowSelect: std_logic_vector(2 downto 0);
SIGNAL readFromMem: std_logic;
SIGNAL thetaInState : state;
SIGNAL rhoandpiOutState:state;
SIGNAL rhoandpiInState: state;
SIGNAL chiOutState:state;
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
COMPONENT chi IS
PORT (chiInState: in state;
      chiOutState: out state);      
END COMPONENT;
COMPONENT theta
	PORT(thetaInData: in state;
		 thetaOutData:out row);
END COMPONENT;
COMPONENT rhoandpi IS
PORT(inState: in state;
	 outState: out state);
END COMPONENT;
BEGIN
--NOTE: The first index of the state is the row index(\/), the second is the column index (-->). 
colOut <= colSelect;
rowOut <= rowSelect;
systemState <= mainState;
PROCESS (clk, reset)
BEGIN
	--RESET state
	IF (reset = '1') THEN
		valid <= '0';
		mainState <= "00000";
		colSelect <= "111";
		rowSelect <= "111";
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
					--Increment the column select 4 times before
					--incrementing rowselect once.
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
				end if;
			--wait for 2 clocks for signals to settle
			WHEN "00001" =>
				thetaInState <= keccakInternalState;
				mainState <= "00010";
			WHEN "00010" =>
				--Part of the theta step.
				--XOR the output of the theta block into the state
				SAVETHETAX: for x in 0 to 4 loop
					SAVETHETAY: for y in 0 to 4 loop
						keccakInternalState(y)(x) <= keccakInternalState(y)(x) xor thetaState(x);
					end loop;
				end loop;
				mainState <= "00011";
			--Pass the current state into the RhoandPi Block
			--The block is combinational and the output goes
			--directly into the chi block
			WHEN "00011" =>
				rhoandpiInState <= keccakInternalState;
				mainState <= "00100";
			--Assign the main state to be the output of the chi block
			WHEN "00100" =>
				keccakInternalState <= chiOutState;
				mainState <= "00101";
			WHEN "00101" =>
				--Iota step of the SHA3 algorithm
				keccakInternalState(0)(0) <= keccakInternalState(0)(0) xor roundConstant;
				mainState <= "00110";
			WHEN "00110" =>
				--Show the final state of the round function on the output
				memOutOut <= keccakInternalState;
				roundCounter <= roundCounter + 1;
				--If the last round then jump to the output hold state
				if (roundCounter = 19) then
					mainState <= "00111";
					valid <= '1';
				else -- Else restart the round function with the incremented round counter/constant
					mainState <= "00001";
				end if;
			WHEN "00111" =>
				mainState <= "00111";
				-- Hold the data output until reset is triggered.
			WHEN OTHERS => 
				mainState <= "00000";
		END CASE;
	END IF;
END PROCESS;
--Selects the round constants
--At the end of each round the round constant is XORed with the lane at position [0][0] of the state
--Round constants can be generated on the fly or pre-computed like so. 
--The precomputed 64 bit round constant values can be found at http://keccak.noekeon.org/specs_summary.html
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
	END CASE;
END PROCESS;
roundConstantOut <= roundConstant;

--Memory block for passing in data one lane at a time
MEM:shaMemory port map (readFromMem, clk, memOut,memInput, rowSelect, colSelect, reset);
-- Perform the Theta step of the SHA-3 Algorithm
THETASTEP:theta port map(thetaInState, thetaState);
-- Perform the rho and pi step of the algorithm
RHOANDPISTEP: rhoandpi port map(rhoandpiInState, rhoandpiOutState);
-- Perform the chi step of the algorithm
CHISTEP: chi port map(rhoandpiOutState, chiOutState);

END shaArch;
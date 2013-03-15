-- This file implements the CHI step of the SHA-3 Algorithm (Keccak)
-- An explanation of the algorithm can be found at http://keccak.noekeon.org/
library work;
use work.sha3_types.all;
library ieee;
use ieee.std_logic_1164.all;

ENTITY chi IS
PORT (chiInState: in state;
      chiOutState: out state);      
end chi;

ARCHITECTURE chiArch OF chi IS
SIGNAL internalChiState :state;
SIGNAL afterProcessChiState :state;
BEGIN

CHIX:for x in 0 to 4 generate
	CHIY: for y in 0 to 4 generate
		afterProcessChiState(y)(x) <= internalChiState(y)(x) xor (not(internalChiState(y)((x + 1) mod 5)) and internalChiState(y)((x + 2) mod 5));
	end generate;
end generate;

internalChiState <= chiInState;
chiOutState <= afterProcessChiState;
END chiArch;
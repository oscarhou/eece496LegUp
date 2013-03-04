-- 16 bit register
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.sha3_types.all;

ENTITY reg16 IS
PORT(inData    :in lane;
	  outData   :out lane;
	  enabled :in std_logic;
	  clk: in std_logic;
	  reset: in std_logic );
END reg16;

architecture registerArch of reg16 is
begin
	process(enabled, reset, clk)
	begin
		if (reset = '1') then	
			outData <= "0000000000000000";
		elsif (rising_edge(clk) and enabled='1') then
			outData <= inData;
		end if;
	end process;
end registerArch;
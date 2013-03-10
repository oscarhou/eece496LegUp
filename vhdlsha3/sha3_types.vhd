library IEEE;
    use IEEE.std_logic_1164.all;
    USE ieee.numeric_std.all;

library work;
package sha3_types is
	subtype lane is unsigned(15 downto 0);
	type row is array(4 downto 0) of lane;
	type state is array(4 downto 0) of row;
end sha3_types;
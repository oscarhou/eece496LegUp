library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_misc.all;
    use IEEE.std_logic_arith.all;
library work;
package sha3_types is
	subtype lane is std_logic_vector(15 downto 0);
	type row is array(4 downto 0) of lane;
	type state is array(4 downto 0) of row;
end sha3_types;
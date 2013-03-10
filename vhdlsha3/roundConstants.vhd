library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;	


ENTITY roundConstants IS
PORT(
    round: in std_logic_vector(4 downto 0);
    roundConstantOut: out std_logic_vector(63 downto 0));

END roundConstants;

ARCHITECTURE roundArch OF roundConstants IS
  SIGNAL internalRoundConstant: std_logic_vector(63 downto 0);
BEGIN

PROCESS (round)
BEGIN
	CASE round IS
      WHEN "00000" => internalRoundConstant <= X"0000000000000000" ;	
      WHEN "00001" => internalRoundConstant <= X"0000000000000001" ;
	    WHEN "00010" => internalRoundConstant <= X"0000000000008082" ;
	    WHEN "00011" => internalRoundConstant <= X"800000000000808A" ;
	    WHEN "00100" => internalRoundConstant <= X"8000000080008000" ;
	    WHEN "00101" => internalRoundConstant <= X"000000000000808B" ;
	    WHEN "00110" => internalRoundConstant <= X"0000000080000001" ;
	    WHEN "00111" => internalRoundConstant <= X"8000000080008081" ;
	    WHEN "01000" => internalRoundConstant <= X"8000000000008009" ;
	    WHEN "01001" => internalRoundConstant <= X"000000000000008A" ;
	    WHEN "01010" => internalRoundConstant <= X"0000000000000088" ;
	    WHEN "01011" => internalRoundConstant <= X"0000000080008009" ;
	    WHEN "01100" => internalRoundConstant <= X"000000008000000A" ;
	    WHEN "01101" => internalRoundConstant <= X"000000008000808B" ;
	    WHEN "01110" => internalRoundConstant <= X"800000000000008B" ;
	    WHEN "01111" => internalRoundConstant <= X"8000000000008089" ;
	    WHEN "10000" => internalRoundConstant <= X"8000000000008003" ;
	    WHEN "10001" => internalRoundConstant <= X"8000000000008002" ;
	    WHEN "10010" => internalRoundConstant <= X"8000000000000080" ;
	    WHEN "10011" => internalRoundConstant <= X"000000000000800A" ;
	    WHEN "10100" => internalRoundConstant <= X"800000008000000A" ;
	    WHEN "10101" => internalRoundConstant <= X"8000000080008081" ;
	    WHEN "10110" => internalRoundConstant <= X"8000000000008080" ;
	    WHEN "10111" => internalRoundConstant <= X"0000000080000001" ;
	    WHEN "11000" => internalRoundConstant <= X"8000000080008008" ;	    	    
	    WHEN OTHERS => internalRoundConstant <=(OTHERS => '0');
        END CASE;
END PROCESS;

roundConstantOut <= internalRoundConstant;
END roundArch;

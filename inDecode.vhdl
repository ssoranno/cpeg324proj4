-- Steven Soranno and Evan DeAngelis
-- Instruction Decode

library ieee;
use ieee.std_logic_1164.all;

-- Main entity
entity inDecode is
	port (
    I  : in std_logic_vector(7 downto 0); -- Input instruction vector 
	ConSig : in std_logic; -- Controll signal to determine whether registers the ID should output
    r1 : out std_logic_vector(1 downto 0); -- register 1 output
	r2 : out std_logic_vector(1 downto 0); -- register 2 output
	rd : out std_logic_vector(1 downto 0); -- register destination output
	imm : out std_logic_vector(3 downto 0)); -- immediate value output
end inDecode;

architecture decode of inDecode is
-- Declare signals
signal s1 : std_logic_vector(1 downto 0);
signal s2 : std_logic_vector(3 downto 0);
begin
	
	-- This mux determines if s1 is I(5 downto 4) or I(1 downto 0) based on if the intruction is a print or compare instruction
	s1<= I(5 downto 4) when ConSig='1' else
		I(1 downto 0) when ConSig='0';
	
	-- This mux extends the size of the skip immediate value by 2 bits
	s2<= "0000" when I(1 downto 0) = "00" else
		"0001" when I(1 downto 0) = "01" else
		"0010" when I(1 downto 0) = "10" else
		"0011" when I(1 downto 0) = "11";
	
	-- This mux determines the value of the register 1 output
	r1<= I(3 downto 2) when I(7) = '0' else
		s1 when I(7)= '1';
	
	-- This mux determins the value of the register 2 output
	r2<= I(1 downto 0) when I(7) = '0' else
		I(3 downto 2) when I(7) = '1';
	
	-- This mux determines the value of the register destination output
	rd<= I(5 downto 4);
	
	-- This mux determines the value of the immediate output
	imm<= s2 when I(6)= '1' else
		I(3 downto 0) when I(6) = '0';
		
end decode;
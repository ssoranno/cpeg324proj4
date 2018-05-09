-- Steven Soranno and Evan DeAngelis
-- Controller

library ieee;
use ieee.std_logic_1164.all;

-- Main entity
entity Controller is
port(	i : in std_logic_vector(7 downto 0); -- Input instruction vector
 		aluSkip: out STD_LOGIC; -- ALUskip controll signal (ALU is skipped if the intruction is print or compare/BEQ
 		print: out STD_LOGIC; -- print function signal
 		dispBEQ: out STD_LOGIC; -- dispBEQ (compare vs display) control signal
 		regwrite: out STD_LOGIC; -- register write control signal
 		addsub: out STD_LOGIC; -- add or subract signal for the ALU
 		load: out STD_LOGIC -- load controll signal that determines the write back value for the register file
	);
end Controller;

architecture behav of Controller is
	-- Declare signals
	signal s : std_logic_vector(3 downto 0);

begin

	addsub<=i(7) or i(6);
	load<= not i(7);
	regwrite<=i(6) nand i(7);
	s(3)<= (not i(6)) and i(7);
	s(2)<= not(i(5) or i(4) or i(3) or i(2));
	s(1)<= i(7) and i(6);
	s(0)<= s(1) and s(2);
	print<= s(0);
	aluSkip<= s(3) or s(0);
	dispBEQ<= s(1) and not(s(2));

	
end architecture behav;
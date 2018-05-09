-- Steven Soranno and Evan Deangelis
-- sign extend

library ieee;
use ieee.std_logic_1164.all;
 

 entity sign_extend is
 port(	i : in std_logic_vector(3 downto 0); -- 4 bit immediate value to extend
 		o: out std_logic_vector(7 downto 0) -- 8 bit output
	);
end sign_extend;

architecture behav of sign_extend is

begin
-- Extend the immediate by 4 bits
o(7 downto 4)<="0000" when i(3)='0' else
	"1111" when i(3)='1';
	
o(3 downto 0)<= i(3 downto 0);

end behav;
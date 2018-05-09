-- Steven Soranno and Evan Deangelis
-- 8 bit flip flop

library ieee;
use ieee.std_logic_1164.all;

-- main entity
entity flipFlop_8bit is
	port(
	d : in std_logic_vector(7 downto 0); -- 8 bit input
	clk : in std_logic; -- clock
	enable : in std_logic; -- enable input
	q : out std_logic_vector(7 downto 0)); -- 8 bit output
end flipFlop_8bit;

architecture ff of flipFlop_8bit is
begin

-- This process creates the flipflop and stores the value d in it.
process(clk)
begin
	if rising_edge(clk) then
		if(enable = '1') then
			q<= d;
		end if;
	end if;
end process;

end ff;

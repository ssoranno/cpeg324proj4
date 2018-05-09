-- Steven Soranno and Evan DeAngelis
-- Print Function

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Print function entity
entity print is
	port(
		I : in std_logic_vector(7 downto 0); -- 8 bit value to print
		EN : in std_logic; -- print function enable (used by compare instruction)
		clk : in std_logic -- clock input
	);
end print;

architecture behav of print is
begin

-- This process prints the value of I to the screen using the report command
process(clk)
-- Declare variables
variable num: integer;
variable o1: string (1 to 1);
variable o2: string (1 to 1);
variable o3: string (1 to 1);
variable sign: string(1 to 1);
variable temp: integer;
variable output: string(1 to 4);

begin
	-- Print the value on the falling edge of the clock and when the enable is 1
	if falling_edge(clk) then
		if EN = '1' then
			num:= to_Integer(signed(I)); -- Convert the std_logic_vector input value to an integer
			-- If the value is less than 0 create a sign variable
			if num < 0 then
				sign:= "-";
				temp:=(-1)*num;
			else 
				sign:= " ";
				temp:=num;
			end if;
			-- Convert each digit in the integer to a string
			o1:= integer'image((temp/100)mod 10);
			o2:= integer'image((temp/10)mod 10);
			o3:= integer'image(temp mod 10);
			-- Create the output variable
			if temp < 10 then
				output:= " "&" "&sign&o3;
			elsif temp < 100 then
				output:= " "&sign&o2&o3;
			else
				output:= sign&o1&o2&o3;
			end if;
			report output; -- print the output value to the screen
		end if;
	end if;
end process;

end behav;
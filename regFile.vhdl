-- Steven Soranno and Evan Deangelis
-- register file

library ieee;
use ieee.std_logic_1164.all;

-- main entity
entity regFile is
	port (
	r1 : in std_logic_vector(1 downto 0); -- register 1 binary value
	r2 : in std_logic_vector(1 downto 0); -- register 2 binary value
	rd : in std_logic_vector(1 downto 0); -- register destination binary value
	wb : in std_logic_vector(7 downto 0); -- value to write back to the destiation register
	clk : in std_logic; -- clock input
	enable : in std_logic; -- enable input
	o1 : out std_logic_vector(7 downto 0); -- output 1 for ALU
	o2 : out std_logic_vector(7 downto 0)); -- output 2 for ALU
end regFile;

architecture reg of regFile is
-- compont for each of the register flipflops
component flipFlop_8bit is	
	port(
	d : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	enable : in std_logic;
	q : out std_logic_vector(7 downto 0));
end component;

-- Declare signals
signal v0 : std_logic_vector(7 downto 0);
signal v1 : std_logic_vector(7 downto 0);
signal v2 : std_logic_vector(7 downto 0);
signal v3 : std_logic_vector(7 downto 0);

signal t0 : std_logic_vector(7 downto 0);
signal t1 : std_logic_vector(7 downto 0);
signal t2 : std_logic_vector(7 downto 0);
signal t3 : std_logic_vector(7 downto 0);



begin

-- Write back demux based on the enable and register destination signals
v0<= wb when rd= "00" and enable ='1';
v1<= wb when rd= "01" and enable ='1';
v2<= wb when rd= "10" and enable ='1';
v3<= wb when rd= "11" and enable ='1';

-- Four register flipflip portmaps
FF0: flipFlop_8bit port map(d=>v0, clk=>clk, enable=>enable, q=>t0);
FF1: flipFlop_8bit port map(d=>v1, clk=>clk, enable=>enable, q=>t1);
FF2: flipFlop_8bit port map(d=>v2, clk=>clk, enable=>enable, q=>t2);
FF3: flipFlop_8bit port map(d=>v3, clk=>clk, enable=>enable, q=>t3);

-- output 1 mux based on register 1
o1<= t0 when r1="00" else
	t1 when r1="01" else
	t2 when r1="10" else
	t3 when r1="11";

-- output 2 mux based on register 2
o2<= t0 when r2="00" else
	t1 when r2="01" else
	t2 when r2="10" else
	t3 when r2="11";

end reg;
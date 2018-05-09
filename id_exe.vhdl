library ieee;
use ieee.std_logic_1164.all;

-- main entity
entity id_exe is
	port (
	rd : in std_logic_vector(1 downto 0); -- register destination binary value
	imm : in std_logic_vector(3 downto 0);
	rego1 : in std_logic_vector(7 downto 0);
	rego2 : in std_logic_vector(7 downto 0);
	cs1: in std_logic;
	cs2: in std_logic;
	cs3: in std_logic;
	cs4: in std_logic;
	cs5: in std_logic;
	cs6: in std_logic;
	clk : in std_logic; -- clock input
	enable : in std_logic; -- enable input
	ord : out std_logic_vector(1 downto 0); -- output 1 for ALU
	oimm : out std_logic_vector(3 downto 0); -- output 2 for ALU
	o1 : out std_logic_vector(7 downto 0); -- output 2 for ALU
	o2 : out std_logic_vector(7 downto 0); -- output 2 for ALU
	ocs1 : out std_logic; -- output 2 for ALU
	ocs2 : out std_logic;
	ocs3 : out std_logic;
	ocs4 : out std_logic;
	ocs5 : out std_logic;
	ocs6 : out std_logic;

architecture reg of id_exe is
-- compont for each of the register flipflops
component flipFlop_8bit is	
	port(
	d : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	enable : in std_logic;
	q : out std_logic_vector(7 downto 0));
end component;

begin

RDest: flipFlop_2bit port map(d=>rd, clk=>clk, enable=>enable, q=>ord);
IMME: flipFlop_4bit port map(d=>imm, clk=>clk, enable=>enable, q=>oimm);
Out1: flipFlop_8bit port map(d=>rego1, clk=>clk, enable=>enable, q=>);
Out2: flipFlop_8bit port map(d=>v0, clk=>clk, enable=>enable, q=>t0);
C1: flipFlop_bit port map(d=>v0, clk=>clk, enable=>enable, q=>t0);
C2: flipFlop_bit port map(d=>v0, clk=>clk, enable=>enable, q=>t0);
C3: flipFlop_bit port map(d=>v0, clk=>clk, enable=>enable, q=>t0);
C4: flipFlop_bit port map(d=>v0, clk=>clk, enable=>enable, q=>t0);
C5: flipFlop_bit port map(d=>v0, clk=>clk, enable=>enable, q=>t0);
C6: flipFlop_bit port map(d=>v0, clk=>clk, enable=>enable, q=>t0);
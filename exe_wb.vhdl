library ieee;
use ieee.std_logic_1164.all;

-- main entity
entity exe_wb is
	port (
	inTemp: in std_logic;
	ALUO: in std_logic_vector(7 downto 0);
	imm : in std_logic_vector(7 downto 0);
	cs1: in std_logic;
	cs2: in std_logic;
	cs3: in std_logic;
	cs4: in std_logic;
	cs5: in std_logic;
	cs6: in std_logic;
	clk : in std_logic; -- clock input
	enable : in std_logic; -- enable input
	rd : in std_logic_vector(1 downto 0); -- register destination binary value
	oinTemp: out std_logic;
	oALUO: out std_logic_vector(7 downto 0);
	oimm : out std_logic_vector(7 downto 0); -- output 2 for ALU
	ocs1: out std_logic;
	ocs2: out std_logic;
	ocs3: out std_logic;
	ocs4 : out std_logic;
	ocs5 : out std_logic;
	ocs6 : out std_logic;
	ord : out std_logic_vector(1 downto 0) -- output 1 for ALU
	);
end exe_wb;

architecture reg of exe_wb is
-- compont for each of the register flipflops
component flipFlop_8bit is	
	port(
	d : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	enable : in std_logic;
	q : out std_logic_vector(7 downto 0));
end component;

component flipFlop_4bit is	
	port(
	d : in std_logic_vector(3 downto 0);
	clk : in std_logic;
	enable : in std_logic;
	q : out std_logic_vector(3 downto 0));
end component;

component flipFlop_2bit is	
	port(
	d : in std_logic_vector(1 downto 0);
	clk : in std_logic;
	enable : in std_logic;
	q : out std_logic_vector(1 downto 0));
end component;

component flipFlop_bit is	
	port(
	d : in std_logic;
	clk : in std_logic;
	enable : in std_logic;
	q : out std_logic);
end component;

begin

IT: flipFlop_bit port map(d=>inTemp, clk=>clk, enable=>enable, q=>oinTemp);
ALU: flipFlop_8bit port map(d=>ALUO, clk=>clk, enable=>enable, q=>oALUO);
FFRD: flipFlop_2bit port map(d=>rd, clk=>clk, enable=>enable, q=>ord);
IMME: flipFlop_8bit port map(d=>imm, clk=>clk, enable=>enable, q=>oimm);
C1: flipFlop_bit port map(d=>cs1, clk=>clk, enable=>enable, q=>ocs1);
C2: flipFlop_bit port map(d=>cs2, clk=>clk, enable=>enable, q=>ocs2);
C3: flipFlop_bit port map(d=>cs3, clk=>clk, enable=>enable, q=>ocs3);
C4: flipFlop_bit port map(d=>cs4, clk=>clk, enable=>enable, q=>ocs4);
C5: flipFlop_bit port map(d=>cs5, clk=>clk, enable=>enable, q=>ocs5);
C6: flipFlop_bit port map(d=>cs6, clk=>clk, enable=>enable, q=>ocs6);

end reg;
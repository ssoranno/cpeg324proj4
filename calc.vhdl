-- Steven Soranno and Evan DeAngelis
-- Main Calculator Entity

library ieee;
use ieee.std_logic_1164.all;

-- Main entity
entity calc is
	port (
		I: in std_logic_vector(7 downto 0); -- Input instruction vector
		clk: in std_logic -- Clock
	);
end calc;

architecture behav of calc is

-- Register File component
component regFile is
	port (
		r1 : in std_logic_vector(1 downto 0);
		r2 : in std_logic_vector(1 downto 0);
		rd : in std_logic_vector(1 downto 0);
		wb : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		enable : in std_logic;
		o1 : out std_logic_vector(7 downto 0);
		o2 : out std_logic_vector(7 downto 0)
	);
end component;

-- Instruction decode component
component inDecode is
	port(
		I  : in std_logic_vector(7 downto 0);
		ConSig : in std_logic;
		r1 : out std_logic_vector(1 downto 0);
		r2 : out std_logic_vector(1 downto 0);
		rd : out std_logic_vector(1 downto 0);
		imm : out std_logic_vector(3 downto 0)
	);
end component;

-- Sign extend conponent
component sign_extend is
	port(
		i : in std_logic_vector(3 downto 0);
		o: out std_logic_vector(7 downto 0)
	);
end component;

-- Print function component
component print is
	port(
		I : in std_logic_vector(7 downto 0);
		EN : in std_logic;
		clk: in std_logic
	);
end component;

-- ALU adder subtractor component
component add_sub is
	port(
		A:	in std_logic_vector (7 downto 0);
		B:	in std_logic_vector (7 downto 0);
		mode: in std_logic;
		flow: out std_logic;        
		S:	out std_logic_vector(7 downto 0));
end component;

-- Signal Controller component
component controller is
	port(
		i : in std_logic_vector(7 downto 0);
 		aluSkip: out STD_LOGIC;
 		print: out STD_LOGIC;
 		dispBEQ: out STD_LOGIC;
 		regwrite: out STD_LOGIC;
 		addsub: out STD_LOGIC;
 		load: out STD_LOGIC
	);
end component;

-- Shift register component that is used for skipping instructions
component shift_reg is
	port(
		I:	in std_logic_vector (3 downto 0); -- Input vector
		I_SHIFT_IN: in std_logic; -- Value to shift in
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; -- positive level triggering in problem 3
		enable:		in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0) -- ouput vector
	);
end component;

-- Declare signals
signal R1, R2, RD  : std_logic_vector(1 downto 0);
signal IMM, skipVal, inSkip, postskip, newIMM : std_logic_vector(3 downto 0);
signal ALUSKIP, PT, DISPBEQ, REGWRITE, ADDSUB, LOAD, f, skipControl, outskip, REnable, inTemp, printEnable, temp2, SRenable: std_logic;
signal O1, O2, ext, WB, sum, ALUO, p, LB : std_logic_vector(7 downto 0);

begin
-- Declare controller component portmap
-- This component outputs the all the controll signals used by the datapath
con: controller port map(i=>I, aluSkip=>ALUSKIP, print=>PT, dispBEQ=>DISPBEQ, regwrite=>REGWRITE, addsub=>ADDSUB, load=>LOAD);
-- Declare instruction decode portmap
-- The outputs from this component are used in the register file
ID: inDecode port map(I=> I, ConSig => DISPBEQ, r1=>R1, r2=>R2, rd=> RD, imm => IMM);
-- Declare sign extend port map
-- Ouputs the 8 bit value to write back register file
SE: sign_extend port map(i=>IMM, o=>ext);
-- Declare the output for the register file 
reg: regFile port map(r1=> R1, r2=> R2, rd=>RD, wb=>WB, clk=>REnable, enable=>REGWRITE, o1=>O1, o2=>O2);
-- Declare ALU port map
ALU: add_sub port map(A=>O1, B=>O2, mode=>ADDSUB, flow=>f, S=>sum);

-- ALU skip mux
ALUO<= sum when ALUSKIP='0' else
	O1 when ALUSKIP='1';

-- Print or Loop back demux based on the print control signal
p<= ALUO when PT='1';
LB<= ALUO when PT='0';

-- print function enable logic
printEnable<= PT and not inTemp;
	
-- print function port map
P1: print port map(I=>p, EN=>printEnable, clk=>clk);

-- Write back mux that determines is the wb value is the loop back value or the immediate
WB<= ext when LOAD='0' else
	LB when LOAD='1';

-- This mux determines if an instruction should be skipped
skipControl<= temp2 when DISPBEQ = '1' else
	'0' when DISPBEQ = '0';
	
-- This temporary signal shows whether the loopback signal is "00000000"
temp2 <= not(LB(0) or LB(1) or LB(2) or LB(3) or LB(4) or LB(5) or LB(6) or LB(7));

-- Shift the immiedaite value by 1 so that the compare skip logic works correctly
newIMM<= "0010" when IMM = "0001" else
	"0100" when IMM = "0010";

-- Skip value is the number of instructions to skip(should be 1 or a 2)
skipVal<= newIMM when skipControl = '1' else
	"0000" when skipControl = '0';

-- This mux determines what value goes into the shift register
inSkip<= skipVal when inTemp = '0' else
	postskip when inTemp = '1';

-- Shift register enable
SRenable<= inTemp or DISPBEQ;

-- Shift register port map
SR : shift_reg port map(I => inSkip, I_SHIFT_IN=> '0', sel => "10", clock=>clk, enable => SRenable, O=>postskip);

inTemp<= '0' when outskip = 'U' or outskip = '0' else
	'1' when outskip = '1';
outskip<=postskip(0) or postskip(1) or postskip(2) or postskip(3);

-- This mux detmerines the Write enable for the register file
REnable<= clk when inTemp='0' else
	'0' when inTemp='1';

end behav;
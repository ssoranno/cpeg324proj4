-- Steven Soranno and Evan DeAngelis
-- Main calculator test bench

library ieee;
use ieee.std_logic_1164.all;
use STD.Textio.all;

--  A testbench has no ports.
entity calc_tb is
end calc_tb;

architecture behav of calc_tb is
--  Declaration of the component that will be instantiated.
component calc
	port (
		I: in std_logic_vector(7 downto 0); -- Input instruction vector
		clk: in std_logic -- Clock
	);
end component;

-- Declare signals
signal i : std_logic_vector(7 downto 0);
signal clk: std_logic;

constant clk_period : time := 10 ns;

begin
--  Component instantiation.
c1: calc port map (i => I, clk => clk);

-- Clock process
clk_process : process
begin
	for i in 1 to 58 loop
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	end loop;
	wait;
end process;

-- This process does the real job.
process
begin
	-- Display 0 in all registers
	wait until rising_edge(clk);
	i<= "11000000";
	wait until rising_edge(clk);
	i<= "11000001";
	wait until rising_edge(clk);
	i<= "11000010";
	wait until rising_edge(clk);
	i<= "11000011";
	
	wait until rising_edge(clk); -- Load positive int 5 to register 0
	i<= "10000101";
	
	wait until rising_edge(clk); -- Display register 0
	i<= "11000000";
	
	-- Load negative int -3 to register 1
	wait until rising_edge(clk);
	i<= "10011101";
	
	-- Display register 1
	wait until rising_edge(clk);
	i<= "11000001";
	
	-- load 0 to register 2
	wait until rising_edge(clk);
	i<= "10100000";
	
	-- Display register 2
	wait until rising_edge(clk);
	i<= "11000010";
	
	-- load max positive 7 to register 3
	wait until rising_edge(clk);
	i<= "10110111";
	
	-- Display register 3
	wait until rising_edge(clk);
	i<= "11000011";
	
	-- load negative -8 to register 0
	wait until rising_edge(clk);
	i<= "10001000";
	
	-- Display register 0
	wait until rising_edge(clk);
	i<= "11000000";
	
	-- add negative and 0 (-3=-3+0)(t1=t2+t1)
	wait until rising_edge(clk);
	i<= "00011001";
	
	-- display register 1
	wait until rising_edge(clk);
	i<= "11000001";
	
	-- add positive and negative (4=7+(-3))(t2=t3+t1)
	wait until rising_edge(clk);
	i<= "00101101";
	
	-- Display register 2
	wait until rising_edge(clk);
	i<= "11000010";
	
	-- add positive and positive(11=7+4)(t3=t3+t2)
	wait until rising_edge(clk);
	i<= "00111110";
	
	-- Display register 3
	wait until rising_edge(clk);
	i<= "11000011";
	
	-- add two negatives(-11=-3+(-8))(t0=t1+t0)
	wait until rising_edge(clk);
	i<= "00000100";
	
	-- Display register 0
	wait until rising_edge(clk);
	i<= "11000000";
	
	-- Display add results of all registers
	wait until rising_edge(clk);
	i<= "11000000";
	wait until rising_edge(clk);
	i<= "11000001";
	wait until rising_edge(clk);
	i<= "11000010";
	wait until rising_edge(clk);
	i<= "11000011";
	
	-- subtract positive numbers (7=11-4) (t3=t3-t2)
	wait until rising_edge(clk);
	i<= "01111110";
	
	-- Display register 3
	wait until rising_edge(clk);
	i<= "11000011";
	
	-- subtract positive and negative number (-10=-3-7) (t1=t1-t3)
	wait until rising_edge(clk);
	i<= "01010111";
	
	-- Display register 1
	wait until rising_edge(clk);
	i<= "11000001";
	
	-- subtract 2 negative numbers (-1=-11-(-10)) (t0=t0-t1)
	wait until rising_edge(clk);
	i<= "01000001";
	
	-- Display register 0
	wait until rising_edge(clk);
	i<= "11000000";
	
	-- Load 0 into register 0
	wait until rising_edge(clk);
	i<= "10000000";
	
	-- subtract negative number and 0 (10=0-(-10)) (t1=t0-t1)
	wait until rising_edge(clk);
	i<= "01010001";
	
	-- Display register 1
	wait until rising_edge(clk);
	i<= "11000001";
	
	-- Display subtract results of all registers
	wait until rising_edge(clk);
	i<= "11000000";
	wait until rising_edge(clk);
	i<= "11000001";
	wait until rising_edge(clk);
	i<= "11000010";
	wait until rising_edge(clk);
	i<= "11000011";
	
	-- beq t0 and t1 testing false should move on to the next instruction
	wait until rising_edge(clk);
	i<= "11000101";
	-- Display register 0
	wait until rising_edge(clk);
	i<= "11000000";
	
	-- load 7 into t2
	wait until rising_edge(clk);
	i<= "10100111";
	
	-- beq two equal positives and skip 1 instruction (t2 t3)
	wait until rising_edge(clk);
	i<= "11101101";
	-- Display register 0 (This instruction is skipped)
	wait until rising_edge(clk);
	i<= "11000000";
	-- Display register 3
	wait until rising_edge(clk);
	i<= "11000011";
	
	-- beq 0 and other register continues to next instruction (t0 t1)
	wait until rising_edge(clk);
	i<= "11000101";
	-- Display register 0
	wait until rising_edge(clk);
	i<= "11000000";
	
	-- load -8 into t2
	wait until rising_edge(clk);
	i<= "10101000";
	
	-- beq positive and negative (t2, t3) continue to next instruction
	wait until rising_edge(clk);
	i<= "11101110";
	-- Display register 3
	wait until rising_edge(clk);
	i<= "11000011";
	
	-- load -8 into t3
	wait until rising_edge(clk);
	i<= "10111000";
	-- Display register 3
	wait until rising_edge(clk);
	i<= "11000011";
	-- Display register 2
	wait until rising_edge(clk);
	i<= "11000010";
	
	-- beq two equal negatives (t2,t3) and jump 2 instructions
	wait until rising_edge(clk);
	i<= "11101110";
	-- Display register 3 (This instruction is skipped)
	wait until rising_edge(clk);
	i<= "11000011";
	-- Display register 3 (This instruction is skipped)
	wait until rising_edge(clk);
	i<= "11000011";
	-- Display register 1 --> value in the register is 10
	wait until rising_edge(clk);
	i<= "11000001";
	wait;
	
end process;
end behav;
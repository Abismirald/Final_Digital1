library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2xN is
	generic(N: integer := 4); -- es de 4 bits
	port(
		I0: in std_logic_vector(N-1 downto 0);
		I1: in std_logic_vector(N-1 downto 0);
		S: in std_logic;
		X: out std_logic_vector(N-1 downto 0)
		);
end mux_2xN;

architecture mux_2xN_arq of mux_2xN is
	
	component mux_2x1 is
			
		port(
			I0: in std_logic;
			I1: in std_logic;
			S: in std_logic;
			X: out std_logic
			);
	end component;
	
begin
	N_mux: for i in 0 to N-1 generate --comparo bit a bit I0 con I1.
		mux_i: mux_2x1
			port map(
				I0=>I0(i),
				I1=>I1(i),
				S=> S,
				X=> X(i)
				);
	end generate;
end;

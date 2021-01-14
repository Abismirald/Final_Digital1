library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador_bin_33k is
	port(
		rst: in std_logic;
		clk: in std_logic;
		ena: in std_logic;
		flag: out std_logic
		);
end contador_bin_33k;
	

architecture contador_bin_33k_arq of contador_bin_33k is

	component contador_generic is
		generic(N: natural:= 4)
		Port( 
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			Q: out std_logic_vector(N-1 downto 0)
			);
	end component;
	
	component comparador_generico is
		generic(N: integer:= 2); -- bits a comparar
		Port(
			in_A: in std_logic_vector(N-1 downto 0);
			in_B: in std_logic_vector(N-1 downto 0);
			comp_out: out std_logic
			);
	end component;
	
	signal count: std_logic_vector(15 downto 0);
	signal comp_aux: std_logic;
	constant lim: std_logic_vector(15 downto 0) := "1000000011101000"; -- 33000	
	signal rst_gral: std_logic;
	
begin
	
	rst_gral<= rst OR comp_aux;
	
	comparador_inst: comparador_generico
		generic map(N=>16)
		port map(
			in_A=>count,
			in_B=>lim,
			comp_out=> comp_aux
			);
	
	contador_inst: contador_generic
		generic map(N=>16)
		port map(
			clk=>clk,
			rst=>rst_gral,
			ena=>ena,
			Q=>count
			);
	
	flag <= comp_aux;
end;

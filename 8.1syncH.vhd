library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity syncH is
	port(
		clk: in std_logic;
		rst: in std_logic;
		HCin: in std_logic_vector(9 downto 0);-- esto será la cuenta del contador horizontal
		pulse: out std_logic
		);
end;

architecture syncH_arq of syncH is

	component comparador_generico is
			generic(N: integer:= 2);--bits a comparar
			Port(
				in_A: in std_logic_vector(N-1 downto 0);
				in_B: in std_logic_vector(N-1 downto 0); 
				comp_out: out std_logic
				);
	end component;
	
	component ffd is
		port(
				clk, rst, ena: in std_logic;
				D: in std_logic;
				Q: out std_logic
			);
	end component;

	--Comparo una cuenta antes porque el ffd ve el cambio en el siguiente flanco
	constant lim_ena: std_logic_vector(9 downto 0):= "1010001111"; -- 655
	constant lim_rst: std_logic_vector(9 downto 0):= "1011101111"; -- 751
	signal comp_aux: std_logic_vector(1 downto 0);
	constant D_aux: std_logic:= '1';
	signal rstgral: std_logic;
	signal enagral: std_logic;
	
begin

	rstgral <= comp_aux(1) OR rst;
	enagral <= comp_aux(0);

	comp1: comparador_generico
		generic map(N=>10)
		port map(
			in_A=> HCin,
			in_B=> lim_ena, --655
			comp_out=> comp_aux(0)
			);
	
	comp2: comparador_generico
		generic map(N=>10)
		port map(
			in_A=> HCin,
			in_B=> lim_rst, --751
			comp_out=> comp_aux(1)
			);
	
	ffd_inst: ffd
		port map(
			clk=>clk,
			rst=>rstgral,
			ena=>enagral,
			D=>D_aux,
			Q=>pulse
			);

end;
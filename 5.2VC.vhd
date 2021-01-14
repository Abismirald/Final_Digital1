library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VC is
	port(
		rst: in std_logic;
		clk: in std_logic;
		ena: in std_logic;
		flag: out std_logic;
		cuenta: out std_logic_vector(9 downto 0)
		);
end;
-- El contador vertical tiene que contar hasta 520 (1000001000) o sea que voy a necesitar 10 bit

architecture VC_arq of VC is

	component contador_generic is
		generic(N: natural:= 4); --en la instanciación voy a usar 10
		Port( 
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			Q: out std_logic_vector(N-1 downto 0)
			);
	end component;
	
	component comparador_generico is
		generic(N: integer := 2); -- N sera la cantidad de bits de cada entrada (bits a comparar)
		Port(
			in_A: in std_logic_vector(N-1  downto 0);
			in_B: in std_logic_vector(N-1  downto 0); 
			comp_out: out std_logic
			);
	end component;
	
	signal rst_gral: std_logic;
	signal count: std_logic_vector(9 downto 0);
	constant lim: std_logic_vector(9 downto 0):= "1000001000"; --valor a comparar 520
	signal comp_aux: std_logic; --salida del comparador hacia el rst y hacia el flag

begin
	
	rst_gral <= rst OR comp_aux;
	cuenta <= count;
	flag <= comp_aux; -- este flag lo quiero para habilitar el registro
	
	contador_inst: contador_generic
		generic map(N=>10)
		port map(
			clk => clk,
			rst => rst_gral,
			ena => ena,
			Q => count
			);
	comparador_inst: comparador_generico
		generic map(N=>10)
		port map(
			in_A => count,
			in_B => lim,
			comp_out => comp_aux
			);
end;
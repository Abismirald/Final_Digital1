--Este componente reduce la frecuencia de 50MHz a 25Mhz
--Será un habilitador de los componentes
--consta de un contador binario y un comparador

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reductor_frec_spartan is 
	port(
		clk: in std_logic;
		ena: in std_logic;
		rst: in std_logic;
		clk_reduc: out std_logic
		);
end;

architecture reductor_frec_spartan_arq of reductor_frec_spartan is
	
	component contador_generic is
		generic (N:natural := 3);
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
			in_A, in_B: in std_logic_vector(N-1 downto 0);
			comp_out: out std_logic
			);
	end component;
	
	signal rst_gral: std_logic;
	signal count: std_logic_vector(1 downto 0);
	constant lim: std_logic_vector(1 downto 0):= "01";-- para la arty que tenia que dividir por 4 usaba: "11" es un vector por como esta definido el componente
	signal comp_aux: std_logic;
	
begin
	rst_gral <= rst OR (ena AND comp_aux);
	clk_reduc <= comp_aux;
	
	contador: contador_generic
		generic map(N=>2)
		port map(
			clk=> clk,
			rst=> rst_gral,
			ena=> ena,
			Q=> count
			);
	comparador: comparador_generico
		generic map(N=>2)
		port map(
			in_A=> count,
			in_B=> lim,
			comp_out=> comp_aux
			);
		
end;
-- este bloque tendrá los componentes:
-- Contador BCD de 5 digitos
-- Contador binario 33k
-- Registro
-- ffd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.utils.all;

entity ADC is 
	port(
		adc_in: in std_logic; --tension de entrada
		rst: in std_logic;
		clk: in std_logic;
		adc_out: out vector_vectors(2 downto 0) -- salida del registro
		);
end;

architecture ADC_arq of ADC is

	component ffd is
		port(
			clk, rst, ena: in std_logic;
			D: in std_logic;
			Q: out std_logic
			);
	end component;

	component contador_bcd_n is
	generic(N:integer := 5); 
		Port(
			rst: in std_logic; 
			clk: in std_logic; 
			ena: in std_logic;
			q: out vector_vectors(N-1 downto 0)
			);
	end component;
	
	component contador_bin_33k is
		port(
			rst: in std_logic;
			clk: in std_logic;
			ena: in std_logic;
			flag: out std_logic
			);
	end component;
	
	component registro is
		port(
			in_bcd: in vector_vectors(4 downto 0);
			ena: in std_logic; -- viene el flag del cont33k
			clk: in std_logic;
			rst: in std_logic;
			out_reg: out vector_vectors(2 downto 0)
			);
	end component;
	
	signal flag_aux: std_logic;
	signal out_bcd: vector_vectors(4 downto 0);
	signal rst_bcd:std_logic;
begin
	ffd1: ffd 
		port map(
			clk=>clk,
			rst=>rst,
			ena=>'1',
			D=>flag_aux,
			Q=>rst_bcd
			);
			
	counter33k: contador_bin_33k
		port map(
			rst=>rst,
			clk=>clk,
			ena=>'1',
			flag=>flag_aux
			);
	bcd: contador_bcd_n
		generic map(N=>5)
		port map(
			rst=>rst_bcd,
			clk=>clk,
			ena=>adc_in,
			q=>out_bcd
			);
	
	reg: registro
		port map(
			in_bcd=>out_bcd,
			ena=>flag_aux, 
			clk=>clk,
			rst=>rst,
			out_reg=>adc_out
			);
end;
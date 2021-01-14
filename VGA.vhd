-- Este bloque tiene los siguientes bloques:
-- CGA
-- Contador Horizontal
-- Contador Vertical
-- Hsync
-- Vsync
-- reductor de frecuencia

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.utils.all;

entity VGA is
	port(
		clk: in std_logic;
		rst: in std_logic;
		ADCin: in vector_vectors(2 downto 0);
		hsync_out: out std_logic;
		vsync_out: out std_logic;
		R: out std_logic;
		G: out std_logic;
		B: out std_logic
		);
end;

architecture VGA_arq of VGA is

	component CGA is
		port(
			ADCin: vector_vectors(2 downto 0);
			HCin: in std_logic_vector(9 downto 0);
			VCin: in std_logic_vector(9 downto 0);
			bit_to_print: out std_logic
			);
	end component;
	
	component HC is
		port(
			rst: in std_logic;
			clk: in std_logic;
			ena: in std_logic;
			flag: out std_logic;
			cuenta: out std_logic_vector(9 downto 0) 
			);
	end component;
	
	component VC is
		port(
			rst: in std_logic;
			clk: in std_logic;
			ena: in std_logic;
			flag: out std_logic;
			cuenta: out std_logic_vector(9 downto 0)
			);
	end component;
	
	component syncH is
		port(
			clk: in std_logic;
			rst: in std_logic;
			HCin: in std_logic_vector(9 downto 0);
			pulse: out std_logic
			);
	end component;
	
	component syncV is
		port(
			clk: in std_logic;
			rst: in std_logic;
			VCin: in std_logic_vector(9 downto 0);
			pulse: out std_logic
			);
	end component;
	
	component reductor_frec_spartan is 
		port(
			clk: in std_logic;
			ena: in std_logic;
			rst: in std_logic;
			clk_reduc: out std_logic
			);
	end component;
	
	component parte_visible is
		port(
			clk: in std_logic;
			rst: in std_logic;
			HCin: in std_logic_vector(9 downto 0);
			VCin: in std_logic_vector(9 downto 0);
			out_visible: out std_logic
			);
	end component;
	
	component registro_vga is 
		port(
			in_reg_adc: in vector_vectors(2 downto 0);
			ena: in std_logic; --Flag de VC indicando que esta fuera de la pantalla
			clk: in std_logic;
			rst: in std_logic;
			out_reg_vga: out vector_vectors(2 downto 0)
			);
	end component;
	
	signal hc_aux: std_logic_vector(9 downto 0);
	signal vc_aux: std_logic_vector(9 downto 0);
	signal flag_aux_H: std_logic;
	signal flag_aux_V: std_logic;
	signal clk_r: std_logic; --salida del reductor de frecuencia
	signal PV_aux: std_logic;
	signal G_aux: std_logic;
	signal reg_aux: vector_vectors(2 downto 0);
	signal ena_register: std_logic;
	
begin
	--RB a masa => fondo negro escrito en verde
	R<= '0';
	B<= '0';
	G<= G_aux AND PV_aux;
	
	registro: registro_vga
		port map(
			in_reg_adc=>ADCin,
			ena=>flag_aux_V,
			clk=>clk,
			rst=>rst,
			out_reg_vga=>reg_aux
			);
	
	PV: parte_visible
		port map(
			clk=> clk,
			rst=> rst,
			HCin=> hc_aux,
			VCin=> vc_aux,
			out_visible=> PV_aux
			);
	
	reductor_frecuencia: reductor_frec_spartan
		port map(
			clk=>clk,
			ena=>'1',
			rst=>rst,
			clk_reduc=>clk_r
			);
	
	cga_inst: CGA
		port map(
			ADCin=> reg_aux, 
			HCin=> hc_aux, 
			VCin=> vc_aux,
			bit_to_print=> G_aux
			);
	
	hcounter: HC
		port map(
			rst=> rst,
			clk=> clk,
			ena=> clk_r,
			flag=> flag_aux_H,
			cuenta=> hc_aux
			);
	
	vcounter: VC
		port map(
			ena=> flag_aux_H,
			clk=> clk,
			rst=> rst,
			flag=>flag_aux_V,
			cuenta=> vc_aux
			);
	
	SyH: syncH
		port map(
			clk=> clk,
			rst=> rst,
			HCin=> hc_aux,
			pulse=> hsync_out
			);
	
	SyV: syncV
		port map(
			clk=> clk,
			rst=> rst,
			VCin=> vc_aux,
			pulse=> vsync_out
			);
	
end;
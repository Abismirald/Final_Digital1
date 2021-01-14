--Este bloque tiene los siguientes componentes:
--ROM de caracteres
--Multiplexor de 5 entradas
--Comparador


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.utils.all;

entity CGA is
	port(
		ADCin: vector_vectors(2 downto 0);
		HCin: in std_logic_vector(9 downto 0);
		VCin: in std_logic_vector(9 downto 0);
		bit_to_print: out std_logic
		);
end;


architecture CGA_arq of CGA is

	component mux_vga is
		port(
			bcd_in: in vector_vectors(2 downto 0);
			S: in std_logic_vector(2 downto 0);
			X: out std_logic_vector(3 downto 0)
			);
	end component;
	
	component rom is
		port(
			cod_bcd: in std_logic_vector(3 downto 0);
			hc: in std_logic_vector(2 downto 0); -- bits 567
			vc: in std_logic_vector(2 downto 0); -- bits 567
			led: out std_logic		
			);
	end component;
    
	component comparador_generico is
        generic(N: integer:= 4); --bits a comparar
        Port (
            in_A, in_B: in std_logic_vector(N-1 downto 0); 
            comp_out: out std_logic
            );
    end component;
	
	signal mux_aux: std_logic_vector(3 downto 0);
	signal ROM_aux: std_logic;
	signal comp_aux: std_logic;
	
begin
	
	mux: mux_vga
		port map(
			bcd_in=> ADCin,
			S=> HCin(9 downto 7),
			X=> mux_aux
			);
	
	ROM_inst: rom
		port map(
			cod_bcd=> mux_aux,
			hc=> HCin(6 downto 4),
			vc=> VCin(6 downto 4),
			led=> ROM_aux
			);
	
	comp: comparador_generico
		generic map(N=>3)
		port map(
			in_A=> VCin(9 downto 7),
			in_B=> "001", -- segunda fila de la pantalla.
			comp_out=> comp_aux
			);
	
	bit_to_print <= ROM_aux AND comp_aux;
	
end;
--la particularidad de este registro es que toma el numero proveniente del registro del ADC 
--y se habilita cuando los contadores indican que estan fuera de la pantalla

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.utils.all;

entity registro_vga is 
	port(
		in_reg_adc: in vector_vectors(2 downto 0);
		ena: in std_logic;
		clk: in std_logic;
		rst: in std_logic;
		out_reg_vga: out vector_vectors(2 downto 0)
		);
end;

architecture registro_vga_arq of registro_vga is

	component ffd is
		port(
			clk, rst, ena: in std_logic;
			D: in std_logic;
			Q: out std_logic
			);
	end component;
	
	--entradas
	signal dig_reg_in_1: std_logic_vector(3 downto 0); 
	signal dig_reg_in_2: std_logic_vector(3 downto 0);
	signal dig_reg_in_3: std_logic_vector(3 downto 0); 
	
	--salidas
	signal dig_reg_out_1: std_logic_vector(3 downto 0);
	signal dig_reg_out_2: std_logic_vector(3 downto 0);
	signal dig_reg_out_3: std_logic_vector(3 downto 0);


begin
	
	--entradas
	dig_reg_in_1 <= in_reg_adc(0);
	dig_reg_in_2 <= in_reg_adc(1);
	dig_reg_in_3 <= in_reg_adc(2);
	
	--salidas
	out_reg_vga(0) <= dig_reg_out_1;
	out_reg_vga(1) <= dig_reg_out_2;
	out_reg_vga(2) <= dig_reg_out_3;
	
	reg1: for i in 0 to 3 generate
		digito1: ffd
			port map(
				clk=>clk,
				rst=>clk,
				ena=>ena,
				D=>dig_reg_in_1(i),
				Q=>dig_reg_out_1(i)
				);
	end generate;
	
	reg2: for i in 0 to 3 generate
		digito2: ffd
			port map(
				clk=>clk,
				rst=>clk,
				ena=>ena,
				D=>dig_reg_in_2(i),
				Q=>dig_reg_out_2(i)
				);
	end generate;
	
	reg3: for i in 0 to 3 generate
		digito3: ffd
			port map(
				clk=>clk,
				rst=>clk,
				ena=>ena,
				D=>dig_reg_in_3(i),
				Q=>dig_reg_out_3(i)
				);
	end generate;
	
end;
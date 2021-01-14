library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.utils.all;

entity registro is
	port(
		in_bcd: in vector_vectors(4 downto 0);
		ena: in std_logic; -- el enable será el flag del cont33k
		clk: in std_logic;
		rst: in std_logic;
		out_reg: out vector_vectors(2 downto 0)
		);
end;

architecture registro_arq of registro is

	component ffd is
		port(
			clk, rst, ena: in std_logic;
			D: in std_logic;
			Q: out std_logic
			);
	end component;
	
	--entradas
	signal dig_bcd_1: std_logic_vector(3 downto 0); 
	signal dig_bcd_2: std_logic_vector(3 downto 0);
	signal dig_bcd_3: std_logic_vector(3 downto 0); 
	
	--salidas
	signal dig_reg_1: std_logic_vector(3 downto 0);
	signal dig_reg_2: std_logic_vector(3 downto 0);
	signal dig_reg_3: std_logic_vector(3 downto 0); 
	
begin
		
	--entradas
	dig_bcd_1 <= in_bcd(2); -- los primeros 2 digitos del bcd no se usan
	dig_bcd_2 <= in_bcd(3);
	dig_bcd_3 <= in_bcd(4);
	
	--salidas
	out_reg(0) <= dig_reg_3;
	out_reg(1) <= dig_reg_2;
	out_reg(2) <= dig_reg_1;
		
	reg1: for i in 0 to 3 generate
		digito1: ffd
			port map(
				clk=>clk,
				rst=>rst,
				ena=>ena,
				D=>dig_bcd_1(i),
				Q=>dig_reg_1(i)
				);
	end generate;			
	
	reg2: for i in 0 to 3 generate
		digito2: ffd
			port map(
				clk=>clk,
				rst=>rst,
				ena=>ena,
				D=>dig_bcd_2(i),
				Q=>dig_reg_2(i)
				);
	end generate;			
	
	reg3: for i in 0 to 3 generate
		digito3:ffd
			port map(
				clk=>clk,
				rst=>rst,
				ena=>ena,
				D=>dig_bcd_3(i),
				Q=>dig_reg_3(i)
				);
	end generate;			

end;
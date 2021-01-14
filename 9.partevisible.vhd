library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parte_visible is
	port(
		clk: in std_logic;
		rst: in std_logic;
		HCin: in std_logic_vector(9 downto 0);
		VCin: in std_logic_vector(9 downto 0);
		out_visible: out std_logic
		);
end;

architecture parte_visible_arq of parte_visible is

	component comparador_generico is
			generic(N: integer:= 2); --bits a comparar
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
	
	signal comp_hor_aux: std_logic_vector(1 downto 0);
	signal comp_ver_aux: std_logic_vector(1 downto 0);
	signal visible_h, visible_v: std_logic;
	signal rst_hor, rst_ver: std_logic;
	
begin
	
	-- Parte visible horizontal 
	rst_hor <= rst OR comp_hor_aux(1);
	
	comp_hor_ena: comparador_generico
		generic map(N=>10)
		port map(
			in_A=> HCin,
			in_B=> "1001111111", -- 639
			comp_out=> comp_hor_aux(0)
			);
			
	comp_hor_rst: comparador_generico
		generic map(N=>10)
		port map(
			in_A=> HCin,
			in_B=> "1100011110", -- 798
			comp_out=> comp_hor_aux(1)
			);
			
	ffd_hor: ffd
		port map(
			clk=>clk,
			rst=>rst_hor,
			ena=>comp_hor_aux(0),
			D=>'1',
			Q=>visible_h
			);
	
	
	-- parte visible vertical
	
	rst_ver <= rst OR comp_ver_aux(1);
	
	comp_ver_ena: comparador_generico
		generic map(N=>10)
		port map(
			in_A=> VCin,
			in_B=> "0111011111", -- 479
			comp_out=> comp_ver_aux(0)
			);
	
	comp_ver_rst: comparador_generico
		generic map(N=>10)
		port map(
			in_A=> VCin,
			in_B=> "1000000111", -- 519
			comp_out=> comp_ver_aux(1)
			);
	
	ffd_inst: ffd
		port map(
			clk=>clk,
			rst=>rst_ver,
			ena=> comp_ver_aux(0),
			D=>'1',
			Q=>visible_v
			);
			
out_visible <= NOT(visible_h) AND NOT(visible_v);
		
end;
		

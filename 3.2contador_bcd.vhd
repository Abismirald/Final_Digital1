library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador_bcd is
	Port( 
        rst,clk,ena: in std_logic;
        salida: out std_logic_vector(3 downto 0);
        flag: out std_logic
		);
	end contador_bcd;

architecture contador_bcd_arq of contador_bcd is
   
    component comparador_generico is
        generic(N: integer:= 4);
        Port(
            in_A, in_B: in std_logic_vector(N-1 downto 0);
            comp_out: out std_logic
            );
    end component;

	component contador_generic is
		generic(N: natural:= 4);
		port(
			Q: out std_logic_vector(N-1 downto 0);
			clk, ena, rst: in std_logic
			);
	end component;
	
	
	signal count: std_logic_vector(3 downto 0);
	signal comp_aux, rst_gral: std_logic;
	constant lim: std_logic_vector(3 downto 0):= "1001";

begin
    
    rst_gral <= rst OR (comp_aux AND ena);
    salida <= count;
    flag <= comp_aux;
    
	generic_counter_inst: contador_generic
        generic map(N=>4)
        port map(
			rst=>rst_gral,
			clk=>clk,
			ena=>ena,
			Q=>count
			);
    
	generic_comp_inst: comparador_generico
        generic map(N=>4)
        port map(
            in_A=>count,
            in_B=>lim,
            comp_out=>comp_aux
			);
end;

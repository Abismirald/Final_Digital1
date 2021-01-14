library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador_generic is
  generic(N:natural:= 4);
  Port ( 
        clk: in std_logic;
        rst: in std_logic;
        ena: in std_logic;
        Q: out std_logic_vector(N-1 downto 0)
        );
end contador_generic;


architecture contador_generic_arq of contador_generic is

	component ffd is
		port(
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			D: in std_logic;
			Q: out std_logic
			);
	end component;

signal qaux, xor_aux, and_aux: std_logic_vector(N-1 downto 0); 

begin
    gen_counter: for i in 0 to N-1 generate
        --genero el primer bloque cuya entrada es diferente a las demas.
        gen_counter_1: if i=0 generate 
            and_aux(i) <= '1'; 
            xor_aux(i) <= and_aux(i) XOR qaux(i);
            inst1: ffd port map(clk, rst, ena, xor_aux(i), qaux(i));
        end generate;   
  
        gen_counter_inst_2_to_N: if i>0 generate
            and_aux(i) <= and_aux(i-1) AND qaux(i-1);
            xor_aux(i) <= and_aux(i) XOR qaux(i);
            inst2: ffd port map(clk, rst, ena, xor_aux(i), qaux(i));
        end generate;
    end generate;
    
	Q<= qaux;
	
end;

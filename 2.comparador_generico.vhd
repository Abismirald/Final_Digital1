library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador_generico is
  generic(N: integer := 2); --N sera la cantidad de bits a comparar
  Port (
        in_A, in_B: in std_logic_vector(N-1 downto 0); 
        comp_out: out std_logic
        );
end comparador_generico;

architecture comparador_generico_arq of comparador_generico is
	signal xnor_aux: std_logic_vector(N-1 downto 0); 
	signal and_aux: std_logic_vector(N downto 0); 

begin
        and_aux(0)<= '1';
        
		comp: for i in 0 to N-1 generate
            xnor_aux(i)<= in_A(i) XNOR in_B(i);
            and_aux(i+1)<= and_aux(i) AND xnor_aux(i);
        end generate;
         
        comp_out <= and_aux(N);--Como tengo i+1 cuando llegue a N-1 tendre N.
end;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2x1 is
		
	port(
		I0: in std_logic;
		I1: in std_logic;
		S: in std_logic;
		X: out std_logic
		);
end mux_2x1;

architecture mux_2x1_arq of mux_2x1 is

	begin

		X <= (I0 AND (NOT S)) OR (I1 AND S) OR (I0 AND I1); 

end;

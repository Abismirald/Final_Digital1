library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.utils.all;

entity mux_vga is
	port(
		bcd_in: in vector_vectors(2 downto 0);
		S: in std_logic_vector(2 downto 0);
		X: out std_logic_vector(3 downto 0)
		);
end;

architecture mux_vga_arq of mux_vga is
	
	signal out_mux: vector_vectors (2 downto 0);
	constant punto: std_logic_vector(3 downto 0):= "1010";
	constant v: std_logic_vector(3 downto 0):= "1011";
	signal I: vector_vectors(4 downto 0);
	
	component mux_2xN is
		generic(N: integer := 4); -- es de 4 bits
		port(
			I0: in std_logic_vector(N-1 downto 0);
			I1: in std_logic_vector(N-1 downto 0);
			S: in std_logic;
			X: out std_logic_vector(N-1 downto 0)
			);
	end component;
	
begin

	I(0) <= bcd_in(0);
	I(1) <= punto;
	I(2) <=	bcd_in(1);
	I(3) <= bcd_in(2);
	I(4) <= v;
	

	mux_1: mux_2xN
		generic map(N=>4) --pues los mux son de 4 bits
		port map(
				I0=>I(0),
				I1=>I(1),
				S=>S(0),
				X=>out_mux(0)
				);
	mux_2: mux_2xN
		generic map(N=>4) 
	    port map(
				I0=>I(2),
        		I1=>I(3),
        		S=>S(0),
        		X=>out_mux(1)
				);
	mux_3: mux_2xN
		generic map(N=>4) 		
		port map(		
				I0=>out_mux(0),		
				I1=>out_mux(1),		
				S=>S(1),		
				X=>out_mux(2)	
        		);
				
	mux_4: mux_2xN
		generic map(N=>4) 		
	    port map(		
	    		I0=>out_mux(2),
	    		I1=>I(4),
	    		S=>S(2),	
	    		X=>X	
	    		);	
end;
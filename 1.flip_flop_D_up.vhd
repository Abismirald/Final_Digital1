library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ffd is
	port(
		clk, rst, ena: in std_logic;
		D: in std_logic;
		Q: out std_logic
		);
end ffd;

architecture ffd_arq of ffd is

begin

	process(clk) --quiero que sea sincronico, por lo que tiene que variar solo por el clock
	-- entro a process si el argumento (clk) cambia
		begin
		if rising_edge(clk) then
			if rst = '1' then
				Q <= '0';
				elsif ena = '1' then
					Q <= D;
			end if;
		end if;
    end process;

end;




	

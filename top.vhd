
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.utils.all;

entity top is 
	port(
		clk: in std_logic;
		rst: in std_logic;
		data_volt_in_p: in std_logic;
		data_volt_in_n: in std_logic;
		data_volt_out: out std_logic;
		hs : out std_logic;
		vs : out std_logic;
		red_o : out std_logic;
		grn_o : out std_logic;
		blu_o : out std_logic
	);
	
	-- Mapeo de pines para el kit spartan 3E starter
	attribute loc: string;
	attribute slew: string;
	attribute drive: string;
	attribute iostandard: string;
	
	attribute loc of clk: signal is "C9";
	
	-- Entradas diferenciales
	attribute iostandard of data_volt_in_p: signal is "LVDS_25";	
	attribute loc of data_volt_in_p: signal is "A4";
	attribute iostandard of data_volt_in_n: signal is "LVDS_25";	
	attribute loc of data_volt_in_n: signal is "B4";

	-- Salida realimentada
	attribute loc of data_volt_out: signal is "C5";
	attribute slew of data_volt_out: signal is "FAST";
	attribute drive of data_volt_out: signal is "8";
	attribute iostandard of data_volt_out: signal is "LVCMOS25";
	
	-- VGA
	attribute loc of hs: signal is "F15";		-- HS
	attribute loc of vs: signal is "F14";		-- VS
	attribute loc of red_o: signal is "H14";	-- RED
	attribute loc of grn_o: signal is "H15";	-- GRN
	attribute loc of blu_o: signal is "G15";	-- BLUE
	
end;

architecture top_arq of top is

	component IBUFDS 
		port(
			I : in std_logic; 
			IB : in std_logic; 
			O : out std_logic
		); 
	end component;
	
	signal adc_out: vector_vectors(2 downto 0);

	signal Diff_Input, salFFD: std_logic;
	
begin
	
	ibuf0: IBUFDS
		port map(
			I => data_volt_in_p,
			IB => data_volt_in_n,
			O => Diff_Input
		);
	
	ffd_inst: entity work.ffd
		port map(
			clk => clk,
			rst => rst,
			ena => '1',
			D => Diff_Input,
			Q => salFFD
		);
	
	data_volt_out <= salFFD;
	
	ADC_inst: entity work.ADC
		port map(
			adc_in 	=> salFFD,
			rst    	=> rst,
			clk    	=> clk,
			adc_out => adc_out
		);

	VGA_int: entity work.VGA
		port map(
			clk			=> clk,
			rst			=> rst,
			ADCin			=> adc_out,
			hsync_out	=> hs,
			vsync_out	=> vs,
			R				=> red_o,
			G				=> grn_o,
			B				=> blu_o
		);

end;
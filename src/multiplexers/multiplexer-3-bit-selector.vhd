library ieee;
use ieee.std_logic_1164.all;

entity multiplexer_3_bit_selector is
    generic(n: natural);
    port(
        inp_0 : in std_logic_vector(n-1 downto 0);
        inp_1 : in std_logic_vector(n-1 downto 0);
        inp_2 : in std_logic_vector(n-1 downto 0);
        inp_3 : in std_logic_vector(n-1 downto 0);
        inp_4 : in std_logic_vector(n-1 downto 0);
        inp_5 : in std_logic_vector(n-1 downto 0);
        inp_6 : in std_logic_vector(n-1 downto 0);
        inp_7 : in std_logic_vector(n-1 downto 0);

        sel: in std_logic_vector(2 downto 0);
        dataout: out std_logic_vector(n-1 downto 0)
    );
end entity;


architecture bhv of multiplexer_3_bit_selector is
begin
process(inp_0,inp_1,inp_2,inp_3,inp_4,inp_5,inp_6,inp_7,sel) is
begin
if(sel = "000") then
	dataout <= inp_0;
elsif(sel = "001") then
	dataout <= inp_1;
elsif(sel = "010") then
	dataout <= inp_2;
elsif(sel = "011") then
	dataout <= inp_3;
elsif(sel = "100") then
	dataout <= inp_4;
elsif(sel = "101") then
	dataout <= inp_5;
elsif(sel = "110") then
	dataout <= inp_6;
elsif(sel = "111") then
	dataout <= inp_7;
end if;

end process;
end architecture bhv;

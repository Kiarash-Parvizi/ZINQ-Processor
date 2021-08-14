library ieee;
use ieee.std_logic_1164.all;

entity multiplexer_2_bit_selector is
    generic(n: natural);
    port(
        inp_0 : in std_logic_vector(n-1 downto 0);
        inp_1 : in std_logic_vector(n-1 downto 0);
        inp_2 : in std_logic_vector(n-1 downto 0);
        inp_3 : in std_logic_vector(n-1 downto 0);

        sel: in std_logic_vector(1 downto 0);
        dataout: out std_logic_vector(n-1 downto 0)
    );
end entity;


architecture bhv of multiplexer_2_bit_selector is
begin
process(inp_0,inp_1,inp_2,inp_3,sel) is
begin
if(sel = "00") then
	dataout <= inp_0;
elsif(sel = "01") then
	dataout <= inp_1;
elsif(sel = "10") then
	dataout <= inp_2;
elsif(sel = "11") then
	dataout <= inp_3;
end if;

end process;
end architecture bhv;

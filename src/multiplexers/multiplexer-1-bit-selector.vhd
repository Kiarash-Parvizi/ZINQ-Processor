library ieee;
use ieee.std_logic_1164.all;

entity multiplexer_1_bit_selector is
    generic(n: natural);
    port(
        inp_0 : in std_logic_vector(n-1 downto 0);
        inp_1 : in std_logic_vector(n-1 downto 0);

        sel: in std_logic;
        dataout: out std_logic_vector(n-1 downto 0)
    );
end entity;


architecture bhv of multiplexer_1_bit_selector is
begin
process(inp_0,inp_1,sel) is
begin
if(sel = '0') then
	dataout <= inp_0;
elsif(sel = '1') then
	dataout <= inp_1;
end if;

end process;
end architecture bhv;

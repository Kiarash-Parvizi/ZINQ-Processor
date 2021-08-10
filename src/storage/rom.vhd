library ieee ;
use ieee.std_logic_1164.all;

entity rom is
    port(
        address: in std_logic_vector(15 downto 0);
        data_out: out std_logic_vector(15 downto 0)
    );
end entity;

architecture structural of rom is
begin
    with address select data_out <=
        x"C238" when x"0000",
        x"EF89" when x"0002",
        x"FA37" when x"0004",
        x"0064" when x"0006",
        x"008B" when x"0008",
        x"6392" when x"000A",
        x"8CD6" when x"0028",
        x"C516" when x"002A",
        x"ABF1" when x"002C",
        x"2494" when x"002E",
        x"FB0D" when x"0030",
        x"DA3A" when x"0032",
        x"7FBB" when x"0034",
        x"7440" when x"4000",
        x"B7D5" when x"4002",
        x"5DED" when x"4074",
        x"05D4" when x"4076",
        x"16EB" when x"4082",
        x"0000" when others;
end architecture structural;

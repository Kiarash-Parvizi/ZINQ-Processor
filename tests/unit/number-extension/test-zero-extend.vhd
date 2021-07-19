library ieee;
use ieee.std_logic_1164.all;

entity test_zero_extend is
end entity;

architecture structural of test_zero_extend is
    component zero_extend is
        generic(
            src_len: natural;
            dest_len: natural
        );
        port(
            n: in std_logic_vector(src_len - 1 downto 0);
            result: out std_logic_vector(dest_len - 1 downto 0)
        );
    end component;

    constant len_1: natural := 4;
    constant len_2: natural := 8;
    constant len_3: natural := 3;

    signal in_1: std_logic_vector(len_1 - 1 downto 0) := x"2";
    signal out_2: std_logic_vector(len_2 - 1 downto 0) := x"9A";
    signal in_3, out_3: std_logic_vector(len_3 - 1 downto 0) := o"4";

    signal dummy: bit;
begin
    greater_len: zero_extend generic map(len_1, len_2) port map(in_1, out_2);
    equal_len: zero_extend generic map(len_3, len_3) port map(in_3, out_3);

    dummy <= '0' after 10 ns;
end architecture;

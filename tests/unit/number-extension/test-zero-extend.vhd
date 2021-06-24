library ieee;
use ieee.std_logic_1164.all;

entity test_zero_extend is
end entity;

architecture structural of test_zero_extend is
    component zero_extend is
        generic(
            src_bit_count: natural;
            dest_bit_count: natural
        );
        port(
            n: in std_logic_vector(src_bit_count - 1 downto 0);
            result: out std_logic_vector(dest_bit_count - 1 downto 0)
        );
    end component;

    -- bc: bit count
    constant bc_1: natural := 4;
    constant bc_2: natural := 8;
    constant bc_3: natural := 3;

    signal in_1: std_logic_vector(bc_1 - 1 downto 0) := x"2";
    signal out_2: std_logic_vector(bc_2 - 1 downto 0) := x"9A";
    signal in_3, out_3: std_logic_vector(bc_3 - 1 downto 0) := o"4";

    signal dummy: bit;
begin
    greater_bit_count: zero_extend generic map(bc_1, bc_2) port map(in_1, out_2);
    equal_bit_count: zero_extend generic map(bc_3, bc_3) port map(in_3, out_3);

    dummy <= '0' after 10 ns;
end architecture;

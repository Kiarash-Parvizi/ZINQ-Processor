library ieee;
use ieee.std_logic_1164.all;

entity test_shift_to_left_const is
end entity;

architecture structural of test_shift_to_left_const is
    component shift_to_left_const is
        generic(
            constant len: natural;
            constant shift_amount: natural := 1
        );
        port(
            num: in std_logic_vector(len - 1 downto 0);
            result: out std_logic_vector(len - 1 downto 0)
        );
    end component;

    constant len: natural := 4;

    signal val, result_1, result_2, result_4: std_logic_vector(len - 1 downto 0);

    signal dummy: bit;
begin
    val <= b"1111";

    instance_1: shift_to_left_const generic map(len, 1) port map(val, result_1);
    instance_2: shift_to_left_const generic map(len, 2) port map(val, result_2);
    instance_4: shift_to_left_const generic map(len, 4) port map(val, result_4);

    dummy <= '0' after 10 ns;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity test_shift_to_left is
end entity;

architecture structural of test_shift_to_left is
    component shift_to_left is
        generic(
            constant n: natural;
            constant shift_amount_len: natural
        );
        port(
            num: in std_logic_vector(n - 1 downto 0);
            shift_amount: in std_logic_vector(shift_amount_len - 1 downto 0);
            result: out std_logic_vector(n - 1 downto 0)
        );
    end component;

    constant n: natural := 5;
    constant num: std_logic_vector(n - 1 downto 0) := b"00101";

    signal result_1, result_2, result_3: std_logic_vector(n - 1 downto 0);

    signal dummy: bit;
begin
    instance_1: shift_to_left generic map(n, 3) port map(
        num, b"010", result_1
    );
    instance_2: shift_to_left generic map(n, 3) port map(
        num, b"111", result_2
    );
    instance_3: shift_to_left generic map(n, 2) port map(
        num, b"11", result_3
    );

    dummy <= '0' after 10 ns;
end architecture;

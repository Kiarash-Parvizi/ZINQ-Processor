library ieee;
use ieee.std_logic_1164.all;

entity multiplier_n_bit is
    generic(
        constant n: natural
    );
    port(
        a, b: in std_logic_vector(n - 1 downto 0);
        result: out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture structural of multiplier_n_bit is
    component partial_multiplier_n_bit is
        generic(
            constant n: natural;
            constant bit_value: integer
        );
        port(
            prev_sum, a: in std_logic_vector(n - 1 downto 0);
            multiplier_bit: in std_logic;
            result: out std_logic_vector(n - 1 downto 0)
        );
    end component;

    type std_logic_vector_2d is array(n - 2 downto 0) of std_logic_vector(n - 1 downto 0);
    signal prev_sums: std_logic_vector_2d;
begin
    prev_sums(0) <= a when b(0) = '1' else (others => '0');

    l_parial_multiplication_genarator:
    for i in 1 to n - 2 generate
        partial_multiplication: partial_multiplier_n_bit generic map(n, i) port map(
            prev_sums(i - 1), a, b(i), prev_sums(i)
        );
    end generate;

    final_partial_multiplication: partial_multiplier_n_bit generic map(n, n - 1) port map(
        prev_sums(n - 2), a, b(n - 1), result
    );
end architecture;

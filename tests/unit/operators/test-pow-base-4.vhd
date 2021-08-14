library ieee;
use ieee.std_logic_1164.all;

entity test_pow_base_4 is
end entity;

architecture structural of test_pow_base_4 is
    component pow_base_4 is
        generic(
            constant n: natural;
            constant exponent_len: natural
        );
        port(
            exponent: in std_logic_vector(exponent_len - 1 downto 0);
            result: out std_logic_vector(n - 1 downto 0)
        );
    end component;

    constant n: natural := 12;
    constant exponent_len: natural := 2;

    signal result: std_logic_vector(n - 1 downto 0);

    signal dummy: bit;
begin
    instance: pow_base_4 generic map(n, exponent_len) port map(
        b"11", result
    );

    dummy <= '0' after 10 ns;
end architecture;

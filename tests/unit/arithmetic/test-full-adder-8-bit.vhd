library ieee;
use ieee.std_logic_1164.all;

entity test_full_adder_8_bit is
end entity;

architecture structural of test_full_adder_8_bit is
    component full_adder_n_bit is
        generic(
            constant n: natural
        );
        port(
            a, b: in std_logic_vector(n - 1 downto 0);
            cin: in std_logic := '0';

            sum: out std_logic_vector(n - 1 downto 0);
            cout: out std_logic
        );
    end component;

    constant n: integer := 8;

    signal x, y, result: std_logic_vector(n - 1 downto 0);
begin
    instance: full_adder_n_bit generic map(n) port map(
        x, y, '0', result
    );

    x <= x"06",
        x"32" after 10 ns,
        x"00" after 20 ns;

    y <= x"14",
        x"53" after 10 ns,
        x"00" after 20 ns;
end architecture;

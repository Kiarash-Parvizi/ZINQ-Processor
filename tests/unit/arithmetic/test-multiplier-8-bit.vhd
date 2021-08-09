library ieee;
use ieee.std_logic_1164.all;

entity test_multiplier_8_bit is
end entity;

architecture structural of test_multiplier_8_bit is
    component multiplier_n_bit is
        generic(
            constant n: natural
        );
        port(
            a, b: in std_logic_vector(n - 1 downto 0);
            result: out std_logic_vector(n - 1 downto 0)
        );
    end component;

    constant n: integer := 8;

    signal x, y, result: std_logic_vector(n - 1 downto 0);
begin
    instance: multiplier_n_bit generic map(n) port map(x, y, result);

    x <= x"00",
        x"03" after 10 ns,
        x"05" after 20 ns,
        x"61" after 30 ns,
        x"06" after 40 ns,
        x"00" after 50 ns;

    y <= x"34",
        x"20" after 10 ns,
        x"0A" after 20 ns,
        x"03" after 30 ns,
        x"27" after 40 ns,
        x"00" after 50 ns;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity full_adder_n_bit is
    generic(
        constant n: natural
    );
    port(
        a, b: in std_logic_vector(n - 1 downto 0);
        cin: in std_logic := '0';

        sum: out std_logic_vector(n - 1 downto 0);
        cout: out std_logic
    );
end entity;

architecture structural of full_adder_n_bit is
    component full_adder_1_bit is
        port(
            a, b: in std_logic;
            cin: in std_logic;

            sum: out std_logic;
            cout: out std_logic
        );
    end component;

    signal carry: std_logic_vector(n - 2 downto 0);
begin
    l_bit_wise_adders:
    for i in 0 to n - 1 generate
        l_adder_one_bit_first:
        if i = 0 generate
            adder_first: full_adder_1_bit port map(
                a(i), b(i), cin, sum(i), carry(i)
            );
        end generate;

        l_adders_one_bit_middle:
        if (i /= n - 1) and (i /= 0) generate
            adder_middle: full_adder_1_bit port map(
                a(i), b(i), carry(i - 1), sum(i), carry(i)
            );
        end generate;

        l_adder_one_bit_last:
        if i = n - 1 generate
            adder_last: full_adder_1_bit port map(
                a(i), b(i), carry(i - 1), sum(i), cout
            );
        end generate;
    end generate;
end architecture;

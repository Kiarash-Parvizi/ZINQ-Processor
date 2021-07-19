library ieee;
use ieee.std_logic_1164.all;

entity partial_multiplier_n_bit is
    generic(
        constant n: natural;
        -- The value (i.e. position) of the bit that gets multiplied (i.e. multiplier_bit below)
        constant bit_value: integer
    );
    port(
        prev_sum, a: in std_logic_vector(n - 1 downto 0);
        multiplier_bit: in std_logic;

        result: out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture structural of partial_multiplier_n_bit is
    component shift_to_left is
        generic(
            constant len: natural;
            constant shift_amount: natural := 1
        );
        port(
            num: in std_logic_vector(len - 1 downto 0);
            result: out std_logic_vector(len - 1 downto 0)
        );
    end component;

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

    signal shifted_a, sum_2nd_operand: std_logic_vector(n - 1 downto 0);
begin
    l_not_to_shift:
    if bit_value = 0 generate
        shifted_a <= a;
    end generate;

    -- Here, for compatibility reasons, we cannot use else generate
    l_to_shift:
    if bit_value /= 0 generate
        left_shifting: shift_to_left generic map(n, bit_value) port map(a, shifted_a);
    end generate;

    sum_2nd_operand <= shifted_a when multiplier_bit = '1' else (others => '0');

    adder: full_adder_n_bit generic map(n) port map(
        prev_sum, sum_2nd_operand, '0', result, open
    );
end architecture;

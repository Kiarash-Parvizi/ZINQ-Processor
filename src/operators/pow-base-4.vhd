library ieee;
use ieee.std_logic_1164.all;

-- Do a 4 ^ x (i.e. 4 ** x) operation
entity pow_base_4 is
    generic(
        constant n: natural;
        constant exponent_len: natural
    );
    port(
        exponent: in std_logic_vector(exponent_len - 1 downto 0);
        result: out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture structural of pow_base_4 is
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

    -- Prepend a bit to ensure we don't loose its value by shifting
    signal exponent_extended: std_logic_vector(exponent_len downto 0) := (others => '0');

    signal shifted_exponent: std_logic_vector(exponent_len downto 0);
    signal one_n_bit: std_logic_vector(n - 1 downto 0) := (others => '0');
begin
    one_n_bit(0) <= '1';
    exponent_extended(exponent_len - 1 downto 0) <= exponent;

    -- 4 ^ x == 1 << (x << 1)
    -- x === exponent
    shift_amount_calc: shift_to_left_const generic map(exponent_len + 1, 1) port map(
        exponent_extended, shifted_exponent
    );

    result_calc: shift_to_left generic map(n, exponent_len + 1) port map(
        one_n_bit, shifted_exponent, result
    );
end architecture;

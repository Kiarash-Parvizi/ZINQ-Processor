library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity shift_to_left is
    generic(
        constant n: natural;
        constant shift_amount_len: natural
    );
    port(
        num: in std_logic_vector(n - 1 downto 0);
        shift_amount: in std_logic_vector(shift_amount_len - 1 downto 0);
        result: out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture structural of shift_to_left is
    component multiplexer_n_to_1 is
        generic(
            constant inout_len: natural;
            constant inputs_count: natural
        );
        port(
            inputs_concat: in std_logic_vector(inputs_count * inout_len - 1 downto 0);
            -- If the multiplexer is n-bit, and n = 2^m, this long expression is m
            selector: in std_logic_vector(natural(ceil(log2(real(inputs_count)))) - 1 downto 0);
            result: out std_logic_vector(inout_len - 1 downto 0)
        );
    end component;

    function min(a, b: natural) return natural is
    begin
        if a < b then
            return(a);
        else
            return (b);
        end if;
    end function;

    constant possible_shifts_count: natural := 2 ** shift_amount_len;

    -- Zero right-extend number to its double size. Then, we can select an n-bit out of it based on
    -- the shift amount using a multiplexer. Also, we zeroize the inputs of the multiplexer to
    -- ensure if shifting happens more than the length of the number, nothing bad happens.
    signal num_extended: std_logic_vector(2 * n - 1 downto 0) := (others => '0');
    signal mux_inputs_concat: std_logic_vector(0 to possible_shifts_count * n - 1)
        := (others => '0');
begin
    num_extended(2 * n - 1 downto n) <= num;

    l_initialize_mux_input:
    for i in 0 to min(n, possible_shifts_count) - 1 generate
        mux_inputs_concat(i * n to (i + 1) * n - 1) <=
            num_extended(2 * n - i - 1 downto n - i);
    end generate;

    mux: multiplexer_n_to_1 generic map(n, possible_shifts_count) port map(
        mux_inputs_concat, shift_amount, result
    );
end architecture;

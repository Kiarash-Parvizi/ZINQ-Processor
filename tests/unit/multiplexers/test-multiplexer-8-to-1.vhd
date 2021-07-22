library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.types.std_logic_vector_array;

entity test_multiplexer_8_to_1 is
end entity;

architecture structural of test_multiplexer_8_to_1 is
    component multiplexer_n_to_1 is
        generic(
            constant inout_len: natural;
            constant inputs_count: natural;
            constant selector_len: natural := natural(ceil(log2(real(inputs_count))))
        );
        port(
            inputs: in std_logic_vector_array(inputs_count - 1 downto 0)(inout_len - 1 downto 0);
            selector: in std_logic_vector(selector_len - 1 downto 0);
            result: out std_logic_vector(inout_len - 1 downto 0)
        );
    end component;

    constant inout_len: natural := 3;
    constant inputs_count_pow_of_2: natural := 8;
    constant inputs_count_not_pow_of_2: natural := 6;

    signal result_pow_of_2: std_logic_vector(inout_len - 1 downto 0);
    signal result_not_pow_of_2: std_logic_vector(inout_len - 1 downto 0);

    signal dummy: bit;
begin
    instance_pow_of_2: multiplexer_n_to_1 generic map(
        inout_len, inputs_count_pow_of_2
    ) port map(
        (b"111", b"110", b"101", b"100", b"011", b"010", b"001", b"000"), b"010", result_pow_of_2
    );

    instance_not_pow_of_2: multiplexer_n_to_1 generic map(
        inout_len, inputs_count_not_pow_of_2
    ) port map(
        (b"111", b"110", b"101", b"100", b"011", b"010"), b"001", result_not_pow_of_2
    );

    dummy <= '0' after 10 ns;
end architecture;

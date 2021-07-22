library ieee;
use ieee.std_logic_1164.all;
use work.types.std_logic_vector_array;

entity test_multiplexer_2_to_1 is
end entity;

architecture structural of test_multiplexer_2_to_1 is
    component multiplexer_2_to_1 is
        generic(
            constant inout_len: natural
        );
        port(
            inputs: in std_logic_vector_array(2 - 1 downto 0)(inout_len - 1 downto 0);
            selector: in std_logic;
            result: out std_logic_vector(inout_len - 1 downto 0)
        );
    end component;

    constant inout_len: natural := 4;

    signal result: std_logic_vector_array(2 - 1 downto 0)(inout_len - 1 downto 0);

    signal dummy: bit;
begin
    instance_selector_0: multiplexer_2_to_1 generic map(inout_len) port map(
        (b"1100", b"0001"), '0', result(0)
    );
    instance_selector_1: multiplexer_2_to_1 generic map(inout_len) port map(
        (b"0010", b"0011"), '1', result(1)
    );

    dummy <= '0' after 10 ns;
end architecture;

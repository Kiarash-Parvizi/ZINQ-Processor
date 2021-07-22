library ieee;
use ieee.std_logic_1164.all;

entity test_multiplexer_2_to_1 is
end entity;

architecture structural of test_multiplexer_2_to_1 is
    component multiplexer_2_to_1 is
        generic(
            constant inout_len: natural
        );
        port(
            inputs_concat: in std_logic_vector(2 * inout_len - 1 downto 0);
            selector: in std_logic;
            result: out std_logic_vector(inout_len - 1 downto 0)
        );
    end component;

    constant inout_len: natural := 4;

    signal result_0, result_1: std_logic_vector(inout_len - 1 downto 0);

    signal dummy: bit;
begin
    -- Using two writing formats to indicate both are possible and error-free
    instance_selector_0: multiplexer_2_to_1 generic map(inout_len) port map(
        (b"1100", b"0001"), '0', result_0
    );
    instance_selector_1: multiplexer_2_to_1 generic map(inout_len) port map(
        b"0010" & b"0011", '1', result_1
    );

    dummy <= '0' after 10 ns;
end architecture;

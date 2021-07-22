library ieee;
use ieee.std_logic_1164.all;
use work.types.std_logic_vector_array;

entity multiplexer_2_to_1 is
    generic(
        constant inout_len: natural
    );
    port(
        inputs: in std_logic_vector_array(2 - 1 downto 0)(inout_len - 1 downto 0);
        selector: in std_logic;
        result: out std_logic_vector(inout_len - 1 downto 0)
    );
end entity;

architecture structural of multiplexer_2_to_1 is
    signal selector_extended: std_logic_vector(inout_len - 1 downto 0) := (others => selector);
begin
    result <=
        (inputs(0) and not selector_extended) or
        (inputs(1) and selector_extended);
end architecture;

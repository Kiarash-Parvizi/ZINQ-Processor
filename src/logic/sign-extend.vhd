library ieee;
use ieee.std_logic_1164.all;

entity sign_extend is
    generic(
        src_bit_count: natural;
        dest_bit_count: natural
    );
    port(
        n: in std_logic_vector(src_bit_count - 1 downto 0);
        result: out std_logic_vector(dest_bit_count - 1 downto 0)
    );
end entity;

architecture structural of sign_extend is
    signal buff: std_logic_vector(dest_bit_count - 1 downto 0);
begin
    assert src_bit_count <= dest_bit_count report
        "Source must not be greater than destination in size" severity error;

    l_validate_bit_counts:
    if src_bit_count <= dest_bit_count generate
        buff(src_bit_count - 1 downto 0) <= n;
        buff(dest_bit_count - 1 downto src_bit_count) <= (others => n(src_bit_count - 1));
    end generate;

    result <= buff;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity zero_extend is
    generic(
        src_len: natural;
        dest_len: natural
    );
    port(
        n: in std_logic_vector(src_len - 1 downto 0);
        result: out std_logic_vector(dest_len - 1 downto 0)
    );
end entity;

architecture structural of zero_extend is
    signal buff: std_logic_vector(dest_len - 1 downto 0);
begin
    assert src_len <= dest_len report
        "Source must not be greater than destination in size" severity error;

    l_validate_lens:
    if src_len <= dest_len generate
        buff(src_len - 1 downto 0) <= n;
        buff(dest_len - 1 downto src_len) <= (others => '0');
    end generate;

    result <= buff;
end architecture;

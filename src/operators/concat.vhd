library ieee;
use ieee.std_logic_1164.all;

entity concat is
    generic(
        -- {R,L}HS: {Right,Left} Hand Side
        lhs_len: natural;
        rhs_len: natural
    );
    port(
        lhs: in std_logic_vector(lhs_len - 1 downto 0);
        rhs: in std_logic_vector(rhs_len - 1 downto 0);
        result: out std_logic_vector(lhs_len + rhs_len - 1 downto 0)
    );
end entity;

architecture structural of concat is
begin
    result <= lhs & rhs;
end architecture;

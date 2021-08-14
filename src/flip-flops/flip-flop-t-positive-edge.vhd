library ieee;
use ieee.std_logic_1164.all;

entity flip_flop_t_positive_edge is
    port(
        t, clock: in std_logic;
        clear: in std_logic := '0';
        q: buffer std_logic := '0';
        q_not: buffer std_logic := '1'
    );
end entity;

architecture behavioral of flip_flop_t_positive_edge is
begin
    process(clear, clock)
    begin
        if clear = '1' then
            q <= '0';
            q_not <= '1';
        elsif rising_edge(clock) and t = '1' then
            q <= q_not;
            q_not <= q;
        end if;
    end process;
end architecture;

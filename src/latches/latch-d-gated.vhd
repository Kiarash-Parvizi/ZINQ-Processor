library ieee;
use ieee.std_logic_1164.all;

entity latch_d_gated is
    port(
        d, clock: in std_logic;

        q: out std_logic := '0';
        q_not: out std_logic := '1'
    );
end entity;

architecture structural of latch_d_gated is
begin
    q <= d when clock = '1';
    q_not <= not d when clock = '1';
end architecture;

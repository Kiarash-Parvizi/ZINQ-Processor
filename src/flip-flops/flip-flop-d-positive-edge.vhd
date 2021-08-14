library ieee;
use ieee.std_logic_1164.all;

-- Positive-edge-triggered D flip-flop
entity flip_flop_d_positive_edge is
    port(
        d, clock: in std_logic;
        q, q_not: out std_logic
    );
end entity;

architecture structural_master_slave of flip_flop_d_positive_edge is
    component latch_d_gated is
        port(
            d, clock: in std_logic;
            q, q_not: out std_logic
        );
    end component;

    signal q_master: std_logic;
    signal clock_not: std_logic;
begin
    clock_not <= not clock;

    latch_master: latch_d_gated port map(d, clock_not, q_master, open);
    latch_slave: latch_d_gated port map(q_master, clock, q, q_not);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use work.types.time_array;

entity test_flip_flop_d_all is
end entity;

architecture structural of test_flip_flop_d_all is
    component flip_flop_d_negative_edge is
        port(
            d, clock: in std_logic;
            q, q_not: out std_logic
        );
    end component;

    component flip_flop_d_positive_edge is
        port(
            d, clock: in std_logic;
            q, q_not: out std_logic
        );
    end component;

    component clock_generator is
        generic(
            constant cycle_iterations: integer := 0;
            constant half_cycle_period: time := 10 ns
        );
        port(
            clock: out std_logic
        );
    end component;

    component switching_signal_generator is
        generic(
            constant switch_timing: time_array
        );
        port(
            result: buffer std_logic;
            initial_value: in std_logic := '0'
        );
    end component;

    constant data_switch_timing: time_array := (
        9 ns, 18 ns, 26 ns, 34 ns, 51 ns, 53 ns, 62 ns, 72 ns, 73 ns, 74 ns, 79 ns, 89 ns,
        96 ns
    );

    signal data, clock, q_falling, q_rising, q_not_falling, q_not_rising: std_logic;
begin
    flip_flop_d_negative_edge_instance: flip_flop_d_negative_edge port map(
        data, clock, q_falling, q_not_falling
    );
    flip_flop_d_positive_edge_instance: flip_flop_d_positive_edge port map(
        data, clock, q_rising, q_not_rising
    );

    clock_generator_instance: clock_generator generic map(10, 5 ns) port map(clock);
    data_generator_instance: switching_signal_generator generic map(data_switch_timing)
        port map(data);
end architecture;

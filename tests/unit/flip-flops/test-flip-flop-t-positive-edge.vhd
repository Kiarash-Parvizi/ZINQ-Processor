library ieee;
use ieee.std_logic_1164.all;
use work.types.time_array;

entity test_flip_flop_t_positive_edge is
end entity;

architecture structural of test_flip_flop_t_positive_edge is
    component flip_flop_t_positive_edge is
        port(
            t, clock: in std_logic;
            clear: in std_logic := '0';
            q: buffer std_logic := '0';
            q_not: buffer std_logic := '1'
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
        4 ns, 16 ns, 34 ns, 49 ns, 49 ns, 52 ns, 66 ns, 83 ns, 83 ns, 86 ns, 89 ns
    );
    constant clear_switch_timing: time_array := (
        18 ns, 21 ns, 26 ns, 27 ns, 39 ns, 40 ns, 71 ns, 72 ns, 87 ns, 89 ns
    );

    signal data, clock, q, q_not, clear: std_logic;
begin
    instance: flip_flop_t_positive_edge port map(data, clock, clear, q, q_not);

    clock_generator_instance: clock_generator generic map(10, 5 ns) port map(clock);

    data_generator_instance: switching_signal_generator generic map(data_switch_timing)
        port map(data);
    clear_generator_instance: switching_signal_generator generic map(clear_switch_timing)
        port map(clear);
end architecture;

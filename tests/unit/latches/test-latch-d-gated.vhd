library ieee;
use ieee.std_logic_1164.all;
use work.types.time_array;

entity test_latch_d_gated is
end entity;

architecture structural of test_latch_d_gated is
    component latch_d_gated is
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
        4 ns, 11 ns, 16 ns, 26 ns, 28 ns, 31 ns, 34 ns, 35 ns, 40 ns, 50 ns, 53 ns, 59 ns
    );

    signal data, clock, q, q_not: std_logic;
begin
    instance: latch_d_gated port map(data, clock, q, q_not);

    clock_generator_instance: clock_generator generic map(10, 3 ns) port map(clock);
    data_generator_instance: switching_signal_generator generic map(data_switch_timing)
        port map(data);
end architecture;

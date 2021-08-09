library ieee;
use ieee.std_logic_1164.all;

entity test_clock_generator_limited is
end entity;

architecture structural of test_clock_generator_limited is
    component clock_generator is
        generic(
            constant cycle_iterations: integer := 0;
            constant half_cycle_period: time := 10 ns
        );
        port(
            clock: out std_logic
        );
    end component;

    signal clock: std_logic;
begin
    instance: clock_generator generic map(10, 5 ns) port map(clock => clock);
end architecture;

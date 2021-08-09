library ieee;
use ieee.std_logic_1164.all;

entity test_clock_generator_unlimited is
end entity;

architecture structural of test_clock_generator_unlimited is
    component clock_generator is
        generic(
            constant cycle_iterations: integer := 0;
            constant half_cycle_period: time := 1 ns
        );
        port(
            clock: out std_logic
        );
    end component;

    signal clock: std_logic;
begin
    uut: clock_generator port map(clock => clock);
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity clock_generator is
    generic(
        -- How many cycles to generate
        constant cycle_iterations: integer := 0;

        -- The period of half a cycle
        constant half_cycle_period: time := 10 ns
    );
    port(
        clock: out std_logic := '0'
    );
end entity;

architecture structural of clock_generator is
    signal clock_tmp: std_logic := '0';
begin
    l_unlimited_iterations:
    if cycle_iterations <= 0 generate
        -- Clock forever
        clock_tmp <=
            '0' after half_cycle_period when clock_tmp = '1' else
            '1' after half_cycle_period when clock_tmp = '0';
    end generate;

    l_limited_iterations:
    if cycle_iterations > 0 generate
        process is
        begin
            for i in 1 to cycle_iterations loop
                clock_tmp <= '0';
                wait for half_cycle_period;
                clock_tmp <= '1';
                wait for half_cycle_period;
            end loop;
            wait;
        end process;
    end generate;

    clock <= clock_tmp;
end architecture;

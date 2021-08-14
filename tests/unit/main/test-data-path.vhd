library ieee;
use ieee.std_logic_1164.all;

entity test_data_path is
end entity;

architecture structural of test_data_path is
    -- data_path
    component data_path is
        port(
            clk: in std_logic
        );
    end component;
    -- clock_generator
    component clock_generator is
        generic(
            constant cycle_iterations: integer := 0;
            constant half_cycle_period: time := 10 ns
        );
        port(
            clock: out std_logic
        );
    end component;
    ----------------------------
    -- signals:
    signal clock: std_logic;
begin
    clk_gen: clock_generator
        generic map(20)
        port map(clock);
    instance: data_path
        port map(clock);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use work.types.time_array;

entity test_switching_signal_generator is
end entity;

architecture structural of test_switching_signal_generator is
    component switching_signal_generator is
        generic(
            constant switch_timing: time_array
        );
        port(
            result: buffer std_logic;
            initial_value: in std_logic := '0'
        );
    end component;

    signal results: std_logic_vector(0 to 1);
    constant initial_values: std_logic_vector(0 to 1) := ('0', '1');
begin
    l_initial_value_generator:
    for i in initial_values'range generate
        instance: switching_signal_generator generic map(
            (7 ns, 9 ns, 16 ns, 22 ns, 28 ns, 31 ns, 41 ns, 52 ns, 56 ns, 62 ns, 64 ns,
            75 ns, 82 ns, 90 ns, 94 ns, 97 ns, 102 ns)
        ) port map (results(i), initial_values(i));
    end generate;
end architecture;

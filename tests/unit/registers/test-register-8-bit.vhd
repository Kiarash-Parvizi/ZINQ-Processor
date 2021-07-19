library ieee;
use ieee.std_logic_1164.all;
use work.types.time_array;

entity test_register_8_bit is
end entity;

architecture structural of test_register_8_bit is
    component register_n_bit is
        generic(
            constant n: integer
        );
        port(
            data: in std_logic_vector(n - 1 downto 0);
            clock: in std_logic;
            result: out std_logic_vector(n - 1 downto 0);
            reset: in std_logic := '0';
            enable: in std_logic := '1'
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

    constant n: integer := 8;

    signal in_data, out_data: std_logic_vector(n - 1 downto 0);
    signal clock, enable, reset: std_logic;

    constant enable_states: time_array := (
        6 ns, 17 ns, 19 ns, 26 ns, 27 ns, 34 ns, 46 ns, 53 ns, 61 ns, 66 ns, 72 ns, 81 ns,
        89 ns, 97 ns, 99 ns
    );
    constant reset_states: time_array := (
        7 ns, 9 ns, 31 ns, 32 ns, 42 ns, 44 ns, 49 ns, 52 ns, 83 ns, 85 ns, 96 ns, 98 ns
    );
begin
    uut: register_n_bit generic map(n) port map(in_data, clock, out_data, reset, enable);
    clock_generator_instance: clock_generator generic map(10, 5 ns) port map(clock);

    enable_generator: switching_signal_generator generic map(enable_states)
        port map(enable);
    reset_generator: switching_signal_generator generic map(reset_states)
        port map(reset);

    in_data <= x"31",
        x"54" after 14 ns,
        x"5d" after 16 ns,
        x"c0" after 23 ns,
        x"21" after 41 ns,
        x"00" after 42 ns,
        x"0a" after 49 ns,
        x"e1" after 64 ns,
        x"29" after 66 ns,
        x"ee" after 83 ns,
        x"e2" after 94 ns,
        x"c4" after 100 ns;

end architecture;

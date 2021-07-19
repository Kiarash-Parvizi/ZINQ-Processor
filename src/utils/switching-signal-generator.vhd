library ieee;
use ieee.std_logic_1164.all;
use work.types.time_array;

entity switching_signal_generator is
    generic(
        -- The times in which the switch must be performed
        constant switch_timing: time_array
    );
    port(
        result: buffer std_logic := '0';
        initial_value: in std_logic := '0'
    );
end entity;

architecture behavioral of switching_signal_generator is
begin
    process
    begin
        result <= initial_value;

        for i in switch_timing'range loop
            if i = 0 then
                wait for switch_timing(i);
            else
                wait for switch_timing(i) - switch_timing(i - 1);
            end if;
            result <= not result;
        end loop;
        wait;
    end process;
end architecture;

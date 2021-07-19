library ieee;
use ieee.std_logic_1164.all;

entity register_n_bit is
    generic(
        constant n: integer
    );
    port(
        data: in std_logic_vector(n - 1 downto 0);
        clock: in std_logic;
        result: out std_logic_vector(n - 1 downto 0) := (others => '0');

        -- Resets the register to zero.
        reset: in std_logic := '0';
        -- Enable turns the register on or off.
        enable: in std_logic := '1'
    );
end entity;

architecture behavioral of register_n_bit is
begin
    process(reset, enable, clock)
    begin
        if reset = '1' then
            result <= (others => '0');
        elsif enable = '1' and rising_edge(clock) then
            result <= data;
        end if;
    end process;
end architecture;

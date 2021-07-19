library ieee;
use ieee.std_logic_1164.all;

entity shift_to_left is
    generic(
        constant len: natural;
        constant shift_amount: natural := 1
    );
    port(
        num: in std_logic_vector(len - 1 downto 0);
        result: out std_logic_vector(len - 1 downto 0)
    );
end entity;

architecture structural of shift_to_left is
begin
    -- Make right-most bits zero
    result(shift_amount - 1 downto 0) <= (others => '0');

    -- Make the shifted bits
    result(len - 1 downto shift_amount) <= num(len - shift_amount - 1 downto 0);
end architecture;

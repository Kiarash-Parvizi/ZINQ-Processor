library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.unsigned;
use ieee.numeric_std.to_integer;

entity register_file_3 is
    generic(
        constant addr_size: natural;
        constant n: natural
    );
    port(
        -- input
        clk, rst, we: in std_logic;
        r0: in std_logic_vector(addr_size-1 downto 0);
        r1: in std_logic_vector(addr_size-1 downto 0);
        r2: in std_logic_vector(addr_size-1 downto 0);
        wr: in std_logic_vector(addr_size-1 downto 0);
        wd: in std_logic_vector(n-1 downto 0);
        -- output
        out0: out std_logic_vector(n-1 downto 0);
        out1: out std_logic_vector(n-1 downto 0);
        out2: out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture structural of register_file_3 is
    type rf_type is array (0 to (2**addr_size)-1) of std_logic_vector(wd'range);
    signal rfBuf : rf_type := (others => (others => '0'));
begin
    out0 <= rfBuf(to_integer(unsigned(r0)));
    out1 <= rfBuf(to_integer(unsigned(r1)));
    out2 <= rfBuf(to_integer(unsigned(r2)));
    -- process
    process(clk, rst) is begin
        -- reset
        if(rst='1') then
            for i in 0 to rfBuf'length-1 loop
                rfBuf(i) <= (others => '0');
            end loop;
        -- write
        elsif(we='1' and clk'event and clk='1') then
            rfBuf(to_integer(unsigned(wr))) <= wd;
        end if;
    end process;
end architecture;

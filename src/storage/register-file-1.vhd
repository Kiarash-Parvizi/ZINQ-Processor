library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.unsigned;
use ieee.numeric_std.to_integer;

entity register_file_1 is
    generic(
        constant addr_size: natural;
        constant n: natural
    );
    port(
        -- input
        clk, rst, we: in std_logic;
        r0: in std_logic_vector(addr_size-1 downto 0);
        wr: in std_logic_vector(addr_size-1 downto 0);
        wd: in std_logic_vector(n-1 downto 0);
        -- output
        out0: out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture structural of register_file_1 is
    type rf_type is array (0 to (2**addr_size)-1) of std_logic_vector(wd'range);
    signal rfBuf : rf_type := (others => (others => '0'));
    function to_string(inp: std_logic_vector)return string is variable image_str: string (1 to inp'length);
        alias input_str: std_logic_vector (1 to inp'length) is inp; begin for i in input_str'range loop image_str(i)
        := character'VALUE(std_ulogic'IMAGE(input_str(i))); end loop; return image_str; end function;
begin
    out0 <= rfBuf(to_integer(unsigned(r0)));
    -- process
    process(clk, rst) is begin
        -- reset
        --report "rf1.process";
        if(rst='1') then
            report "rf1.if(1)";
            for i in 0 to rfBuf'length-1 loop
                rfBuf(i) <= (others => '0');
            end loop;
        -- write
        elsif(we='1' and clk'event and clk='1') then
            report "rf1.if(2)";
            if (addr_size = 2) then
                report "rf1.addr<all> = <" &
                    to_string(rfBuf(0)) & ", " &
                    to_string(rfBuf(1)) & ", " &
                    to_string(rfBuf(2)) & ", " &
                    to_string(rfBuf(3)) & ", " &
                ">\n";
            end if;
            rfBuf(to_integer(unsigned(wr))) <= wd;
        end if;
    end process;
end architecture;

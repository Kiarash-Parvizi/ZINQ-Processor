library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.unsigned;
use ieee.numeric_std.to_integer;

entity ram is
    port (
        clock   : in  std_logic;
        we      : in  std_logic;
        address : in  std_logic_vector;
        datain  : in  std_logic_vector;
        dataout : out std_logic_vector
    );
end entity;

architecture structural of ram is
    type ram_type is array (0 to (2**address'length)-1) of std_logic_vector(datain'range);
    signal ramBuf : ram_type := (others => (others => '0'));
    function to_string(inp: std_logic_vector)return string is variable image_str: string (1 to inp'length);
        alias input_str: std_logic_vector (1 to inp'length) is inp; begin for i in input_str'range loop image_str(i)
        := character'VALUE(std_ulogic'IMAGE(input_str(i))); end loop; return image_str; end function;
begin
    RamProc: process(clock) is
    begin
        if rising_edge(clock) then
            --report "ram: " & integer'image(address'length);
            if (address'length = 16) then
                report "ram.addr<0x0000, 0xFFFF, 0x3FFF> = <" &
                    to_string(ramBuf(16#0000#)) & ", " &
                    to_string(ramBuf(16#ffff#)) & ", " &
                    to_string(ramBuf(16#3fff#)) & ", " &
                ">\n";
            end if;
            if we = '1' then
                ramBuf(to_integer(unsigned(address))) <= datain;
            end if;
        end if;
    end process RamProc;
    
    dataout <= ramBuf(to_integer(unsigned(address)));
end architecture structural;

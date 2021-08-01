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
begin
    RamProc: process(clock) is
    begin
        if rising_edge(clock) then
            if we = '1' then
                ramBuf(to_integer(unsigned(address))) <= datain;
            end if;
        end if;
    end process RamProc;
    
    dataout <= ramBuf(to_integer(unsigned(address)));
end architecture structural;

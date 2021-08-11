from typing import Tuple

vhdl_header_template = '''\
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_Std.all; 

entity rom is
    port(
        address: in  std_logic_vector(%i downto 0);
        dataout: out std_logic_vector(%i downto 0)
    );
end entity;

'''
vhdl_architecture_template = '''
architecture structural of rom is
%s
type rom_array is array (natural range <>) of
    std_logic_vector(%i downto 0);

constant romBuf: rom_array := (%s);
begin
    dataout <= romBuf(to_integer(unsigned(address)));
end architecture structural;

'''
vhdl_constant_template = '''\
constant %s: std_logic_vector(%i downto 0) := x"%s";
'''

class rom_maker:
    def __init__(self, programFile):
        self.constants = ''
        self.constNames = ''
        with open(programFile, 'r') as f:
            self.__programLines = f.read().splitlines()

    def createRom(self, romAddrSize = None) -> Tuple[str,int,int]:
        from math import log, ceil
        programLines = self.__programLines
        instCnt = len(programLines)
        n = ceil(log(instCnt)/log(2))
        d = len(programLines[0])*4
        # set rom-size
        if romAddrSize != None and romAddrSize > 0:
            n = romAddrSize
        # create header
        header = self.__create_header(n, d)
        # create constants
        for i, line in enumerate(programLines):
            name = 'd%x'%i
            self.constants += (
                self.__make_constant('d%x'%i, d-1, line)
            )
            self.constNames += name + ','
        for i in range(instCnt, 2**n):
            name = 'd%x'%i
            self.constants += (
                self.__make_constant('d%x'%i, d-1, '0'*int(d/4))
            )
            self.constNames += name + ','
        self.constNames = self.constNames[:-1]
        # create architecture_template
        arch_tem = vhdl_architecture_template % (
            self.constants, d-1,
            self.constNames
        )
        return (header + arch_tem, n, d)

    def __create_header(self, n: int, d: int) -> str:
        return vhdl_header_template%(n-1, d-1) 

    def __make_constant(self, name: str, d: int, data: str) -> str:
        return vhdl_constant_template % (name, d, data)

import sys

def main(argv):
    romAddrSize = None
    try:
        inputfile = argv[0]
        if (len(argv) > 1):
            romAddrSize = int(argv[1])
        print('input-file: ' + inputfile)
    except IndexError as err:
        print('usage:\npython3 generate_rom.py <inputfile> [optional: rom-addr-size]')
        print('example:\npython3 generate_rom.py program.hex 4\n')
        sys.exit(2)
    except ValueError:
        print('Please enter an integer for [rom-addr-size]')
        sys.exit(2)
    rom_data = rom_maker(inputfile).createRom(romAddrSize)
    output_file = 'rom_%i_%i.vhd'%(rom_data[1], rom_data[2])
    with open(output_file, 'w') as outfile:
        outfile.write(rom_data[0])
    print('written to: ' + output_file)

if __name__ == '__main__':
    main(sys.argv[1:])

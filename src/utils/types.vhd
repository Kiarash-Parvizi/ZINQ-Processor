library ieee;
use ieee.std_logic_1164.all;

package types is
    type time_array is array(natural range <>) of time;
    type std_logic_vector_array is array(natural range <>) of std_logic_vector;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
    port (
        clock : in bit;
        reset : in bit;
        d: in bit;
        q: out bit
    );
end reg;

architecture rtl of reg is

begin
    p0: process(clock, reset)
    begin
        if reset = '1' then
            q <= '0';
        elsif rising_edge(clock) then
            q <= d;
        end if;
    end process;
end architecture;
-------------------------------------------------------
--! @file contador4.vhd
--! @brief synchronous 4-bit counter
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2023-09-08
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity contador4 is
    port (
        clock : in  bit;
        zera  : in  bit;
        conta : in  bit;
        Q     : out bit_vector(3 downto 0);
        fim   : out bit
    );
end entity contador4;

architecture comportamental of contador4 is
    signal IQ: integer range 0 to 15;
begin

    process (clock,zera,conta,IQ)
    begin
        if rising_edge(clock) then
            if zera='1' then  IQ <= 0;
            elsif conta='1' then
                if IQ=15 then IQ <= 0;
                else          IQ <= IQ + 1;
                end if;
            else              IQ <= IQ;
            end if;
        end if;
    end process;

    -- saida fim
    fim <= '1' when IQ=15 else
           '0';

    -- saida Q
    Q <= bit_vector(to_unsigned(IQ,Q'length));

end architecture comportamental;

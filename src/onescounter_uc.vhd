-------------------------------------------------------
--! @brief Ones Counter Control Unit
-------------------------------------------------------
library ieee;
use ieee.numeric_bit.rising_edge;

entity onescounter_uc is
  port (
    clock    : in  bit;
    reset    : in  bit;
    start    : in  bit;
    data0    : in  bit;
    zero     : in  bit;
    zera     : out bit;
    conta    : out bit;
    carrega  : out bit;
    desloca  : out bit;
    registra : out bit;
    done     : out bit
  );
end entity;

architecture fsm of onescounter_uc is
  type estado_t is (S0, S1, S2, S3, S4, S5);
  signal PE, EA : estado_t;
  signal estado : integer := 0;
begin

  with EA select estado <=
    0 when S0,
    1 when S1,
    2 when S2,
    3 when S3,
    4 when S4,
    5 when S5,
    9 when others;

  sincrono: process(clock, reset, PE)
  begin
    if (reset='1') then
      EA <= S0;
    elsif (rising_edge(clock)) then
      EA <= PE;
    end if;
  end process sincrono;

  combinatorio: process(EA, start, data0, zero)
  begin
    -- zera     <= '0';
    -- conta    <= '0';
    -- carrega  <= '0';
    -- desloca  <= '0';
    -- registra <= '0';

    case(EA) is
      when S0 =>
        if start='1' then
          PE <= S1;
        else
          PE <= S0;
        end if;
        done     <= '0';
        zera     <= '0';
        conta    <= '0';
        carrega  <= '0';
        desloca  <= '0';
        registra <= '0';

      when S1 =>
        PE <= S2;
        done     <= '0';
        zera     <= '1';
        conta    <= '0';
        carrega  <= '1';
        desloca  <= '0';
        registra <= '0';

      when S2 =>
        if data0='1' then
          PE <= S3;
        else
          PE <= S4;
        end if;
        done     <= '0';
        zera     <= '0';
        conta    <= '0';
        carrega  <= '0';
        desloca  <= '0';
        registra <= '0';

      when S3 =>
        PE <= S4;
        done     <= '0';
        zera     <= '0';
        conta    <= '1';
        carrega  <= '0';
        desloca  <= '0';
        registra <= '0';

      when S4 =>
        if zero='1' then
          PE <= S5;
        else
          PE <= S2;
        end if;
        done     <= '0';
        zera     <= '0';
        conta    <= '0';
        carrega  <= '0';
        desloca  <= '1';
        registra <= '0';

      when S5 =>
        PE <= S0;
        done     <= '1';
        zera     <= '0';
        conta    <= '0';
        carrega  <= '0';
        desloca  <= '0';
        registra <= '1';

      when others =>
        PE <= S0;
        done     <= '0';
        zera     <= '0';
        conta    <= '0';
        carrega  <= '0';
        desloca  <= '0';
        registra <= '0';
    end case;
  end process combinatorio;

end architecture;
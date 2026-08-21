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
    conta_fd : in  bit;
    zero     : in  bit;
    zera     : out bit;
    conta_uc : out bit;
    carrega  : out bit;
    desloca  : out bit;
    registra : out bit;
    done     : out bit
  );
end entity;

architecture fsm of onescounter_uc is
  type estado_t is (S0, S1, S2, S3, S4);
  signal PE, EA : estado_t;
  signal estado : integer := 0;
begin

  with EA select estado <=
    0 when S0,
    1 when S1,
    2 when S2,
    3 when S3,
    4 when S4,
    9 when others;

  sincrono: process(clock, reset, PE)
  begin
    if (reset='1') then
      EA <= S0;
    elsif (rising_edge(clock)) then
      EA <= PE;
    end if;
  end process sincrono;

  combinatorio: process(EA, start, zero)
  begin

    case(EA) is
      when S0 =>
        if start='1' then
          PE <= S1;
        else
          PE <= S0;
        end if;
        done     <= '0';
        zera     <= '1';
        conta_uc <= '0';
        carrega  <= '0';
        desloca  <= '0';
        registra <= '0';

      when S1 =>
        PE <= S2;
        done     <= '0';
        zera     <= '0';
        conta_uc <= '0';
        carrega  <= '1';
        desloca  <= '0';
        registra <= '0';

      when S2 =>
        PE <= S3;
        done     <= '0';
        zera     <= '0';
        conta_uc <= conta_fd;
        carrega  <= '0';
        desloca  <= '0';
        registra <= '0';

      when S3 =>
        if zero='1' then
          PE <= S4;
        else
          PE <= S2;
        end if;
        done     <= '0';
        zera     <= '0';
        conta_uc <= '0';
        carrega  <= '0';
        desloca  <= '1';
        registra <= '0';

      when S4 =>
        PE <= S0;
        done     <= '1';
        zera     <= '0';
        conta_uc <= '0';
        carrega  <= '0';
        desloca  <= '0';
        registra <= '1';

      when others =>
        -- atribuicao default (idealmente nunca se usa, mas eh importante para evitar latches na sintese!!)
        PE <= S0;
        done     <= '0';
        zera     <= '0';
        conta_uc <= '0';
        carrega  <= '0';
        desloca  <= '0';
        registra <= '0';
    end case;
  end process combinatorio;

end architecture;
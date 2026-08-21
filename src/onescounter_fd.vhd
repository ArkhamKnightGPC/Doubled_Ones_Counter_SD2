-------------------------------------------------------
--! @brief Ones Counter Dataflow
-------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity onescounter_fd is
  port (
    clock    : in  bit;
    reset    : in  bit;
    modo     : in  bit;
    inport   : in  bit_vector(14 downto 0);
    zera     : in  bit;
    conta_uc : in  bit;
    carrega  : in  bit;
    desloca  : in  bit;
    registra : in  bit;
    outport  : out bit_vector(3 downto 0);
    conta_fd : out bit;
    zero     : out bit
  );
end entity;

architecture structural of onescounter_fd is

  component contador4
    port (
        clock : in  bit;
        zera  : in  bit;
        conta : in  bit;
        Q     : out bit_vector(3 downto 0);
        fim   : out bit
        );
  end component;

  component deslocador_n
      generic (
          constant N : integer
      );
      port (
          clock          : in  bit;
          reset          : in  bit;
          carrega        : in  bit;
          desloca        : in  bit;
          entrada_serial : in  bit;
          dados          : in  bit_vector (N-1 downto 0);
          saida          : out bit_vector (N-1 downto 0)
      );
  end component;

  component reg is
    port (
        clock : in bit;
        reset : in bit;
        d: in bit;
        q: out bit
    );
  end component;

  signal s_data: bit_vector(14 downto 0);
  signal data0, data1, gated_mode_clock, reg_modo_q: bit;

begin

    DESL: deslocador_n
    generic map (
        N => 15
    )
    port map (
        clock          => clock,
        reset          => reset,
        carrega        => carrega,
        desloca        => desloca,
        entrada_serial => '0', -- no shift right sempre colocamos zero
        dados          => inport,
        saida          => s_data
    );

    CONT: contador4
    port map
    (
         clock =>  clock,
         zera  =>  zera,
         conta =>  conta_uc,
         Q     =>  outport, -- variavel Ocount
         fim   =>  open
    );

    gated_mode_clock <= clock and zera; -- atualizamos reg_modo apenas no estado S0
    REG_MODO: reg
    port map
    (
        clock => gated_mode_clock,
        reset => reset,
        d => modo,
        q => reg_modo_q
    );

    --saida zero
    zero <= '1' when unsigned(s_data)=0 else '0';

    -- saida data0
    data0 <= s_data(0);
    data1 <= s_data(1);

    -- essa eh a expressao que diz se contamos ou nao, deixamos a uc dizer qual o estado certo para aplicar ela
    conta_fd <= data0 and ((not reg_modo_q) or data1);

end architecture;
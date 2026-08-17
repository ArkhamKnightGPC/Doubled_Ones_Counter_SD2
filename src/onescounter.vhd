-------------------------------------------------------
--! @brief One Counter (UC+FD)
-------------------------------------------------------
entity onescounter is
  port (
    clock   : in  bit;
    reset   : in  bit;
    start   : in  bit;
    inport  : in  bit_vector(14 downto 0);
    outport : out bit_vector(3 downto 0);
    done    : out bit
  );
end entity;

architecture uc_fd of onescounter is

  component onescounter_uc is
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
  end component;

  component onescounter_fd is
  port (
    clock    : in  bit;
    reset    : in  bit;
    inport   : in  bit_vector(14 downto 0);
    zera     : in  bit;
    conta    : in  bit;
    carrega  : in  bit;
    desloca  : in  bit;
    registra : in  bit;
    outport  : out bit_vector(3 downto 0);
    data0    : out bit;
    zero     : out bit
  );
  end component;

  signal s_zera, s_conta, s_carrega, s_desloca, s_registra : bit;
  signal s_data0, s_zero : bit;

begin
  UC: onescounter_uc
    port map (
        clock    => clock,
        reset    => reset,
        start    => start,
        data0    => s_data0,
        zero     => s_zero,
        zera     => s_zera,
        conta    => s_conta,
        carrega  => s_carrega,
        desloca  => s_desloca,
        registra => s_registra,
        done     => done
    );

  FD: onescounter_fd
    port map (
        clock    => clock,
        reset    => reset,
        inport   => inport,
        zera     => s_zera,
        conta    => s_conta,
        carrega  => s_carrega,
        desloca  => s_desloca,
        registra => s_registra,
        outport  => outport,
        data0    => s_data0,
        zero     => s_zero
);
end architecture;
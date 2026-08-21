-------------------------------------------------------
--! @brief One Counter (UC+FD)
-------------------------------------------------------
entity onescounter is
  port (
    clock   : in  bit;
    reset   : in  bit;
    start   : in  bit;
    modo    : in bit;
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
    conta_fd : in  bit;
    zero     : in  bit;
    zera     : out bit;
    conta_uc : out bit;
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
  end component;

  signal s_zera, s_conta, s_carrega, s_desloca, s_registra : bit;
  signal conta_fd, conta_uc, s_zero : bit;

begin
  UC: onescounter_uc
    port map (
        clock    => clock,
        reset    => reset,
        start    => start,
        conta_fd => conta_fd,
        zero     => s_zero,
        zera     => s_zera,
        conta_uc => conta_uc,
        carrega  => s_carrega,
        desloca  => s_desloca,
        registra => s_registra,
        done     => done
    );

  FD: onescounter_fd
    port map (
        clock    => clock,
        reset    => reset,
        modo     => modo,
        inport   => inport,
        zera     => s_zera,
        conta_uc => conta_uc,
        carrega  => s_carrega,
        desloca  => s_desloca,
        registra => s_registra,
        outport  => outport,
        conta_fd => conta_fd,
        zero     => s_zero
);
end architecture;
-------------------------------------------------------
--! @brief OneCounter testbench
-------------------------------------------------------
library ieee;
use ieee.numeric_bit.rising_edge;
use ieee.numeric_bit.falling_edge;
use ieee.numeric_bit.to_unsigned;
use ieee.numeric_bit.to_integer;
use ieee.numeric_bit.unsigned;

entity onescounter_tb is
end entity;

architecture arch of onescounter_tb is

  function conta(modo:bit; i:integer; s:integer) return integer is
    variable c: integer := 0;
    variable bv: bit_vector(s-1 downto 0);
  begin
    bv := bit_vector(to_unsigned(i, s));
    for ii in 0 to s-1 loop
      if modo = '0' then
        if bv(ii)='1' then
          c := c+1;
        end if;
      elsif ii < s-1 then
        if bv(ii)='1' and bv(ii+1)='1' then
          c := c+1;
        end if;
      end if;
    end loop;
    return c;
  end conta;

  component onescounter is
  port (
    clock   : in  bit;
    reset   : in  bit;
    start   : in  bit;
    modo    : in  bit;
    inport  : in  bit_vector(14 downto 0);
    outport : out bit_vector(3 downto 0);
    done    : out bit
  );
  end component;

  constant size: integer := 15;
  constant ckp : time := 10 ns;

  signal clk, rst, sim, modo: bit := '0';
  signal stt, don: bit;
  signal inp : bit_vector(14 downto 0);
  signal otp : bit_vector(3 downto 0);

begin
  clk <= (sim and (not clk)) after ckp/2;

  dut: onescounter
    port map(
        clock   => clk,
        reset   => rst,
        start   => stt,
        modo    => modo,
        inport  => inp,
        outport => otp,
        done    => don
    );

  st: process is
  begin
    sim <= '1';
    assert false report "BOT" severity note;
    --! reset
    rst<='1';
    stt <= '0';
    wait until rising_edge(clk);
    wait until falling_edge(clk);
    rst<='0';
    wait until falling_edge(clk);

    for i in 0 to (2**size)-1 loop
      --report "Teste: " & integer'image(i) & " com modo=0";

      wait until falling_edge(clk);
      inp <= bit_vector(to_unsigned(i,size));
      modo <= '0';


      stt <= '1';
      wait until falling_edge(clk);
      stt <= '0';

      wait until don='1'; --final da contagem
      assert conta('0', i, size) = to_integer(unsigned(otp))
        report "Teste: "&integer'image(i)&" com modo=0 falhou! Resposta:"&integer'image(to_integer(unsigned(otp))) severity failure;

      --report "Teste: "&integer'image(i)&" com modo=0 ok!" severity note;
      wait until falling_edge(clk);
    end loop;

    for i in 0 to (2**size)-1 loop
      --report "Teste: " & integer'image(i) & " com modo=1";

      wait until falling_edge(clk);
      inp <= bit_vector(to_unsigned(i,size));
      modo <= '0';


      stt <= '1';
      wait until falling_edge(clk);
      stt <= '0';

      wait until don='1'; --final da contagem
      assert conta('0', i, size) = to_integer(unsigned(otp))
        report "Teste: "&integer'image(i)&" como modo=1 falhou! Resposta:"&integer'image(to_integer(unsigned(otp))) severity failure;

      --report "Teste: "&integer'image(i)&" com modo=1 ok!" severity note;
      wait until falling_edge(clk);
    end loop;

   assert false report "Todos os testes ok!" severity note;
   assert false report "EOT" severity note;
   sim <='0';
   wait;
 end process;
end architecture;
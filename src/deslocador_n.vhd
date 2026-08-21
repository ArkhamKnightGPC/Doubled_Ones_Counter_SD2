---------------------------------------------------------
--! @file deslocador_n.vhd
--! @brief generic shift register with asynchronous reset
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2023-08-09
---------------------------------------------------------

-- library ieee;

entity deslocador_n is
    generic (
        constant N : integer := 4 -- valor default
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
end entity deslocador_n;

architecture deslocador_n_arch of deslocador_n is
    signal IQ: bit_vector (N-1 downto 0);
begin

    process (clock, reset, IQ)
    begin
        if reset='1' then IQ <= (others=>'0');
        elsif (clock'event and clock='1') then
            if carrega='1' then IQ <= dados;
            elsif desloca='1' then IQ <= entrada_serial & IQ(N-1 downto 1);
            else IQ <= IQ;
            end if;
        end if;
    end process;

    saida <= IQ;

end architecture deslocador_n_arch;

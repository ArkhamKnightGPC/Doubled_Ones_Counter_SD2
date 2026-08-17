#!/bin/bash

SRC="../src"
TB="../tb"

ghdl -a --std=08 "${SRC}/contador4.vhd"
ghdl -a --std=08 "${SRC}/deslocador_n.vhd"
ghdl -a --std=08 "${SRC}/onescounter_uc.vhd"
ghdl -a --std=08 "${SRC}/onescounter_fd.vhd"
ghdl -a --std=08 "${SRC}/onescounter.vhd"
ghdl -a --std=08 "${TB}/onescounter_tb.vhd"
ghdl -e --std=08 onescounter_tb
ghdl -r --std=08 onescounter_tb --vcd=onescounter_original.vcd
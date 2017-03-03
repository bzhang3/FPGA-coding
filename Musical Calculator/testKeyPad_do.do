if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work [pwd]/testKeyPad.v
vlog -sv -work work [pwd]/testKeyPad_tb.sv

vsim top_tb;

add wave *
add wave DUT/*



#view structure
#view signals



run 1000 ns
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work [pwd]/keyPadCtrl.sv
vlog -sv -work work [pwd]/keyPad_tb.sv

vsim keyPad_tb

add wave *
add wave keyPadCtrlDUT/*

#view structure
#view signals



run 10000 ns
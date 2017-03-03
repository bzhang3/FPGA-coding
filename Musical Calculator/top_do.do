if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work [pwd]/keyPadCtrl.sv
vlog -sv -work work [pwd]/synchronizerFalling.v
vlog -sv -work work [pwd]/syncToggle.v
vlog -sv -work work [pwd]/Synchronization.sv
vlog -sv -work work [pwd]/inputMem.v
vlog -sv -work work [pwd]/shuntingYardTwo.v
vlog -sv -work work [pwd]/solveEq.sv
vlog -sv -work work [pwd]/createHex.v
vlog -sv -work work [pwd]/sevenSegment.v
vlog -sv -work work [pwd]/Lcd_sys.sv
vlog -sv -work work [pwd]/keyPadSync.sv
vlog -sv -work work [pwd]/testKeyPad.v
vlog -sv -work work [pwd]/clockdiv.v
vlog -sv -work work [pwd]/top.sv
vlog -sv -work work [pwd]/top_tb.sv

vsim top_tb

add wave *
add wave topDUT/*
add wave topDUT/keyPadUnit/*
add wave topDUT/keyPadDecoder/*
add wave topDUT/keyPadCtrlUnit/*
add wave topDUT/eqProcessor/opStack
add wave topDUT/infixFIFO/memory
add wave topDUT/postFixFIFO/*
add wave topDUT/eqProcessor/*
add wave topDUT/solveEq/*
add wave topDUT/solveEq/temp_stack
add wave topDUT/sevenSegUnit/*


#view structure
#view signals



run 300000 ns
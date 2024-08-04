sim:
	iverilog -o waveform ./test_module.v
	vvp waveform
gtk:
	gtkwave wave.vcd
clean:
	rm -rf waveform wave.vcd
run:clean sim
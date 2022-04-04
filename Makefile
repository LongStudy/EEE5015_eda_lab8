DUT = ./top_module.v

TB  = ./top_module_tb.v ./timescale.v

SEED = $(shell date +%s)

run: compile simulate

compile:
	vcs -sverilog +v2k -debug_all $(DUT) $(TB) -l com_$(SEED).log

simulate:
	./simv +plusargs_save +seed=$(SEED) -l sim_$(SEED).log

run_dve:
	dve -vpd vcdplus.vpd &

clean:
	@-rm -rf *.log  csrc simv simv.daidir ucli.key DVEfiles *.vpd simv.vdb coverage *.bak *.help

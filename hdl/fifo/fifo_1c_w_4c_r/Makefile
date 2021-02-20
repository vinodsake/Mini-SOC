## 
## -------------------------------------------------------------
##    Copyright 2004-2009 Synopsys, Inc.
##    All Rights Reserved Worldwide
## 
##    Licensed under the Apache License, Version 2.0 (the
##    "License"); you may not use this file except in
##    compliance with the License.  You may obtain a copy of
##    the License at
## 
##        http://www.apache.org/licenses/LICENSE-2.0
## 
##    Unless required by applicable law or agreed to in
##    writing, software distributed under the License is
##    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##    CONDITIONS OF ANY KIND, either express or implied.  See
##    the License for the specific language governing
##    permissions and limitations under the License.
## -------------------------------------------------------------
##

## To enable objections trace +UVM_OBJECTION_TRACE

COM = vcs
COM_OPTS = -Mupdate -kdb -Mlib -debug_access+all -sverilog +vcs+dumpfile  
DVE_OPTS = -R -gui
DEF_OPTS = -full64  
INC_DIR = +incdir+../common/
UVM = -ntb_opts uvm-1.2
TSCALE = -timescale=1ns/1ns
ASSR = -assert dve 
MAX_ASSR = -assert finish_maxfail=1

all: comp run

clean:
	rm -rf simv* csrc *.log vc_hdrs.h ucli.key report/ .saveDVEfiles/ .synopsys* urgReport/ .inter* *.vpd DVEfiles/ verdiLog/ novas.* .restart* *.vcd *verdi*

comp:
	$(COM) $(TSCALE) $(COM_OPTS) $(DEF_OPTS) $(INC_DIR) -assert enable_hier -f *.vfv -l comp.log 

run:
	./simv -l run.log 
	if [ -d "simv.vdb" ]; then urg -dir simv.vdb -report report; fi

dve:	comp
	dve -full64 -simflow -dbdir simv.daidir/ &
	#./simv -verdi -sx $(TSCALE) $(COM_OPTS) $(DVE_OPTS) $(DEF_OPTS) $(INC_DIR) $(UVM) $(ASSR) -f *.vfv -l comp.log &

cov:
	firefox report/dashboard.html &

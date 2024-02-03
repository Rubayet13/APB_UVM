# Define Vivado commands
set XVLOG "/tools/Xilinx/Vivado/2023.2/bin/xvlog"
set XELAB "/tools/Xilinx/Vivado/2023.2/bin/xelab"
set XSIM "/tools/Xilinx/Vivado/2023.2/bin/xsim"
set PROJECT_HOME "/home/rubayet/Desktop/APB_Project"

# Define file compilation order
set COMPILE_ORDER [list
    "$PROJECT_HOME/tb/tb_top/params.sv"
    "$PROJECT_HOME/rtl/apb_rtl.sv"
    "$PROJECT_HOME/rtl/slave_rtl.sv"
    "$PROJECT_HOME/tb/agent/apb_trans.sv"
    "$PROJECT_HOME/tb/tb_top/apb_interface.sv"
    "$PROJECT_HOME/tb/test_lib/apb_base_test.sv"
    "$PROJECT_HOME/tb/tb_top/apb_tb_top.sv"
]

# Define simulation variables
set TB_TOP "tb"
set COMP_OPT "--incr --relax"
set SIM_LOG "-log simulate.log"
set ELAB_LOG "-log elaborate.log"
set XVLOG_LOG "-log xvlog.log"
set UVM "-L uvm"
set UVM_VERBOSITY_CONTROL "UVM_MEDIUM"
set TEST_NAME "apb_base_test"
set TIMESCALE "-timescale 1ns/1ps"

# Target Commands
proc compilation {} {
    global XVLOG COMPILE_ORDER COMP_OPT UVM
    eval exec $XVLOG -sv $COMPILE_ORDER $COMP_OPT $UVM
}

proc elaboration {} {
    global XELAB TB_TOP COMP_OPT ELAB_LOG
    eval exec $XELAB $TB_TOP --relax -s top --debug typical $ELAB_LOG
}

proc simulate {} {
    global XSIM TB_TOP TEST_NAME UVM_VERBOSITY_CONTROL
    eval exec $XSIM top -testplusarg UVM_TESTNAME=$TEST_NAME -testplusarg UVM_VERBOSITY=$UVM_VERBOSITY_CONTROL -runall
}

proc clean {} {
    global PROJECT_HOME
    eval exec rm -rf *.jou *.log *.pb *.wdb xsim.dir xsim.covdb xcrg_report *.vcd
    eval exec rm -rf .*.timestamp
}

# Run the desired target
compilation
elaboration
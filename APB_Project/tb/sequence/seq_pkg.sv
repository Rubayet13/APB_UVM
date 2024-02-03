package seq_pkg;

  import agent_pkg::*;
  
  `include "../tb_top/params.sv"
  `include "bulk_seq.sv"
  `include "read_err.sv"
  `include "write_seq.sv"
  `include "write_read.sv"
  `include "slv_error_write.sv"
  `include "reset_dut.sv"
  `include "read_seq.sv"

endpackage
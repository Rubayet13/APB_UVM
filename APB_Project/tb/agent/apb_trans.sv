typedef enum bit [1:0]   {readd = 0, writed = 1, rst = 2} oper_mode;

class transaction extends uvm_sequence_item; 
  rand oper_mode          op;
  rand logic            	PWRITE;
  rand logic [31 : 0]   	PWDATA;
  rand logic [31 : 0]	  	PADDR;

  // Output Signals of DUT for APB UART's transaction
  logic				    PREADY;
  logic 				    PSLVERR;
  logic [31: 0]		    PRDATA;

  `uvm_object_utils_begin(transaction)
  `uvm_field_int (PWRITE,UVM_ALL_ON)
  `uvm_field_int (PWDATA,UVM_ALL_ON)
  `uvm_field_int (PADDR,UVM_ALL_ON)
  `uvm_field_int (PREADY,UVM_ALL_ON)
  `uvm_field_int (PSLVERR,UVM_ALL_ON)
  `uvm_field_int (PRDATA,UVM_ALL_ON)
  `uvm_field_enum(oper_mode, op, UVM_DEFAULT)
  `uvm_object_utils_end

constraint addr_c { PADDR <= 31; }
constraint addr_c_err { PADDR > 31; }

function new(string name = "transaction");
  super.new(name);
endfunction

endclass 
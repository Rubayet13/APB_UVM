class transaction extends uvm_sequence_item;

rand logic            	PWRITE;
rand logic [31 : 0]   	PWDATA;
rand logic [31 : 0]	  	PADDR;

// Output Signals of DUT for APB UART's transaction
logic				    PREADY;
logic 				PSLVERR;
logic [31: 0]		    PRDATA;

`uvm_object_utils_begin(transaction)
`uvm_field_int (PWRITE,UVM_ALL_ON)
`uvm_field_int (PWDATA,UVM_ALL_ON)
`uvm_field_int (PADDR,UVM_ALL_ON)
`uvm_field_int (PREADY,UVM_ALL_ON)
`uvm_field_int (PSLVERR,UVM_ALL_ON)
`uvm_field_int (PRDATA,UVM_ALL_ON)
`uvm_object_utils_end

rand OPERATION opp; // used by to denote operation under use
VALIDITY valid = NA; // the scoreboard will assign Passed of failed for the address used 

int accesses [OPERATION] = '{READ:0, WRITE:0}; // the scoreboard will use this to keep track of operations on an address


constraint opp_co {
  opp != RESET;
}

constraint addr_co {
  PADDR dist {[0:'hF] :=100, 
              ['hF0: 'h10F] :=10,   
              ['hFF0: 'h100F] :=2, 
              ['hFFF0: 'h1000F] :=1};
}

constraint data_in_co {
  if (opp == WRITE) PWDATA != 0;
  else PWDATA == 0;
}


function new(string name = "transaction");
  super.new(name);
endfunction

endclass 




//   /*
//   use a copy of the item for memory isolation
//   */
//   virtual function mem_trans do_copy();
//     do_copy = new();

//     do_copy.addr = addr;
//     do_copy.accesses = accesses;
//     do_copy.data_in = data_in;
//     do_copy.data_out = data_out;

//   endfunction

// endclass
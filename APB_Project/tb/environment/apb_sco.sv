class sco extends uvm_scoreboard;
`uvm_component_utils(sco)

  uvm_analysis_imp#(transaction,sco) recv;
  bit [31:0] arr[32] = '{default:0};
  bit [31:0] addr    = 0;
  bit [31:0] data_rd = 0;
 


    function new(input string name = "sco", uvm_component parent = null);
    super.new(name,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
    endfunction
    
    
  virtual function void write(transaction tr);
    if(tr.op == rst)
              begin
                `uvm_info("SCO", "SYSTEM RESET DETECTED", UVM_NONE);
              end  
    else if (tr.op == writed)
      begin
            if(tr.PSLVERR == 1'b1)
                begin
                  `uvm_info("SCO", "SLV ERROR during WRITE OP", UVM_NONE);
                end
              else
                begin
                  arr[tr.PADDR] = tr.PWDATA;
                  `uvm_info("SCO", $sformatf("DATA WRITE OP  addr:%0d, wdata:%0d arr_wr:%0d",tr.PADDR,tr.PWDATA,  arr[tr.PADDR]), UVM_NONE);
                end
      end
    else if (tr.op == readd)
      begin
           if(tr.PSLVERR == 1'b1)
                begin
                  `uvm_info("SCO", "SLV ERROR during READ OP", UVM_NONE);
                end
              else 
                begin
                         data_rd = arr[tr.PADDR];
                 		 if (data_rd == tr.PRDATA)
                 			 `uvm_info("SCO", $sformatf("DATA MATCHED : addr:%0d, rdata:%0d",tr.PADDR,tr.PRDATA), UVM_NONE)
                         else
                           `uvm_info("SCO",$sformatf("TEST FAILED : addr:%0d, rdata:%0d data_rd_arr:%0d",tr.PADDR,tr.PRDATA,data_rd), UVM_NONE) 
                end
 
      end
     
  
    $display("----------------------------------------------------------------");
    endfunction

endclass

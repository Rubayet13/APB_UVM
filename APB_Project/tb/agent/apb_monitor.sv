class mon extends uvm_monitor;
`uvm_component_utils(mon)

uvm_analysis_port#(transaction) send;
transaction tr;
virtual apb_if vif;

    function new(input string name = "mon", uvm_component parent = null);
    super.new(name,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    send = new("send", this);
      if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))//uvm_test_top.env.agent.drv.aif
        `uvm_error("MON","Unable to access Interface");
    endfunction
    
    
    virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.pclk);
      if(!vif.rst_n)
        begin
        tr.op      = rst; 
        `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_NONE);
         send.write(tr);
        end
      else if (vif.rst_n && vif.pwrite)
         begin
          @(negedge vif.pready);
          tr.op     = writed;
          tr.PWDATA = vif.pwdata;
          tr.PADDR  =  vif.paddr;
          tr.PSLVERR  = vif.pslverr;
          `uvm_info("MON", $sformatf("DATA WRITE addr:%0d data:%0d slverr:%0d",tr.PADDR,tr.PWDATA,tr.PSLVERR), UVM_NONE); 
          send.write(tr);
         end
      else if (vif.rst_n && !vif.pwrite)
         begin
           @(negedge vif.pready);
          tr.op     = readd; 
          tr.PADDR  =  vif.paddr;
          tr.PRDATA   = vif.prdata;
          tr.PSLVERR  = vif.pslverr;
          `uvm_info("MON", $sformatf("DATA READ addr:%0d data:%0d slverr:%0d",tr.PADDR, tr.PRDATA,tr.PSLVERR), UVM_NONE); 
          send.write(tr);
         end
    
    end
   endtask 

endclass

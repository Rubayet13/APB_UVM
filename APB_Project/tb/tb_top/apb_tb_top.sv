`include "uvm_macros.svh"  
import uvm_pkg::*;

module tb;


  apb_if vif();

  apb_rtl dut (.rst_n(vif.rst_n), 
               .pclk(vif.pclk), 
               .psel(vif.psel), 
               .penable(vif.penable), 
               .pwrite(vif.pwrite), 
               .paddr(vif.paddr), 
               .pwdata(vif.pwdata), 
               .prdata(vif.prdata), 
               .pready(vif.pready), 
               .pslverr(vif.pslverr)
              );

  initial begin
    vif.pclk <= 0;
  end
  // bit clk;
  //   always #10 clk=~clk;
  always #10 vif.pclk <= ~vif.pclk;



  initial begin
    //vif.pclk=clk;
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
    run_test("test");
  end


  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end


endmodule


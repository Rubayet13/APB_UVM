interface apb_if #(addrWidth = 32, dataWidth = 32) ();
  // Signals
  logic              pclk;
  logic              rst_n;
  logic       [addrWidth-1:0] paddr;
  logic              pwrite;
  logic       [dataWidth-1:0] pwdata;
  logic              penable;
  logic              psel;
  logic       [dataWidth-1:0] prdata;
  logic              pslverr;
  logic              pready;


endinterface
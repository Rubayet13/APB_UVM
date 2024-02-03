// Code your design here
module apb_rtl #(addrWidth = 32, dataWidth = 32)  
  (
    input                        pclk,
    input                        rst_n,
    input        [addrWidth-1:0] paddr,
    input                        pwrite,
    input                        psel,
    input                        penable,
    input        [dataWidth-1:0] pwdata,

    output	 reg   		pready,
    output   wire [dataWidth-1:0] prdata,
    output   reg                  pslverr
  );


  wire write, sel, ready, slverr;
  wire [dataWidth - 1:0] wdata, rdata;
  wire [addrWidth - 1:0] addr; 

  slave_rtl #(.addrWidth (addrWidth), .dataWidth (dataWidth), .Writable (256) ) slv
  ( .clk(pclk),
   .rst_n(rst_n),
   .write(write),
   .sel(sel),
   .addr(addr),
   .wdata(wdata),
   .rdata(rdata),
   .ready(ready),
   .err(slverr)
  );


  enum {IDLE, SETUP, ENB, READY} states;
  reg [3:0] p_state, n_state;

  assign sel = (penable) ? psel:'b0;
  assign write = (penable) ? pwrite:'b0;
  assign addr = (penable) ? paddr:'b0;
  assign pready = ready;
  assign pslverr = (ready == 1) ? slverr:'bz;  
  assign wdata = (ready == 1 && pwrite == 1) ? pwdata:'bz;
  assign prdata = (ready == 1 && pwrite == 0) ? rdata:'bz;


  always @ (posedge pclk or negedge rst_n) begin
    if(!rst_n)
      p_state <= IDLE;
    else
      p_state <= n_state;
  end

  always @(*) begin

    case (p_state)

      IDLE: begin
        if (psel == 1) n_state = SETUP;
        else n_state = IDLE;
      end

      SETUP: begin
        if (psel == 0) n_state = IDLE;
        else n_state = (penable) ? ENB:SETUP;
      end

      ENB: begin
        if (psel == 0) n_state = IDLE;
        else begin
          if (!penable) n_state = SETUP;
          else n_state = (ready) ? READY:ENB; 
        end
      end

      READY: begin
        if (!psel) n_state = IDLE;
        else n_state = READY;
      end

    endcase

  end

endmodule
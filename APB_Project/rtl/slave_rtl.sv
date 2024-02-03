
module slave_rtl #(addrWidth = 32, dataWidth = 32, Writable = 256)
  (
    input clk, write, sel, rst_n,
    input [addrWidth -1:0] addr,
    input [dataWidth -1:0] wdata,
    output [dataWidth -1:0] rdata,
    output reg ready, err
  );

  enum {IDLE, WAIT, READY} cases;

  reg [dataWidth - 1:0] data [Writable];

  reg [3:0] p_state, n_state;
  reg [7:0] cnt;

  assign rdata = (ready & !write) ? data [addr]:'bz;

  always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      p_state <= IDLE;
      foreach (data[i]) data[i] <= 0;
    end
    else p_state <= n_state;
  end


  always @(*) begin: NSL

    casez(p_state)
      IDLE: begin
        ready = 0;
        err = 0;

        if (sel == 0) n_state = IDLE;
        else begin
          if (addr [1:0] == 2'b00) n_state = READY;
          else n_state = WAIT;
        end
      end


      WAIT: begin
        ready = 0;
        err = 0;
        n_state = (cnt < addr[1:0]) ? WAIT:READY;
      end


      READY: begin
        ready = 1;

        if (addr < Writable) begin
          err = 0;
          if (write) data[addr] = wdata;
          else data[addr] = data[addr];
        end

        else err = 1;

        n_state = IDLE;

      end

    endcase

  end: NSL

  always @(posedge clk or negedge rst_n) begin: COUNT

    if (!rst_n | !sel ) cnt <= 0;
    else cnt <= cnt+1;

  end: COUNT

endmodule
module Spi #(parameter Nk = 4, Nr = 10, datasize = 128)(
    input clk,
    input rst,
    input cs,
    input miso,
    output reg mosi,
    output reg done = 0,
    input [Nk * 32 - 1:0] data
);
    reg state = 0;
    reg [127:0] regis = 0;
    integer counter = 0;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            regis <= 128'h00000000000000000000000000000000;
            state <= 0;
        end else begin
            if(!cs && counter < datasize) begin
                regis <= {regis[126:0], miso};
                state <= !cs;
            end
            else
                state <= !cs;
        end
    end

    always @(negedge clk, posedge rst) begin
        if (rst)
            mosi <= 1'b0;
        else
            if(state == 1 && !cs) begin
                counter = counter + 1;
                mosi <= regis[127];
                if(counter == datasize)
                    done <= 1'b1;
            end
    end

    assign data = regis;

endmodule
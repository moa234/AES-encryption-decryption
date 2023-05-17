module Spi #(parameter Nk = 4, Nr = 10, datasize = 128)(
    input clk,
    input rst,
    input cs,
    output reg miso,
    input mosi,
    output reg done = 0,
    output [Nk * 32 - 1:0] data
);
    reg state = 0;
    reg [datasize - 1:0] regis = 0;
    integer counter = 0;
    reg rec;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            regis <= 0;
            state <= 0;
        end else begin
            if(!cs && counter < datasize) begin
                rec = mosi;
                state <= !cs;   
            end
            else
                state <= !cs;
        end
    end

    always @(negedge clk, posedge rst) begin
        if (rst)
            miso <= 1'b0;
        else
            if(state == 1 && !cs) begin
                miso = regis[datasize - 1];
                regis <= {regis[datasize - 2:0], rec};
                counter = counter + 1;
                if(counter == datasize)
                    done <= 1'b1;
            end
    end

    assign data = regis;

endmodule
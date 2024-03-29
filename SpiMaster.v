module SpiMaster #(parameter Nk = 4, Nr = 10, datasize = 128)(
    input clk,
    output sclk,
    input rst,
    input cs,
    output scs,
    input miso,
    output reg mosi,
    output reg done = 0,
    input [Nk * 32 - 1:0] data
);
    reg state = 0;
    reg [datasize - 1:0] regis = 0;
    integer counter = 0;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            regis <= data;
            state <= 0;
        end else begin
            if(!cs && counter < datasize) begin
                regis <= {regis[datasize - 2:0], miso};
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
                mosi <= regis[datasize - 1];
                if(counter == datasize)
                    done <= 1'b1;
            end
    end
    assign sclk = clk;
    assign scs = cs;

endmodule
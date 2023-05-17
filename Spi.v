module Spi #(parameter Nk = 4, Nr = 10, datasize = 128)(
    input clk,
    input rst,
    input cs,
    output reg miso,
    input mosi,
    output reg done = 0,
    output [Nk * 32 - 1:0] data
);
    reg [datasize - 1:0] regis = 0;
    integer counter = 0;
    reg rec;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            
        end else begin
            if(!cs && counter < datasize) begin
                rec = mosi;  
            end
        end
    end

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            miso <= 1'b0;
			regis <= 0;
		end else
            if(!cs) begin
                miso = regis[datasize - 1];
                regis <= {regis[datasize - 2:0], rec};
                counter = counter + 1;
                if(counter == datasize)
                    done <= 1'b1;
            end
    end

    assign data = regis;

endmodule
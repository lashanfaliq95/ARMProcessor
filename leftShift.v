module stimulus;
wire[15:0] y;
reg[15:0] x;
reg clock;
leftshift ls(x,y,clock);
initial
begin
clock=0;
clock=1;
x=16'b0000000000001011; 
#1 $display("x= %b, y= %b\n",x,y);
clock=0;
clock=1;
x=16'b0000000000000001; 
#1 $display("x= %b, y= %b\n",x,y);

end

endmodule





module leftshift(x,y,clock);
input[15:0] x;
output reg[15:0] y;
input clock;
always@(posedge clock) begin
y=x<<1'b1;
end

endmodule

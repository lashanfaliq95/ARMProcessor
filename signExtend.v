module stimulus;
reg[3:0] x;
wire[15:0] y;
reg clock;
signExtend sign(x,y,clock);

initial
begin
clock=0;
clock=1;
x=4'b0101;
//y=16'b0000000000000101;
#5 $display("x=%b y=%b",x,y);
end
endmodule

module signExtend(x,y,clock); //sign extend the offset
input[3:0] x;
output reg[15:0] y;
input clock;
integer i;

always@(posedge clock) begin
for(i=0;i<16;i=i+1)
begin 
if(i<4)
y[i]=x[i];
else
y[i]=x[3];
end
end

endmodule

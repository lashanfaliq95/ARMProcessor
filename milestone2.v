/*
x, y, -- dual inputs
z, -- single word result
c_in, -- carry in
c_out, -- carry out
lt, eq, gt, -- comparison indicator bits
overflow, -- overflow indicator
c); -- operation select
*/



module alu (x, y,z,c_in,c_out,lt, eq, gt,overflow,c);

input[3:0] c;
input[15:0] x,y;
output[15:0] z;
output reg c_out,lt,eq,gt,overflow,c_in;
reg [15:0] temp,temp1;
integer i;
reg [14:0] cin;
reg [16:0] cout;
always  
begin
///setting the comparison bits
if(x<y)
lt=1;
else if(x==y)
eq=1'b1;
else if(x>y)
gt=1'b1;
end
////

case(c)//alu operations
3'b000://and
begin
temp = x && y;
end
3'b001://or
begin
temp=x || y;
end
3'b010://addition
begin
temp=x+y;
end
3'b011://substraction
begin

for(i=0;i<16;i=i+1)
begin
  if(y[i]==1'b0)
  temp1[i]=1'b1;
  else if(y[i]==1'b1)
  temp1[i]=1'b0;
end
  temp1=temp1+1'b1;
  temp=temp1+x;
end
3'b111://set on less than
begin
begin
if(x<y)
z=1;
end
end


endcase
end

endmodule

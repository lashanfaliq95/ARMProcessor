module stimulus;
reg[3:0] c;
reg [15:0] x,y;
wire[15:0] z;
wire c_out,lt,eq,gt,overflow,c_in;
alu my_alu(x, y,z,c_in,c_out,lt, eq, gt,overflow,c);


initial
begin

y=16'b0000000000000111;x=16'b0000000011100000; c=3'b010;

#1 $display("%d %b %b %b %d %d %d",z,lt,eq,gt,x,y,overflow,c_in,c_out);

end

endmodule


module alu (x, y,z,c_in,c_out,lt, eq, gt,overflow,c);

input[3:0] c;
input [15:0] x,y;
output reg[15:0] z;
output reg c_out,lt,eq,gt,overflow,c_in;
reg [15:0] temp,temp1,cin;
integer i;

reg [16:0] cout;

always@(x,y) begin
//getting the comparison bits
if(x<y)
lt=1'b1;
else if(x==y)
eq=1'b1;
else if(x>y)
gt=1'b1;

//gettin c in 
temp=x;
temp1=y;
temp[15]=0;
temp1[15]=0;
 cin=temp+temp1;
 if(cin[15]==1'b1)
 c_in=1;
 else if(cin[15]==1'b0)
 c_in=0;
//getting c out
cout=x+y;
 if(cout[16]==1'b1)
 c_out=1;
 else if(cout[16]==1'b0)
 c_out=0;
//overflow bit
overflow=cin^cout;

//alu operations
case(c)
3'b000://and
z = x && y;
3'b001://or
z=x || y;
3'b010://addition
z=x+y;
3'b011://substraction
begin
for(i=0;i<16;i=i+1)
begin
  if(y[i]==1'b0)
  temp[i]=1'b1;
  else if(y[i]==1'b1)
  temp[i]=1'b0;
end
  temp=temp+1'b1;
  z=temp+x;
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

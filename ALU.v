module stimulus;

wire[15:0] z;
reg [15:0] x,y;
wire c_in,c_out,lt,eq,gt,overflow;
reg[2:0] c;

ALU alu(x,y,z,c,c_in,c_out,lt,eq,gt,overflow);

initial
begin

x=16'b0000000000001011; y=16'b0000000000010011; c=3'b000;
		#1 $display("AND x= %b, y= %b, lt= %b gt= %b, eq= %b\n z= %b cin= %b, cout= %b, overflow= %b\n",x,y,lt,gt,eq,z,c_in,c_out,overflow);

x=16'b0000000000010011; y=16'b0000000000001011; c=3'b001;
		#1 $display("OR x= %b, y= %b, lt= %b gt= %b, eq= %b\n z= %b cin= %b, cout= %b, overflow= %b\n",x,y,lt,gt,eq,z,c_in,c_out,overflow);
		
x=16'b0000000000010011; y=16'b0000000000001011; c=3'b010;
		#1 $display("ADD x= %b, y= %b, lt= %b gt= %b, eq= %b\n z= %b cin= %b, cout= %b, overflow= %b\n",x,y,lt,gt,eq,z,c_in,c_out,overflow);

x=16'b0000000000000011; y=16'b0000000000000001; c=3'b011;
		#1 $display("SUB  x= %b, y= %b, lt= %b gt= %b, eq= %b\n z= %b cin= %b, cout= %b, overflow= %b\n",x,y,lt,gt,eq,z,c_in,c_out,overflow);

x=16'b0000000000001011; y=16'b0000000000010011; c=3'b111;
		#1 $display("set on lt  x= %b, y= %b, lt= %b gt= %b, eq= %b\n z= %b cin= %b, cout= %b, overflow= %b\n",x,y,lt,gt,eq,z,c_in,c_out,overflow);

end


endmodule


//===============================================================

module ALU( x,y,z,c,c_in,c_out,lt,eq,gt,overflow);

input[15:0] x,y;
input[2:0] c;
output reg[15:0] z;
output reg c_in,c_out,lt,eq,gt,overflow;
reg[15:0] temp1,temp2,tempx,tempy,cin;
reg[16:0] temp3;

always@(x,y)
begin

if(x<y)
begin lt=1'b1; gt=1'b0; eq=1'b0; end
  
else if(x>y)
begin lt=1'b0; gt=1'b1; eq=1'b0; end

else if(x==y)
begin lt=1'b0; gt=1'b0; eq=1'b1; end

tempx = x;
tempy = y;
tempx[15]=0;               //find c_in
tempy[15]=0;
cin = tempx + tempy;
if(cin[15]==0) c_in = 0;
else if(cin[15]==1) c_in=1;

temp3 = x+y;
if(temp3[16]==1) c_out = 1;
else if(temp3[16] == 0) c_out = 0;

overflow=c_in^c_out;



if(c==3'b000)
z=x&y;


else if(c==3'b001)
z=x|y;

else if(c==3'b010)
z=x+y;

else if(c==3'b011)
begin
temp1=x;

temp2=(~y+ 16'b1);

z=temp1 + temp2;
end

else if(c==3'b111)
if(x<y) z=1;
else if(x>=y) z=0;



end
endmodule

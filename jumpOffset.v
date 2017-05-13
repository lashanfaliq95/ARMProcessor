module stimulus;
reg [11:0] offset;
wire [15:0] output_address;
reg [15:0] current_address;
reg clock;
jumpoffset jump(offset,current_address,output_address,clock);

initial begin
clock=0;
clock=1;
offset=12'b000000000010;
current_address=16'b1101000011000011;
#5 $display("output should be 1100000000000100");
#5 $display("offset=%b current_address=%b output=%b",offset,current_address,output_address);
end
endmodule


module jumpoffset(offset,current_address,output_address,clock);
input [11:0] offset;
input [15:0] current_address;
output reg [15:0] output_address;
reg [12:0] temp;
input clock;
integer i;
always@(posedge clock) begin
temp=offset<<1; //multiplying by 2
for(i=0;i<16;i=i+1)
begin
if(i<13)
output_address[i]=temp[i];
else
output_address[i]=current_address[i];//appending the first 3 didgits of current address of program counter to output address
end
end
endmodule

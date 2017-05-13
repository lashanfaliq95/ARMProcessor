module pc(input_address,current_address);//programme counter
input[15:0] input_address;
output reg[15:0] current_address;
initial begin
if(input_address>0)
 current_address=input_address;
else
  current_address=0;
end
endmodule

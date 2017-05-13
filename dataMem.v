module stimulus;


reg[15:0] address,write_data;
reg mem_read,mem_write,clock;
wire [15:0] read_data;
 data_memory mymem(address,read_data,write_data,mem_read,mem_write,clock);

initial begin
clock=0;

address=16'd5;
write_data=16'b0011001100111100;
mem_write=1;
mem_read=0;
clock=1;
   $display("store");
#5 $display("address=%b write_data=%b mem_write=%d mem_read=%d read_data=%b",address,write_data,mem_write,mem_read,read_data);
clock=0;
mem_read=1;
mem_write=0;
address=16'd5;
clock=1;
    $display("load");
#10 $display("address=%b write_data=%b mem_write=%d mem_read=%d read_data=%b",address,write_data,mem_write,mem_read,read_data);


end


endmodule

module data_memory(address,read_data,write_data,mem_read,mem_write,clock);
input[15:0] address,write_data;
input mem_read,mem_write,clock;
reg[15:0] registerFile[255:0];//this is not the max possible number
output reg[15:0] read_data;
always@(posedge clock) begin
if(mem_read==1)
read_data=registerFile[address];
if(mem_write==1)
registerFile[address]=write_data;
end
endmodule

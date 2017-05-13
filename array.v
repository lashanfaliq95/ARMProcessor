module toplevel;

// This creates an array of four 16 bit registers
reg [15:0] register_file [3:0];

integer i;

initial
begin
	//write to each register
	for(i=0;i<4;i=i+1)
	begin
		#5 register_file [i] = i[15:0];
		$display(register_file [i]);
	end
end

endmodule


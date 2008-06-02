// direction: 0 pushes, 1 pops.
module simple_stack(in, out, clk, direction, enable);
	input [15:0] in;
	output [15:0] out;
	input clk, enable, direction;
	
	reg [15:0] stack[0:27];
	integer i;
	
	assign out = stack[0];
	
	always @(posedge clk) begin
		if (enable && ~direction) begin  // push
			for (i = 0; i < 27; i = i + 1)
				stack[i+1] <= stack[i];
			stack[0] <= in;
		end else if (enable && direction) begin  // pop
			for (i = 0; i < 27; i = i + 1)
				stack[i] <= stack[i+1];
		end
	end
endmodule
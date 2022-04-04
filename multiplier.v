//booth-1, bug in output width

module multiplier(A,B,M);
	parameter width = 8;
	input [width-1:0] A,B; // 1 bit for sign + 7 bit for number
	output [2*width-1:0] M; // 1 bit for sign + 14 bit for number
	
	wire [width:0] xx,_x; // 2 bit for sign + 7 bit for number
	wire [width:0] partial_product[0:15]; // 2 bit for sign + 7 bit for number
	wire [width-1:0] multiplicator[0:7]; // 1 bit for sign + 7 bit for number
	wire extra[0:7];

	assign xx = {A[7],A};
	assign _x = ~xx+1'b1;
	assign partial_product[0] = 0;
	assign multiplicator[0] = B;
	assign extra[0] = 0;
	
	add(partial_product[0],xx,_x,multiplicator[0],extra[0],partial_product[1]);
	move(partial_product[1],multiplicator[0],partial_product[2],multiplicator[1],extra[1]);
	
	add(partial_product[2],xx,_x,multiplicator[1],extra[1],partial_product[3]);
	move(partial_product[3],multiplicator[1],partial_product[4],multiplicator[2],extra[2]);
	
	add(partial_product[4],xx,_x,multiplicator[2],extra[2],partial_product[5]);
	move(partial_product[5],multiplicator[2],partial_product[6],multiplicator[3],extra[3]);
	
	add(partial_product[6],xx,_x,multiplicator[3],extra[3],partial_product[7]);
	move(partial_product[7],multiplicator[3],partial_product[8],multiplicator[4],extra[4]);
	
	add(partial_product[8],xx,_x,multiplicator[4],extra[4],partial_product[9]);
	move(partial_product[9],multiplicator[4],partial_product[10],multiplicator[5],extra[5]);
	
	add(partial_product[10],xx,_x,multiplicator[5],extra[5],partial_product[11]);
	move(partial_product[11],multiplicator[5],partial_product[12],multiplicator[6],extra[6]);
	
	add(partial_product[12],xx,_x,multiplicator[6],extra[6],partial_product[13]);
	move(partial_product[13],multiplicator[6],partial_product[14],multiplicator[7],extra[7]);
	
	add(partial_product[14],xx,_x,multiplicator[7],extra[7],partial_product[15]);
	
	cut(partial_product[15],multiplicator[7],M);
endmodule


module add
	#(parameter width = 8)
	(input [width:0] partial_product,xx,_x,
	input [width-1:0] multiplicator,
	input extra,
	output [width:0] result);
	
	wire [width:0] r1,r2;
	
	assign r1 = (extra==multiplicator[0]) ? 0 : xx;
	assign r2 = (!extra&multiplicator[0]) ? _x : r1;
	
	assign result = partial_product + r2;
endmodule


module move
	#(parameter width = 8)
	(input [width:0] partial_product_in,
	input [width-1:0] multiplicator_in,
	output [width:0] partial_product_out,
	output [width-1:0] multiplicator_out,
	output extra_out);
	
	assign extra_out = multiplicator_in[0];
	assign multiplicator_out = {partial_product_in[0],multiplicator_in[7:1]};
	assign partial_product_out = {partial_product_in[8],partial_product_in[8:1]};
endmodule


module cut
	#(parameter width = 8)
	(input [width:0] partial_product,
	input [width-1:0] multiplicator,
	output [2*width-1:0] out);
	
	assign out = {partial_product[width-1:0],multiplicator[7:1]};
endmodule
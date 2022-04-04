
module tb_multi_seq();

    reg clk;
	reg rst_n;
	 
	reg start;
    reg [7:0]mul_A;
    reg [7:0]mul_B;

    wire done;
    wire [15:0]Product;
	 
   always #10 clk = ~clk;
    initial begin      
        rst_n = 0; 	    
		clk = 1;
		#10; 
		rst_n = 1;
	 end
  booth_mult#(.D_IN(8)) 
	U1 (
	    .clk(clk),
		.rst_n(rst_n),
		.start(start),
	    .mul_A(mul_A),
	    .mul_B(mul_B),
		.done(done),
	    .Product(Product)
    );
	 /***********************************/
	reg [3:0]i;
    always @ ( posedge clk or negedge rst_n )
        if( !rst_n )
            begin
				i <= 4'd0;
				start <= 1'b0;
                mul_A <= 8'd0;
				mul_B <= 8'd0;			 
            end				
		else 
			case( i )
				0: // mul_A = 10 , mul_B = 2
				if( done ) begin start <= 1'b0; i <= i + 1'b1; end
				else begin mul_A <= 8'd10; mul_B <= 8'd2; start <= 1'b1; end
				
				1: // mul_A = 2 , mul_B = 10
				if( done ) begin start <= 1'b0; i <= i + 1'b1; end
				else begin mul_A <= 8'd2; mul_B <= 8'd10; start <= 1'b1; end
				
				2: // mul_A = 11 , mul_B = -5
				if( done ) begin start <= 1'b0; i <= i + 1'b1; end
				else begin mul_A <= 8'd11; mul_B <= 8'b11111011; start <= 1'b1; end
				
				3: // mul_A = -5 , mul_B = -11
				if( done ) begin start <= 1'b0; i <= i + 1'b1; end
				else begin mul_A <= 8'b11111011; mul_B <= 8'b11110101; start <= 1'b1; end
				
				4: begin i <= 4'd4; end
			endcase
 endmodule


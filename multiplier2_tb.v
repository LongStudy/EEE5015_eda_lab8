
module tb_multi_seq();

    reg clk;
	reg rst_n;
	 
    reg [7:0]A;
    reg [7:0]B;

    wire done;
    wire [15:0]M;
	 
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
	    .A(A),
	    .B(B),
		.done(done),
	    .M(M)
    );

	reg [3:0]i;
    always @ ( posedge clk or negedge rst_n )
        if( !rst_n )
            begin
				i <= 4'd0;
                A <= 8'd0;
				B <= 8'd0;			 
            end				
		else 
			case( i )
				0: // A = 10 , B = 2
				if( done ) begin i <= i + 1'b1; end
				else begin A <= 127; B <= -127; end
				
				1: // A = 2 , B = 10
				if( done ) begin i <= i + 1'b1; end
				else begin A <= -128; B <= 127; end
				
				2: // A = 11 , B = -5
				if( done ) begin i <= i + 1'b1; end
				else begin A <= -128; B <= -128; end
				
				3: // A = -5 , B = -11
				if( done ) begin i <= i + 1'b1; end
				else begin A <= 8'b11111011; B <= 8'b11110101; end
				
				4: begin i <= 4'd4; end
			endcase

    initial begin
        #2000 $finish;
    end

    initial begin
        $vcdpluson; 
    end
 endmodule



module tb_multi_seq();

	parameter width=8;
    reg clk;
	reg rst_n;
	 
    reg [width-1:0]A;
    reg [width-1:0]B;

    wire done;
    wire [2*width-1:0]M;
	 
   	always #10 clk = ~clk;
	
    initial begin      
        rst_n = 0;
		clk = 0;
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
				i <= 0;
                A <= 1;
				B <= 1;
            end
		else 
			case( i )
				0:
				if( done ) begin 
					i <= i + 1'b1;
					A <= 1; B <= -1; 
				end

				1:
				if( done ) begin 
					i <= i + 1'b1;
					A <= -128; B <= 127; 
				end
				
				2:
				if( done ) begin 
					i <= i + 1'b1;
					A <= -128; B <= -128;
				end
				
				3:
				if( done ) begin 
					i <= i + 1'b1;
					A <= 127; B <= 127;
				end
			
				default: begin i <= 4'b1111; end
			endcase

    initial begin
        #2000 $finish;
    end

    initial begin
        $vcdpluson; 
    end
 endmodule



module tb_multi_seq();

	parameter width=8;
    reg clk;
	reg rst_n;
	reg en;
	 
    reg signed[width-1:0]A;
    reg signed[width-1:0]B;

    wire done;
    wire signed[2*width-1:0]M;

   	parameter CLK_PERIOD = 20;
    initial begin
        clk = 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end
	
    initial begin      
        rst_n = 0;
		#10;
		rst_n = 1;
	end

	booth_mult#(.width(8)) 
	U1 (
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.A(A),
		.B(B),
		.done(done),
		.M(M)
	);

    always @ (posedge rst_n or negedge rst_n) begin
        if (!rst_n) begin
        $display("%t:%m: resetting ......", $time); 
        end
        else begin
        $display("%t:%m: resetting finish", $time); 
        end
    end

	initial begin
		$monitor("@ time=%0t,  A=%d, B=%d, M=%d",$time, A, B, M);
	end

    always @ ( posedge clk or negedge rst_n )
	if( !rst_n )
            begin
				i <= 0;
				en <= 0;
                A <= -128;
				B <= -128;			 
            end				
	else 
		case( i )
			0:
			if( done ) begin en <= 0; i <= 0; if (M != A*B) $display("Error: M=%d", M); end
			else if( A != 127) begin A <= A + 1; B <= B ; en <= 1; end
			else begin A <= 0; B <= B + 1; en <= 1; end
			
			1:
			if( done ) begin en <= 0; i <= i + 1'b1; if (M != -1) $display("Error: M=%d", M); end
			else begin A <= 1; B <= -1; en <= 1; end
			
			2:
			if( done ) begin en <= 0; i <= i + 1'b1; if (M != 1) $display("Error: M=%d", M);end
			else begin A <= -1; B <= -1; en <= 1; end
			
			3:
			if( done ) begin en <= 0; i <= i + 1'b1; end
			else begin A <= -10; B <= -100; en <= 1; end
			
			4:
			if( done ) begin en <= 0; i <= i + 1'b1; end
			else begin A <= 10; B <= -5; en <= 1; end
			
			5:
			if( done ) begin en <= 0; i <= i + 1'b1; end
			else begin A <= 5; B <= 8; en <= 1; end
			
			6:
			if( done ) begin en <= 0; i <= i + 1'b1; end
			else begin A <= -128; B <= -128; en <= 1; end

			7:
			if( done ) begin en <= 0; i <= i + 1'b1; end
			else begin A <= -128; B <= 127; en <= 1; end

			8:
			if( done ) begin en <= 0; i <= i + 1'b1; end
			else begin A <= 100; B <= 127; en <= 1; end

			default: begin i <= { 32{1} };end
		endcase

    initial begin
        $vcdpluson; 
    end
 endmodule


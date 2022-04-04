
module tb_multi_seq();

	parameter width=8;
    reg clk;
	reg rst_n;
	reg en;
	 
    reg signed[width-1:0]A;
    reg signed[width-1:0]B;

    wire done;
    wire signed[2*width-1:0]M;

	reg [31:0]i;
	reg addflag;

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
			if( done ) begin en <= 0; addflag=0; if (M != A*B) $display("Error: A=%d, B=%d, A*B=%d, M=%d", A, B, A*B, M); end
			else if( addflag ) begin  end
			else if(( A == 127 )&&( B == 127 )) begin en <= 0; i <= { 32{1'b1} }; end
			else if( A == 127) begin A <= -128; B <= B + 1; en <= 1;addflag=1; end
			else begin A <= A + 1; B <= B ; en <= 1;addflag=1; end

			default: begin i <= { 32{1'b1} }; $finish; end
		endcase

    initial begin
        $vcdpluson; 
    end
 endmodule


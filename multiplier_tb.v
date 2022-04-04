
module tb_multi_seq();

	parameter width=8;
    reg clk;
	reg rst_n;
	reg en;
	 
    reg signed[width-1:0]A;
    reg signed[width-1:0]B;

    wire done;
    wire signed[2*width-1:0]M;

	reg	signed[width-1:0]i;
	reg	signed[width-1:0]j;

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
                A <= 0;
				B <= 0;			 
            end				
	else begin
		for (i={ width{1} }; i<={ 0, width-1{1} }; i=i+1) begin
			for(j={ width{1} }; j<={ 0, width-1{1} }; j=j+1)begin
				if( done ) begin en <= 0; i <= i + 1'b1; if (M != i*j) $display("Error: M=%d", M); end
				else begin A <= i; B <= j; en <= 1; end
			end
		end
	$finish;
	end


    initial begin
        $vcdpluson; 
    end
 endmodule


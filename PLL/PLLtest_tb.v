module testbench;

    reg clk;
    always #5 clk = (clk === 1'b0);

    wire led1, led2, led3, led4, led5;

    PLLtest uut (
        .CLK(clk),
        .LED1(led1),
        .LED2(led2),
        .LED3(led3),
        .LED4(led4),
        .LED5(led5)
    );

    initial begin
        #1000; // Wait a long time in simulation units (adjust as needed).
        $display("Caught by trap");
        $stop;
    end

    reg [4095:0] vcdfile;

    initial begin
        if ($value$plusargs("vcd=%s", vcdfile)) begin
            $dumpfile(vcdfile);
            $dumpvars(0, testbench);
        end
    end

endmodule

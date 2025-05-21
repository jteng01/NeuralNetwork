`timescale 1ns/1ps

module tb_relu_neuron;

    parameter PREV_LAYER_OUTPUTS = 3;

    logic signed [31:0] data_inputs [0:PREV_LAYER_OUTPUTS-1];
    logic signed [31:0] weights     [0:PREV_LAYER_OUTPUTS-1];
    logic signed [31:0] bias;
    logic signed [31:0] data_output;

    relu_neuron #(
        .PREV_LAYER_OUTPUTS(PREV_LAYER_OUTPUTS)
    ) uut (
        .data_inputs(data_inputs),
        .weights(weights),
        .bias(bias),
        .data_output(data_output)
    );

    initial begin
        data_inputs[0] = 32'sd16777216;  // 1.0 in Q7.24
        data_inputs[1] = 32'sd8388608;   // 0.5
        data_inputs[2] = 32'sd4194304;   // 0.25

        weights[0] = 32'sd8388608;       // 0.5
        weights[1] = 32'sd8388608;       // 0.5
        weights[2] = 32'sd8388608;       // 0.5

        bias = 32'sd0;

        #10;

        $display("Output (Q7.24 signed): %d", data_output);

        if ((data_output > 32'sd14600000) && (data_output < 32'sd14750000))
            $display("Test passed");
        else
            $display("Test failed");

        bias = -32'sd16777216; // -1.0
        #10;
        $display("Output with negative total (should be 0): %d", data_output);
        if (data_output == 0)
            $display("ReLU negative test passed");
        else
            $display("ReLU negative test failed");

        $finish;
    end

endmodule
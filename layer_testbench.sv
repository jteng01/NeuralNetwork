`timescale 1ns/1ps

module tb_layer;

    parameter NEURONS = 2;
    parameter PREV_LAYER_OUTPUTS = 3;

    logic signed [31:0] data_inputs [0:PREV_LAYER_OUTPUTS-1];
    logic signed [31:0] weights     [0:NEURONS-1][0:PREV_LAYER_OUTPUTS-1];
    logic signed [31:0] biases      [0:NEURONS-1];
    logic signed [31:0] data_outputs[0:NEURONS-1];

    layer #(
        .NEURONS(NEURONS),
        .PREV_LAYER_OUTPUTS(PREV_LAYER_OUTPUTS)
    ) uut (
        .data_inputs(data_inputs),
        .weights(weights),
        .biases(biases),
        .data_outputs(data_outputs)
    );

    initial begin
        data_inputs[0] = 32'sd16777216;  // 1.0
        data_inputs[1] = 32'sd8388608;   // 0.5
        data_inputs[2] = 32'sd4194304;   // 0.25

        weights[0][0] = 32'sd8388608;   // 0.5
        weights[0][1] = 32'sd8388608;
        weights[0][2] = 32'sd8388608;
        biases[0]     = 32'sd0;

        weights[1][0] = 32'sd16777216;  // 1.0
        weights[1][1] = 32'sd0;
        weights[1][2] = -32'sd8388608;  // -0.5
        biases[1]     = 32'sd4194304;   // 0.25

        #10;

        $display("Neuron 0 output (Q7.24 signed): %d", data_outputs[0]);
        $display("Neuron 1 output (Q7.24 signed): %d", data_outputs[1]);

        if ((data_outputs[0] > 32'sd14600000) && (data_outputs[0] < 32'sd14750000))
            $display("Neuron 0 test passed");
        else
            $display("Neuron 0 test failed");

        if ((data_outputs[1] > 32'sd18800000) && (data_outputs[1] < 32'sd19000000))
            $display("Neuron 1 test passed");
        else
            $display("Neuron 1 test failed");

        $finish;
    end

endmodule

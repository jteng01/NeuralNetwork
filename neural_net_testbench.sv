`timescale 1ns/1ps

module tb_mlp_neural_net;

    parameter INPUTS  = 784;
    parameter OUTPUTS = 10;

    logic signed [31:0] data_inputs  [0:INPUTS-1];
    logic signed [31:0] data_outputs [0:OUTPUTS-1];

    mlp_neural_net #(
        .INPUTS(INPUTS),
        .OUTPUTS(OUTPUTS)
    ) uut (
        .data_inputs(data_inputs),
        .data_outputs(data_outputs)
    );

    initial begin
        $readmemh("mnist_sample_input.mem", data_inputs);

        #10;

        $display("MLP Output values (Q7.24 fixed-point):");
        for (int i = 0; i < OUTPUTS; i++) begin
            $display("Output[%0d] = %d", i, data_outputs[i]);
        end

        $finish;
    end

endmodule

module output_layer #(
    parameter int N_OUTPUTS,
    parameter int PREV_LAYER_OUTPUTS
)(

);



endmodule

module hidden_layer #(
    parameter int NEURONS = 1,
    parameter int PREV_LAYER_OUTPUTS = 1
)(
    input  logic [31:0] data_inputs [0:PREV_LAYER_OUTPUTS-1],
    input  logic [31:0] weights     [0:NEURONS-1][0:PREV_LAYER_OUTPUTS-1],
    input  logic [31:0] biases      [0:NEURONS-1],
    output logic [31:0] data_outputs[0:NEURONS-1]
);

    genvar i;
    generate
        for (i = 0; i < NEURONS; i++) begin : neuron_array
            neuron #(
                .PREV_LAYER_OUTPUTS(PREV_LAYER_OUTPUTS)
            ) n (
                .data_inputs(data_inputs),
                .weights(weights[i]),
                .bias(biases[i]),
                .data_output(data_outputs[i])
            );
        end
    endgenerate

endmodule

module neuron #(
    parameter int PREV_LAYER_OUTPUTS = 1
)(
    input  logic [31:0] data_inputs [0:PREV_LAYER_OUTPUTS-1],
    input  logic [31:0] weights     [0:PREV_LAYER_OUTPUTS-1],
    input  logic [31:0] bias,
    output logic [31:0] data_output
);

    logic [31:0] multiplied_outputs [0:PREV_LAYER_OUTPUTS-1];
    logic [31:0] sum;
    logic signed [31:0] total;


    genvar i;
    generate
        for (i = 0; i < PREV_LAYER_OUTPUTS; i++) begin : dot_product_array
            signed_7_24_multiplier mult (
                .value1(data_inputs[i]),
                .value2(weights[i]),
                .result(multiplied_outputs[i])
            );
        end
    endgenerate

    always_comb begin
        sum = 32'd0;
        for (int j = 0; j < PREV_LAYER_OUTPUTS; j++) begin
            sum += multiplied_outputs[j];
        end

        total = sum + bias;

        if (total > 0)
            data_output = total;
        else
            data_output = 32'd0;
    end

endmodule


module signed_7_24_multiplier (
    input  logic [31:0] value1,
    input  logic [31:0] value2,
    output logic [31:0] result
);
    logic signed [31:0] val1_signed;
    logic signed [31:0] val2_signed;
    logic signed [63:0] product;

    always_comb begin
        val1_signed = value1;
        val2_signed = value2;
        product     = val1_signed * val2_signed;
        result      = product[55:24];
    end
endmodule

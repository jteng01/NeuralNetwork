module mlp_neural_net_example #(
    parameter int INPUTS  = 9,
    parameter int OUTPUTS = 2
) (
    input  logic signed [31:0] data_inputs  [0:INPUTS-1],
    output logic signed [31:0] data_outputs [0:OUTPUTS-1]
);

    //Layer 0: 9 inputs, 8 neurons
    localparam logic signed [31:0] layer0_weights [0:7][0:8] = '{
        '{32'sd4194304, -32'sd8388608, 32'sd1258291, 32'sd2097152, 32'sd1048576, 32'sd524288, 32'sd0, -32'sd2097152, 32'sd3145728},
        '{-32'sd4194304, 32'sd8388608, 32'sd1048576, 32'sd524288, -32'sd1048576, 32'sd0, 32'sd1572864, 32'sd3145728, 32'sd2097152},
        '{32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576},
        '{32'sd1258291, -32'sd1258291, 32'sd3145728, -32'sd3145728, 32'sd2097152, 32'sd1048576, -32'sd1048576, 32'sd524288, -32'sd524288},
        '{32'sd4194304, 32'sd0, 32'sd1048576, -32'sd1048576, 32'sd524288, 32'sd262144, -32'sd262144, 32'sd131072, -32'sd131072},
        '{32'sd1048576, 32'sd2097152, 32'sd0, 32'sd0, -32'sd1048576, 32'sd0, -32'sd2097152, 32'sd1048576, 32'sd2097152},
        '{-32'sd2097152, -32'sd2097152, -32'sd2097152, -32'sd2097152, -32'sd2097152, -32'sd2097152, -32'sd2097152, -32'sd2097152, -32'sd2097152},
        '{32'sd524288, 32'sd262144, 32'sd131072, 32'sd65536, 32'sd32768, 32'sd16384, 32'sd8192, 32'sd4096, 32'sd2048}
    };

    localparam logic signed [31:0] layer0_biases [0:7] = '{
        32'sd1048576, -32'sd2097152, 32'sd524288, 32'sd0,
        32'sd3145728, -32'sd1048576, 32'sd1572864, 32'sd262144
    };

    //Layer 1: 8 inputs, 4 neurons
    localparam logic signed [31:0] layer1_weights [0:3][0:7] = '{
        '{32'sd2097152, -32'sd1048576, 32'sd524288, -32'sd524288, 32'sd262144, -32'sd262144, 32'sd131072, -32'sd131072},
        '{32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576, 32'sd1048576},
        '{32'sd3145728, -32'sd3145728, 32'sd1048576, 32'sd524288, -32'sd1048576, -32'sd524288, 32'sd262144, -32'sd262144},
        '{-32'sd2097152, 32'sd2097152, -32'sd2097152, 32'sd2097152, -32'sd2097152, 32'sd2097152, -32'sd2097152, 32'sd2097152}
    };

    localparam logic signed [31:0] layer1_biases [0:3] = '{
        32'sd0, 32'sd1048576, -32'sd1048576, 32'sd524288
    };

    //Layer 2: 4 inputs, 2 neurons
    localparam logic signed [31:0] layer2_weights [0:1][0:3] = '{
        '{32'sd1048576, 32'sd524288, -32'sd524288, 32'sd262144},
        '{-32'sd1048576, 32'sd1048576, -32'sd1048576, 32'sd1048576}
    };

    localparam logic signed [31:0] layer2_biases [0:1] = '{
        32'sd2097152, -32'sd1048576
    };

    //Intermediate outputs
    logic signed [31:0] layer0_out [0:7];
    logic signed [31:0] layer1_out [0:3];

    //Instantiate Layer 0
    layer #(
        .NEURONS(8),
        .PREV_LAYER_OUTPUTS(9)
    ) layer0 (
        .data_inputs(data_inputs),
        .weights(layer0_weights),
        .biases(layer0_biases),
        .data_outputs(layer0_out)
    );

    //Instantiate Layer 1
    layer #(
        .NEURONS(4),
        .PREV_LAYER_OUTPUTS(8)
    ) layer1 (
        .data_inputs(layer0_out),
        .weights(layer1_weights),
        .biases(layer1_biases),
        .data_outputs(layer1_out)
    );

    //Instantiate Layer 2
    layer #(
        .NEURONS(2),
        .PREV_LAYER_OUTPUTS(4)
    ) layer2 (
        .data_inputs(layer1_out),
        .weights(layer2_weights),
        .biases(layer2_biases),
        .data_outputs(data_outputs)
    );

endmodule
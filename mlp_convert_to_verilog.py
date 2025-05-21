import ast

def float_to_q7_24(value: float) -> int:
    scale = 2**24
    fixed_val = int(round(value * scale))
    if fixed_val >= 2**31:
        fixed_val = 2**31 - 1
    elif fixed_val < -2**31:
        fixed_val = -2**31
    return fixed_val

def sv_int_literal(val: int) -> str:
    if val < 0:
        return f"-32'sd{abs(val)}"
    else:
        return f"32'sd{val}"

def load_neurons_from_file(filepath):
    with open(filepath, "r") as f:
        content = f.read()

    parts = content.split("\n\n")
    weights_str = parts[0].split("=", 1)[1].strip()
    biases_str = parts[1].split("=", 1)[1].strip()

    weights = ast.literal_eval(weights_str)
    biases = ast.literal_eval(biases_str)

    return weights, biases

def write_module_definition(weights, biases):
    INPUTS = len(weights[0][0])
    OUTPUTS = len(weights[-1])
    return f"""module mlp_neural_net #(
    parameter int INPUTS  = {INPUTS},
    parameter int OUTPUTS = {OUTPUTS}
) (
    input  logic signed [31:0] data_inputs  [0:INPUTS-1],
    output logic signed [31:0] data_outputs [0:OUTPUTS-1]
);
"""

def write_parameters(weights, biases):
    code = ""
    for layer_idx in range(len(weights)):
        n_neurons = len(weights[layer_idx])
        n_inputs = len(weights[layer_idx][0])
        code += f"\n    //Layer {layer_idx}: {n_inputs} inputs, {n_neurons} neurons\n"
        code += f"    localparam logic signed [31:0] layer{layer_idx}_weights [0:{n_neurons-1}][0:{n_inputs-1}] = '{{\n"

        for neuron_idx in range(n_neurons):
            line = "        '{"
            fixed_weights = [float_to_q7_24(w) for w in weights[layer_idx][neuron_idx]]
            line += ", ".join(sv_int_literal(w) for w in fixed_weights)
            line += "}"
            if neuron_idx != n_neurons - 1:
                line += ","
            code += line + "\n"
        code += "    };\n\n"

        code += f"    localparam logic signed [31:0] layer{layer_idx}_biases [0:{n_neurons-1}] = '{{\n        "
        fixed_biases = [float_to_q7_24(b) for b in biases[layer_idx]]
        code += ", ".join(sv_int_literal(b) for b in fixed_biases)
        code += "\n    };\n"
    return code

def write_intermediate_signals(weights, biases):
    code = "\n    //Intermediate outputs\n"
    for layer_idx in range(len(weights) - 1):
        n_neurons = len(weights[layer_idx])
        code += f"    logic signed [31:0] layer{layer_idx}_out [0:{n_neurons-1}];\n"
    return code

def write_layers_instantiation(weights, biases):
    code = "\n    //Instantiate Layers\n"
    for layer_idx in range(len(weights)):
        n_neurons = len(weights[layer_idx])
        if layer_idx == 0:
            prev_outputs = len(weights[layer_idx][0])
            code += f"    //Layer {layer_idx}\n"
            code += f"    layer #(\n"
            code += f"        .NEURONS({n_neurons}),\n"
            code += f"        .PREV_LAYER_OUTPUTS({prev_outputs})\n"
            code += f"    ) layer{layer_idx} (\n"
            code += f"        .data_inputs(data_inputs),\n"
            code += f"        .weights(layer{layer_idx}_weights),\n"
            code += f"        .biases(layer{layer_idx}_biases),\n"
            code += f"        .data_outputs(layer{layer_idx}_out)\n"
            code += f"    );\n\n"
        elif layer_idx == len(weights) - 1:
            prev_outputs = len(weights[layer_idx][0])
            code += f"    //Layer {layer_idx}\n"
            code += f"    layer #(\n"
            code += f"        .NEURONS({n_neurons}),\n"
            code += f"        .PREV_LAYER_OUTPUTS({prev_outputs})\n"
            code += f"    ) layer{layer_idx} (\n"
            code += f"        .data_inputs(layer{layer_idx - 1}_out),\n"
            code += f"        .weights(layer{layer_idx}_weights),\n"
            code += f"        .biases(layer{layer_idx}_biases),\n"
            code += f"        .data_outputs(data_outputs)\n"
            code += f"    );\n\n"
        else:
            prev_outputs = len(weights[layer_idx][0])
            code += f"    //Layer {layer_idx}\n"
            code += f"    layer #(\n"
            code += f"        .NEURONS({n_neurons}),\n"
            code += f"        .PREV_LAYER_OUTPUTS({prev_outputs})\n"
            code += f"    ) layer{layer_idx} (\n"
            code += f"        .data_inputs(layer{layer_idx - 1}_out),\n"
            code += f"        .weights(layer{layer_idx}_weights),\n"
            code += f"        .biases(layer{layer_idx}_biases),\n"
            code += f"        .data_outputs(layer{layer_idx}_out)\n"
            code += f"    );\n\n"
    code += "endmodule\n"
    return code

if __name__ == "__main__":
    weights_loaded, biases_loaded = load_neurons_from_file("mlp_weights_biases.txt")

    verilog_code = []
    verilog_code.append(write_module_definition(weights_loaded, biases_loaded))
    verilog_code.append(write_parameters(weights_loaded, biases_loaded))
    verilog_code.append(write_intermediate_signals(weights_loaded, biases_loaded))
    verilog_code.append(write_layers_instantiation(weights_loaded, biases_loaded))

    full_code = "\n".join(verilog_code)

    with open("mlp_neural_net_generated.sv", "w") as f:
        f.write(full_code)

    print("Verilog code generated and saved to mlp_neural_net_generated.sv")
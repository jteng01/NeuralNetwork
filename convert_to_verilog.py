import ast

def load_neurons_from_file(filepath):
    with open(filepath, "r") as f:
        content = f.read()

    parts = content.split("\n\n")
    weights_str = parts[0].split("=", 1)[1].strip()
    biases_str = parts[1].split("=", 1)[1].strip()

    weights = ast.literal_eval(weights_str)
    biases = ast.literal_eval(biases_str)

    return weights, biases


if __name__ == "__main__":

    weights_loaded, biases_loaded = load_neurons_from_file("mlp_weights_biases.txt")
    
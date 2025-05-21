# NeuralNetwork

A hybrid neural network implementation that combines Python-based training with SystemVerilog-based hardware simulation. This project demonstrates how a trained neural network (MLP or CNN) can be deployed on hardware using custom Verilog modules.

## 🚀 Features

- Train Multi-Layer Perceptrons (MLPs) in Python
- Export trained weights and biases for hardware use
- Automatically generate SystemVerilog modules from trained models
- Modular SystemVerilog components for neurons and layers
- Testbenches for validating functionality at the hardware level

## 📄 File Descriptions

- `training_MLP.py` – Trains an MLP and extracts the weights and biases into text files.
- `neurons_and_layers.sv` – Implements the hardware logic for neurons and layers using signed 7.24 fixed-point format.
- `mlp_convert_to_verilog.py` – Generates Verilog code by automatically instantiating layers, neurons, weights, and biases from trained model parameters.
- `mlp_neural_net_generated.sv` – The generated SystemVerilog module representing the full neural network (output from `mlp_convert_to_verilog.py`).

import tensorflow as tf
from tensorflow.keras import layers, models
from sklearn.model_selection import train_test_split
import numpy as np

if __name__ == "__main__":
    (X, y), (X_test, y_test) = tf.keras.datasets.mnist.load_data()

    X = X.astype("float32") / 255.0
    X_test = X_test.astype("float32") / 255.0

    X = np.expand_dims(X, -1)
    X_test = np.expand_dims(X_test, -1)

    X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)

    model = models.Sequential([
        layers.Conv2D(32, kernel_size=(3, 3), activation='relu', input_shape=(28, 28, 1)),
        layers.MaxPooling2D(pool_size=(2, 2)),
        layers.Conv2D(64, kernel_size=(3, 3), activation='relu'),
        layers.MaxPooling2D(pool_size=(2, 2)),
        layers.Flatten(),
        layers.Dense(64, activation='relu'),
        layers.Dense(10, activation='softmax')
    ])

    model.compile(optimizer='adam',
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    model.fit(X_train, y_train, epochs=5, validation_data=(X_val, y_val), verbose=2)

    loss, accuracy = model.evaluate(X_test, y_test)
    print(f"Test Accuracy: {accuracy:.4f}")

    weights = []
    biases = []
    for layer in model.layers:
        layer_weights = layer.get_weights()
        if layer_weights:
            weights.append(layer_weights[0].tolist())
            biases.append(layer_weights[1].tolist())

    with open("cnn_weights_biases.txt", "w") as f:
        f.write("weights = ")
        f.write(repr(weights))
        f.write("\n\n")
        f.write("biases = ")
        f.write(repr(biases))

from sklearn.datasets import fetch_openml
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, accuracy_score


if __name__ == "__main__":
    X, y = fetch_openml('mnist_784', version=1, return_X_y=True, as_frame=False)

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    X_train, X_test, y_train, y_test = train_test_split(
        X_scaled, y, test_size=0.2, random_state=42)

    mlp = MLPClassifier(hidden_layer_sizes=(16, 16), max_iter=20, alpha=1e-4,
                        solver='adam', verbose=True, random_state=1)
    mlp.fit(X_train, y_train)

    y_pred = mlp.predict(X_test)
    print("Accuracy:", accuracy_score(y_test, y_pred))
    print(classification_report(y_test, y_pred))

    weights = [weights.T.tolist() for weights in mlp.coefs_]
    biases = [bias.tolist() for bias in mlp.intercepts_]

    with open("mlp_weights_biases.txt", "w") as f:
        f.write("weights = ")
        f.write(repr(weights))
        f.write("\n\n")
        f.write("biases = ")
        f.write(repr(biases))

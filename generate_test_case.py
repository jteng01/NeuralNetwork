import matplotlib.pyplot as plt
from sklearn.datasets import fetch_openml
from sklearn.preprocessing import StandardScaler

def float_to_q7_24(value: float) -> int:
    fixed = int(round(value * (1 << 24)))
    return max(min(fixed, 2**31 - 1), -2**31)

def save_test_image(img, filename="mnist_sample_input.mem"):
    with open(filename, "w") as f:
        for val in img:
            fixed = float_to_q7_24(val)
            f.write(f"{fixed & 0xFFFFFFFF:08X}\n")

if __name__ == "__main__":
    X, y = fetch_openml('mnist_784', version=1, return_X_y=True, as_frame=False)
    X_scaled = StandardScaler().fit_transform(X)
    
    save_test_image(X_scaled[0])
    
    plt.imshow(X[0].reshape(28, 28), cmap='gray')
    plt.title(f"Original MNIST Sample #0 — Label: {y[0]}")
    plt.axis('off')
    plt.show()
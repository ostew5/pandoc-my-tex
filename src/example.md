# Example Document

## Math

Inline: $E = mc^2$, the mass-energy equivalence.

Display:

$$
\int_0^\infty e^{-x^2}\, dx = \frac{\sqrt{\pi}}{2}
$$

Matrix example:

$$
\mathbf{A} = \begin{pmatrix} a & b \\ c & d \end{pmatrix}
$$

## Code

Python:

```python
def fibonacci(n: int) -> int:
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

print([fibonacci(i) for i in range(10)])
```

Bash:

```bash
# Build and generate outputs
make all
```

## Mixed content

The function $f(x) = x^2 + 2x + 1 = (x+1)^2$ has a minimum at $x = -1$.

| Format | Engine    | Math      |
|--------|-----------|-----------|
| PDF    | xelatex   | Native    |
| HTML   | pandoc    | MathJax   |

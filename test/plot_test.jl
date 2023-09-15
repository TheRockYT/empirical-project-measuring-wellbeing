# This is a test for plotting with Julia (output: plot.svg)

using Plots

a(x) = sin(x)
b(x) = cos(x)


plot([a, b], 0, 2 * pi, title="Test Plot", xlabel="x", ylabel="y", label=["sin(x)" "cos(x)"])

savefig("plot.svg")

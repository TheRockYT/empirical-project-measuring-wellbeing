# This is a test for plotting with Julia (output: plot.svg)

using Plots

f(x) = sin(x)

plot(f, 0, 2 * pi)

savefig("plot.svg")

# HaltonSequences

This package provides a convenient interface to computing terms from individual or
multidimensional [Halton sequences](https://en.wikipedia.org/wiki/Halton_sequence). These
are low-discrepancy sequences widely applied in quasi-Monte Carlo methods. They are well
known to have shortcomings in moderate to high dimensions, however.

## Usage

The primary tools offered are the `Array`-like `Halton` and `HaltonPoint` types. These
generate on-demand values of individual or multidimensional sequences, respectively.

To make a `Halton` object, you provide a prime base. For example,
```@repl one
using HaltonSequences
h = Halton(2)
```

As you can see, you get a fairly long virtual `Vector` by default. However, values are
computed only when elements are accessed. To store values, `collect` them into an ordinary array.
```@repl one
collect( h[1:6] )
```

You can specify offsets from the sequence start, or a different length, using keywords.
You can also specify different `Real` types for the values.
```@repl one
Halton(2,start=64)[1]
```

```@repl one
Halton{Rational}(3,length=7)
```

To make a `HaltonPoint` object, give the dimension of the sequence values.
```@repl one
HaltonPoint(4)[1:6]
```

The sequence elements are vectors of the base element type. By default, the bases of the different
dimensions are chosen in order starting with 2. You may instead give a vector of prime bases.
```@repl one
HaltonPoint{Rational}([7,11,13],length=6)
```

---
stylesheet: example_flow
title: Comparison of Pre-interpolation Algorithms for k-Space regridding
authors: KC Erb, Ganesh Adluru, Srikant Kamesh Iyer, Devavrat Likhite, John A Roberts, and Edward DiBella[2]
affiliations:
  - UCAIR, University of Utah, Salt Lake, Utah, United States
  - Department of Radiology, University of Utah, Salt Lake, Utah, United States
---

# Formatting

You note sections in your poster with the # sign. 1 # is the largest section
size ## is next smallest ### next and so forth.

To make text *italic* use one star, for **bold** use two. Underlines are hard
to see on posters so if you _must_ use them it is done with underscores.

You can include super and subscripts in your text. Superscript is just like you expect
with a carat putting the rest of the characters following it up top: 10^21.
Subscripts don't have a shortcut so you will have to use tags: sub<sub>script</sub>.

You can make your text shine out with your accent color and weight with ==highlighting==.
And you can get a different accent style with `code text markers`.


# Sciency Things

You can use equations in your document via LaTeX. You'll need to have
`pdflatex` installed on your machine.

```
P = \frac{1}{\hbar \omega} \int ||D-gm||^2 dx
```


A figure is easy to include

```figure:fig1-a.png
  The caption goes in here. `2+2`
```

If you want to use a normal code block just leave off the figure keyword

```ruby
puts "Cool rad awesome!"
```

You can write up a spiffy table via normal markdown style

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |


Ooh and a fancy feature is the pullquote:

> This text will get pulled into its own quote if the template has a pullquote.

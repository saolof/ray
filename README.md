# The Ray Tracer Language Comparison

This is a GitHub repository hosting the code from the [Ray Tracer Language Comparison](http://www.ffconsultancy.com/languages/ray_tracer/)
that I wrote back in 2007.

## The benchmark

The original purpose of this project was, of course, to benchmark ray tracers written in a variety of different languages. In order to
create a fruitful comparison I decided to design several different versions of a non-trivial ray tracer and port each algorithm to each
language in order to provide more points for comparison.

The ray tracers are non-trivial because they employ hierarchical spherical bounding volumes in order to cull the search tree efficiently,
allowing programs under 100 lines line to draw scenes containing thousands or even millions of spheres.

The original ray tracer language comparison featured C++, Java, OCaml, Standard ML, Haskell, Common Lisp and Scheme. Today, newer languages
such as Rust, Swift and Julia are more popular and, therefore, of wider interest. I have ported the first (least optimised) version of this
ray tracer to Julia but the performance is awful.

Enjoy!

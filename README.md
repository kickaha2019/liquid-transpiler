# liquid-transpiler
Transpile [Liquid](https://shopify.github.io/liquid/) templates to a Ruby class for performance.

This is experimental code. The aim is to implement most of
[Liquid templates](https://shopify.github.io/liquid/tags/template/)
but not the *include* tag. However Liquid extensions are
not going to work out of the box, and 
[Drops](https://github.com/Shopify/liquid/wiki/Introduction-to-Drops)
are untested.

The tests take some template code and check that running it through
[Liquid](https://shopify.github.io/liquid/) and running it
through the transpiled code give the same result.  
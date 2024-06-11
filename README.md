# liquid-transpiler
Convert [Liquid](https://shopify.github.io/liquid/) templates to a Ruby class for performance.
The aim is to support what is specified at
[Liquid templates](https://shopify.github.io/liquid/tags/template/)
as far as possible, with the generated Ruby code giving the
same results as the templates executed through
the [Liquid Ruby gem](https://rubygems.org/gems/liquid/).

This *transpiler* is not suitable for a server context
which **Liquid** was
designed for. There are tests but there will be 
incompatibities with real use of **Liquid**.

## Using the transpiler

## Transpiler options

## Error handling

## Limitations and issues

but not the *include* tag. However Liquid extensions are
not going to work out of the box, and 
[Drops](https://github.com/Shopify/liquid/wiki/Introduction-to-Drops)
are untested.

## Testing
The tests take some template code and check that running it through
[Liquid](https://shopify.github.io/liquid/) and running it
through the transpiled code give the same result.  

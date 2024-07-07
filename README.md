# liquid-transpiler
An experimental converter of
[Liquid](https://shopify.github.io/liquid/) templates 
to Ruby code for performance.
This converter aims to support what is specified at
[Liquid templates](https://shopify.github.io/liquid/tags/template/)
as far as possible, with the generated Ruby code giving the
same results as the templates executed through
the [Liquid Ruby gem](https://rubygems.org/gems/liquid/).

This *transpiler* is not suitable for a server context
like [Shopify]() use **Liquid** in. In most 
environments like
[Jekyll](https://jekyllrb.com) or
[Bridgetown](https://www.bridgetownrb.com) the **Liquid**
implementations used have been extended with new tags etc
which the *transpiler* doesn't have.

There is a suite of tests but there will be 
incompatibities with real use of **Liquid** which can be
very forgiving as regards syntax and execution. Sometimes
what one might consider errors inside **Liquid** 
just result in empty text. 

Running the transpiled code may result in Ruby errors
being raised whereas **Liquid** prevents that.
In particular null values may cause exceptions, the
code assumes templates check for data being missing.

* [Using the transpiler](USAGE.md)
* [Issues and limitations](ISSUES.md)
* [Performance](PERFORMANCE.md)

## Testing
The tests take some template code and check that running it through
[Liquid](https://shopify.github.io/liquid/) and running it
through the transpiled code give the same result.  

# liquid-transpiler
Convert [Liquid](https://shopify.github.io/liquid/) templates to a Ruby class for performance.
The aim was to support what is specified at
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
incompatibities with real use of **Liquid** which is
very forgiving as regards syntax and execution. Sometimes
what one might consider errors inside **Liquid** 
just result in empty text. 

## Using the transpiler
```
# Get an instance of the transpiler
require 'liquid-transpiler'
transpiler = LiquidTranspiler::LiquidTranspiler.new

# Transpiler Liquid templates in *template_dir*
# to a Ruby source file at *generated_file* 
# with options passed in a *options* has
status = transpiler.transpile_dir( template_dir, 
                                   generated_file,
                                   options)
                                  
# Check for errors transpiling          
unless status        
  transpiler.errors {|error| puts error}
  raise '*** Error transpiling'
end

# Load the generated Ruby code
load generated_file
generated = Transpiled.new

# Render a template *template* with settings
# in a *data* hash with string keys
html = generated.render( template, data)
```

## Transpiler options
The options are expressed as a hash with symbol
keys.

|Option|Default|Description|
|-|-|-|
|:class|Transpiled|Name of class to generate|
|:globals||Array of names of variables which will be available in every template|
|:include|LiquidTranspiledMethods|Module to include into generated class|

## Error handling

Running the transpiled code may result in Ruby errors
being raised whereas **Liquid** prevents that.
In particular null values may cause exceptions, the
code assumes templates check for data being missing.

## Limitations and issues

|Issue|Comments|
|-|-|
|Drops|Currently [Drops](https://github.com/Shopify/liquid/wiki/Introduction-to-Drops) are not really supported|
|include|The deprecated include tag is not implemented|
|modulo filter|`183.357 | modulo: 12` inside **Liquid** gives `3.357`, transpiled gives `3.3569999999999993`|
|offset: continue on fors|Not implemented|
|sum filter|`(1..6) | sum` inside **Liquid** gives `1..6`, transpiled gives `21`|

An expression like `thing.field` inside a template works
inside the transpiled code if `thing` is a hash, or if
`thing` has a method `field`.

## Testing
The tests take some template code and check that running it through
[Liquid](https://shopify.github.io/liquid/) and running it
through the transpiled code give the same result.  

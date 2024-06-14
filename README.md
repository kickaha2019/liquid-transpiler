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

# Render a template *template* with options
# in a *data* hash
html = generated.render( template, data)
```

## Transpiler options
The options are expressed as a hash with symbol
keys.

|Option|Default|Description|
|-|-|-|
|:class|Transpiled|Name of class to generate|
|:include|LiquidTranspiledMethods|Module to include into generated class|

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

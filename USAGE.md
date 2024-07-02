# Usage of the transpiler
Suppose there are two Liquid templates *test1.liquid*
and *test2.liquid* in a directory *test*. *test1.liquid*
contains:

```
{% render 'test2', tree:tree %}
```

and *test2.liquid* contains:

```
There is a {{ tree }} tree in the Forest of {{ forest }}.
```

The two Liquid templates can be converted to a Ruby class
*Fred* in a file *fred.rb* by:

```
require 'liquid_transpiler'
transpiler = LiquidTranspiler::Transpiler.new
status = transpiler.transpile_dir( 
            'test', 
            'test/fred.rb',
            {class:'Fred',  globals:['forest']})
```

The status will be *false* if there was an error
converting to Ruby code. The following code will
report any errors and raise an exception if there
were any.

```
unless status        
  transpiler.errors {|error| puts error}
  raise '*** Error transpiling'
end
```

The generated Ruby code can now be loaded and
executed by:

```
require 'liquid_transpiled_methods'
load 'test/fred.rb'
fred   = Fred.new
output = fred.render( 'test1', {'tree'=>'beech','forest'=>'Arden'} 
```

and *output* should contain

```
There is a beech tree in the Forest of Arden.
```

There is a 
[worked test](test/examples/test_basic_usage.rb) 
for this which is run as part of the test suite.

The optional 3rd argument to *transpile_dir* is
a hash of options. The
available options are:

|Option|Default|Description|
|-|-|-|
|:class|Transpiled|Name of class to generate|
|:globals||Array of names of variables which will be available in every template|
|:include|LiquidTranspiledMethods|Module to include into generated class|

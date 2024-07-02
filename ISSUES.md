# Issues and limitations

## Drops

Currently [Drops](https://github.com/Shopify/liquid/wiki/Introduction-to-Drops) are not really supported. 

An expression like:

```
{{ thing.field }}
```

will work *thing* is a hash, or if
*thing* has a method *field*.

## The deprecated include tag

Not implemented.

## The modulo filter

```
{{ 183.357 | modulo: 12 }}
```

inside **Liquid** gives *3.357*, the
transpiled code gives *3.3569999999999993* or
something like that.

## offset: continue on the for tag

Not implemented.

## The sum filter

```
{{ (1..6) | sum }}
```

inside **Liquid** gives `1..6`, the transpiled 
code gives *21*.


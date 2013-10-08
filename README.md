A library to parse CSV files on the client before uploading, including specifying the delimiters, encoding, and other information relating to the structure of the data.

This is still in its infancy and not really stable enough for use.

Here is an example of how it will be invoked:

```coffeescript
$ ->
  $('#div-upload').CSVShredder({
    'enclosedBy' : '"'
    'onLoad' : (file, idx) ->
      doSomethingToIndicateUploadedFiles()
    'onConstruct' : (obj) ->
      objContainsAnArrayOfDataSoDoSomethingWithIt() 
  })

```

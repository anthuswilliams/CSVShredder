Here is an example:

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

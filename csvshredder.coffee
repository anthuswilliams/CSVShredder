class CSVFile

  @file
  @index
  @fields
  @array
  @line_delimiter
  @field_delimiter
  @enclosed_by
  @first_as_header

  constructor : (file,opts) ->
    @file = file
    @index = opts['index'] ||= 0
    @first_as_header = opts['first_as_header']
    @line_delimiter = opts['line_delimiter']
    @field_delimiter = opts['field_delimiter']
    @enclosed_by = opts['enclosed_by']
    @on_construct = opts['onConstruct'] ||= (obj) -> return false
    this.constructArray()

  rawSplit : (line_delimiter,field_delimiter) ->
    @file.result.split(line_delimiter).map (l) ->
      l.split field_delimiter

  constructArray : () ->
    @array = this.rawSplit @line_delimiter,@field_delimiter
    if @first_as_header
      @fields = @array.shift().map (f) -> f.trim()
    else
      @fields = [null for elt in @array[0]]
    if @enclosed_by?
      @fields = @fields.map (f) -> f.trim(@enclosed_by)
      @array = @array.map (a) -> 
        a.map((b) -> b.trim(@enclosed_by))
    @on_construct(this)

class CSVShredder

  constructor : (obj, opts) ->
    @obj = $(obj)
    @files = []
    @on_load = opts['onLoad'] ||= (f, i) -> return false
    @on_construct = opts['onConstruct'] ||= (arr) -> return false
    @default_line_delimiter = opts['line_delimiter'] ||= '\n'
    @default_field_delimiter = opts['field_delimiter'] ||= ','
    @first_as_header = if opts['firstLineIsHeader']? then opts['firstLineIsHeader'] else true #cannot use ||= as we want to allow 'falsey' values like, well, false, for example
    @default_enclosed_by = opts['enclosedBy'] ||= null

    # throw exception if W3C File API is not accessible
    unless window.File? && window.FileList? && window.FileReader?
      # throw exception
      console.log 'Cannot access File API'

    _.bindAll(this, 'dragEnter', 'dragOver', 'drop')
    @obj.bind('dragenter', this.dragEnter)
    @obj.bind('dragover', this.dragOver)
    @obj.bind('drop', this.drop)

  dragEnter : (e) ->
    e.stopPropagation()
    e.preventDefault()
    false

  dragOver : (e) ->
    e.stopPropagation()
    e.preventDefault()
    false

  drop : (e) ->
    e.stopPropagation()
    e.preventDefault()

    $.each e.originalEvent.dataTransfer.files, (i, file) =>
      @on_load(file, i)
      reader = new FileReader()
      reader.onload = (e) =>
        # what's this? no weird bugs due to using the same variable name in two different contexts? I love you, coffeescript.
        if e.target.readyState is FileReader.DONE 
          @files.push new CSVFile(e.target,{
            'line_delimiter' : @default_line_delimiter
            , 'field_delimiter' : @default_field_delimiter
            , 'enclosed_by' : @default_enclosed_by
            , 'first_as_header' : @first_as_header
            , 'onConstruct' : @on_construct
            , 'index' : i
          })
        false
      reader.readAsText(file)

$.fn.CSVParser = (method) =>
  return new CSVParser(this, method)

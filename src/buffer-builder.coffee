class BufferBuilder
  
  @getUcs2StringLength: (string) -> string.length * 2
  
  _values: []
  
  length: 0
  
  # please keep functions in alphabetical order
  
  appendByte: (byte) ->
    @length++
    @_values.push type: 'byte', value: byte
    @
    
  appendBytes: (bytes) ->
    @length += bytes.length
    @_values.push type: 'byte array', value: bytes
    @
    
  appendInt32LE: (int) ->
    @length += 4
    @_values.push type: 'int32LE', value: int
    @
    
  appendString: (string, encoding) ->
    len = Buffer.byteLength string, encoding
    @length += len
    @_values.push type: 'string', encoding: encoding, value: string, length: len 
    @
    
  appendUcs2String: (string) ->
    @appendString string, 'ucs2'
    
  appendUInt16LE: (int) ->
    @length += 2
    @_values.push type: 'uint16LE', value: int
    @
    
  appendUInt32LE: (int) ->
    @length += 4
    @_values.push type: 'uint32LE', value: int
    @
  
  insertByte: (byte, position) ->
    @length++
    @_values.splice position, 0, type: 'byte', value: byte
    @
  
  insertUInt16BE: (int, position) ->
    @length++
    @_values.splice position, 0, type: 'uint16BE', value: int
    @
  
  toBuffer: ->
    buff = new Buffer @length
    offset = 0
    for value in values
      switch value.type
        # please keep in alphabetical order
        when 'byte'
          buff.set offset, value.value
          offset++
        when 'byte array'
          for byte in value.value
            buff.set offset, byte
            offset++
        when 'int32LE'
          buff.writeInt32LE value.value, offset
          offset += 4
        when 'string'
          buff.write value.value, offset, value.length, value.encoding
          offset += value.length 
        when 'uint32LE'
          buff.writeUInt32LE value.value, offset
          offset += 4
        else
          throw new Error 'Unrecognized type: ' + value.type

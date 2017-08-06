B_SYSEX = 0xf0
B_EOX = 0xf7

class PayloadCoder
  constructor: ->
    @_decoder = new TextDecoder 'utf-8'
    @_encoder = new TextEncoder 'utf-8'

  decode: (data) ->
    slice = new Uint8Array data[1...-1]
    payload = @_decoder.decode(slice)
    JSON.parse payload

  encode: (body) ->
    json = JSON.stringify body
    payload = @_encoder.encode json
    [B_SYSEX, payload..., B_EOX]


coder = new PayloadCoder()
module.exports = coder

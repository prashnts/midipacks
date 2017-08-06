{ expect } = require 'chai'

{ TextEncoder, TextDecoder } = require 'text-encoding'
global.TextEncoder = TextEncoder
global.TextDecoder = TextDecoder

coder = require '../client/coder'


describe 'Coder', ->
  context '#encoder', ->
    it 'encodes strings correctly', ->
      encoded = coder.encode 'Hello World'
      known = [240, 34, 72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 34, 247]
      expect(encoded).to.deep.equal known

    it 'encodes objects correctly', ->
      encoded = coder.encode { hello: 'world' }
      known = [
        240, 123, 34, 104, 101,
        108, 108, 111, 34, 58,
        34, 119, 111, 114, 108,
        100, 34, 125, 247,
      ]
      expect(encoded).to.deep.equal known

  context '#decoder', ->
    it 'decodes strings correctly', ->
      payload = [240, 34, 52, 50, 34, 247]
      decoded = coder.decode payload
      known = '42'
      expect(decoded).to.equal known

    it 'decodes objects correctly', ->
      payload = [
        240, 123, 34, 97,
        110, 115, 119, 101,
        114, 34, 58, 52,
        50, 125, 247,
      ]
      decoded = coder.decode payload
      known = { answer: 42 }
      expect(decoded).to.deep.equal known

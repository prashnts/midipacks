coder = require './coder'
{ logger } = require './utils'
DEV_PREFIX = 'MIDIPACK-IO'


class MIDIDevice
  constructor: (params) ->
    @lastRetry = 0
    @onMessage = params?.onMessage
    unless navigator.requestMIDIAccess
      logger.error 'MIDI access required.'

  connect: ->
    navigator
      .requestMIDIAccess({ sysex: yes })
      .then (midi) =>
        devices = midi.inputs.values()
        loop
          { value } = devices.next()
          unless value then break
          @registerDevice value
        unless @device
          delay = @setRetry()
          logger.info "No Instance accessible. Retrying in #{delay}s."

  setRetry: ->
    @lastRetry += 1
    delay = 2 ** @lastRetry
    setTimeout =>
      logger.info 'Retrying...'
      @connect()
    , delay * 1000
    return delay

  registerDevice: (device) ->
    if device.name.indexOf(DEV_PREFIX) is -1 then return
    @device = device
    @device.onmidimessage = @handleMIDIMessage
    @device.onstatechange = @handleDeviceStateChange

    logger.info "Connected to #{@device.name}"

    @lastRetry = 0    # Reset Counter

  handleMIDIMessage: (msg) =>
    payload = coder.decode msg.data
    @onMessage(payload)

  handleDeviceStateChange: (e) =>
    if e.port.state is 'disconnected'
      @device = null
      delay = @setRetry()
      logger.warn "Connection lost. Retrying in #{delay}s."


module.exports = MIDIDevice

const textDecoder = new TextDecoder('utf-8')

const onReady = () => {
  if (navigator.requestMIDIAccess) {
    navigator.requestMIDIAccess({ sysex: true })
      .then((midi) => {
        console.log(midi)
        window.midi = midi
        const input = midi.inputs.values().next().value
        console.log(input)
        input.onmidimessage = (msg) => {
          const encoded = msg.data.slice(1, msg.data.length - 1)
          const payload = JSON.parse(textDecoder.decode(encoded))
          console.log(payload)
        }

      })
  } else {
    throw new Error('Cannot request MIDI Access')
  }
}

window.addEventListener('DOMContentLoaded', onReady)


var midiManager = require( 'midi-file');

var fs = require("fs");
var ps = require("process");
var wav = require("wav");


		fs.readFile(ps.argv[2],(err,data) => {
			// Read MIDI file into a buffer
const parsed = midiManager.parseMidi(data);

			parsed.tracks.forEach((t) => {



			var file = fs.createReadStream(ps.argv[3]);
var reader = new wav.Reader();

// the "format" event gets emitted at the end of the WAVE header
reader.on('format', function (format) {

  // the WAVE header is stripped from the output of the reader
	//

var toArray = require('stream-to-array');

toArray(reader, function (err, arr) {
}).then((parts) => {

var buffers = []
    for (var i = 0, l = parts.length; i < l ; ++i) {
      var part = parts[i]
      buffers.push((part instanceof Buffer) ? part : new Buffer(part))
    }

    var wavbuf = Buffer.concat(buffers);

	var tempo;

t.forEach((x,i) => {
	if(x.type == "setTempo") {
		tempo = x.microsecondsPerBeat;
	}

	if(i < 10) console.log(x);
});

});

});

// pipe the WAVE file to the Reader instance
file.pipe(reader);

			});
		});

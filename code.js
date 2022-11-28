
var fs = require("fs");
var ps = require("process");

ps.argv.forEach((val, index) => {
	if(index >= 2)
		fs.readFile(val,(err,data) => {
			console.log(peg$parse(data.toString()).replace(/\\n/g,"\n"));
		});
});



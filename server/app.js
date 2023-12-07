var express = require('express') //Aufruf von express module
var app = express() //Rückgabe von express in Variable speichern
app.listen(3000, function() { //Server auf Port 3000 öffnen
    console.log("express server on port 3000")
})

app.get('/', function(req,res) {
    res.send(
        "<h1>express server on port 3000</h1>"
        )
})

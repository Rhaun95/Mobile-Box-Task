var express = require("express"); //Aufruf von express module
var app = express(); //Rückgabe von express in Variable speichern
var http = require("http");
var server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

var speed = 24;
var position = 0;

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/index.html");
});

io.on("connection", (socket) => {
  setInterval(() => {
    socket.emit("new number", speed);
  }, 100);

  console.log("a user connected");
  socket.on("disconnect", () => {
    console.log("user disconnected");
  });

  socket.on("chat message", (msg) => {
    console.log("message: " + msg);
  });

  socket.broadcast.emit("hi");

  socket.on("chat message", (msg) => {
    io.emit("chat message", msg);
  });

  socket.on("gas button has been pressed", () => {
    console.log("gas pressed");
    speed += 1;
    socket.emit("new number", speed);
  });

  socket.on("brake button pressed", () => {
    console.log("brake pressed");
    speed -= 1;
    socket.emit("new number", speed);
  });

  socket.on("boxPosition", function (data) {
    console.log("Received data from Flutter:", data);
    socket.emit("new number", data);
  });
});

io.emit("some event", {
  someProperty: "some value",
  otherProperty: "other value",
}); // This will emit the event to all connected sockets

server.listen(3000, () => {
  console.log("listening on *:3000");
});
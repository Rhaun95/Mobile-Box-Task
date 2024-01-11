const express = require("express");
const path = require("path");
var app = express();
var http = require("http");
var server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

var livereload = require("livereload");
var connectLiveReload = require("connect-livereload");

const liveReloadServer = livereload.createServer();
liveReloadServer.server.once("connection", () => {
  setTimeout(() => {
    liveReloadServer.refresh("/");
  }, 1);
});

app.use(connectLiveReload());

app.set("view engine", "ejs");
app.use(express.static("public"));

app.get("/", (req, res) => {
  res.render("index");
});

var speed = 0;
var position = 0;
let isGasPressed = false;

io.on("connection", (socket) => {
  setInterval(() => {
    socket.emit("new number", speed);
  }, 100);

  socket.on("gas button state", (pressed) => {
    isGasPressed = pressed;
    console.log(pressed);
  });

  const mu = 0.02; // Rollwiderstandskoeffizient
  const m = 1500; // Masse des Autos in kg
  const g = 9.81; // Gravitation
  const speedReductionInterval = setInterval(() => {
    if (!isGasPressed && speed > 0) {
      const rollingResistanceForce = mu * m * g; //Rollwiderstand = Rollwiderstandskoeffizient * Masse * Gravitation

      const reductionFactor = -rollingResistanceForce / m; // Geschwindigkeitsreduktion = -Rollwiderstand / Masse
      speed += reductionFactor / 100;

      if (speed < 0) speed = 0;

      io.emit("new number", speed);
    }
  }, 1);

  socket.on("disconnect", () => {
    console.log("user disconnected");
    clearInterval(speedReductionInterval);
  });

  socket.on("chat message", (msg) => {
    console.log("message: " + msg);
  });

  socket.broadcast.emit("hi");

  socket.on("chat message", (msg) => {
    io.emit("chat message", msg);
  });

  socket.on("gas button has been pressed", () => {
    const initialSpeed = speed; // Anfangsgeschwindigkeit
    const maxSpeed = 200; // Höchstgeschwindigkeit
    const accelerationTime = 10; // Zeit in Sekunden
    const deltaTime = 0.004; // Zeitintervall

    const acceleration = (maxSpeed - initialSpeed) / accelerationTime; //Beschleunigung = (maximale Geschwindigkeit - Anfangsgeschwindigkeit) / Beschleunigungszeit

    const deltaV = acceleration * deltaTime; //Geschwindigkeitsänderung = Beschleunigung * Zeitintervall

    speed += deltaV;

    if (speed > maxSpeed) speed = maxSpeed;
    io.emit("new number", speed);
  });

  socket.on("gas button released", () => {
    isGasPressed = false;
  });

  socket.on("brake button pressed", () => {
    const brakeFriction = 0.9; //Bremskoeffizient

    const brakeForce = brakeFriction * m * g; //Bremskraft = Bremskoeffizient * Masse * Gravitation

    const speedFactor = speed / 200; //Geschwindigkeitsfaktor = Geschwindigkeit / maximale Geschwindigkeit

    const currentBrakeForce = brakeForce * speedFactor; //aktuelle Bremskraft = Bremskfraft * Geschwindigkeitsfaktor

    const delay = currentBrakeForce / m; //Verzögerung = aktuelle Bremskraft / Masse

    speed -= delay * 0.1;

    if (speed < 0) speed = 0;

    io.emit("new number", speed);
  });

  socket.on("boxPosition", function (data) {
    socket.emit("new number", data);
  });
});

io.emit("some event", {
  someProperty: "some value",
  otherProperty: "other value",
});

server.listen(3001, () => {
  console.log("listening on *:3001");
});

const express = require("express");
const path = require("path");
var app = express();
var http = require("http");
var server = http.createServer(app);
// const { Server } = require("socket.io");
// const io = new Server(server);
const socketIo = require("socket.io")

const io = socketIo(server)

const PORT = 3001;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`listening on *: ${PORT}`);
});

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
let isGasPressed = false;

io.on("connection", (socket) => {
  console.log("user connected");
  setInterval(() => {
    socket.emit("new number", speed);
  }, 100);

  socket.on("gas button state", (pressed) => {
    isGasPressed = pressed;
  });

  const mu = 0.015; // Rollwiderstandskoeffizient
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
    clearInterval(sinusInterval);
    clearInterval(timeElapsed);
  });

  socket.on("gas button has been pressed", () => {
    const initialSpeed = speed; // Anfangsgeschwindigkeit
    const maxSpeed = 250; // Höchstgeschwindigkeit
    const accelerationTime = 10; // Zeit in Sekunden
    const deltaTime = 0.005; // Zeitintervall

    const acceleration = (maxSpeed - initialSpeed) / accelerationTime; //Beschleunigung = (maximale Geschwindigkeit - Anfangsgeschwindigkeit) / Beschleunigungszeit

    const deltaV = acceleration * deltaTime; //Geschwindigkeitsänderung = Beschleunigung * Zeitintervall

    speed += deltaV;

    if (speed > maxSpeed) speed = maxSpeed;
    socket.emit("new number", speed);
  });

  socket.on("gas button released", () => {
    isGasPressed = false;
  });

  socket.on("brake button pressed", () => {
    const brakeFriction = 0.9; //Bremskoeffizient

    const brakeForce = brakeFriction * m * g; //Bremskraft = Bremskoeffizient * Masse * Gravitation

    const speedFactor = speed / 250; //Geschwindigkeitsfaktor = Geschwindigkeit / maximale Geschwindigkeit

    const currentBrakeForce = brakeForce * speedFactor; //aktuelle Bremskraft = Bremskfraft * Geschwindigkeitsfaktor

    const delay = currentBrakeForce / m; //Verzögerung = aktuelle Bremskraft / Masse

    speed -= delay * 0.1;

    if (speed < 0) speed = 0;

    socket.emit("new number", speed);
  });

  socket.on("boxPosition", function (data) {
    // socket.emit("new number", data);
    io.emit("update boxPosition", data);

  });
  let time = 0;
  const timeElapsed = setInterval(() => {
    // console.log(time);
    time += 0.25;
  }, 10);

  const sinusInterval = setInterval(() => {
    if (speed >= 1) {
      const sinus = Math.sin((0.625 * Math.PI * time) / 60);
      speed += sinus;

      speed = Math.max(0, Math.min(speed, 250));

      socket.emit("new number", speed);
    }
  }, 50);
});

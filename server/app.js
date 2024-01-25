const express = require("express");
const app = express();

const { createServer } = require("http");
const SocketIO = require("socket.io");

const httpServer = createServer(app);
const io = SocketIO(httpServer, { path: "/socket.io" });

const PORT = 3001;

httpServer.listen(PORT, "0.0.0.0", () => {
  console.log(`server listening on *: ${PORT}`);
});

const path = require("path");

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
var sliderValue = 0;
let isGasPressed = false;
let isBrakePressed = false;

let rooms = new Map();
function saveRooms(roomName) {
  rooms.set(roomName);
  console.log("roomlist: ", Array.from(rooms));
}

let roomName;

io.on("connection", (socket) => {
  console.log("client is connected", socket.id);

  socket.on("join room", (data) => {
    roomName = data;
    socket.join(roomName);
    socket.emit("welcome", "welcome1");
    saveRooms(data);
  });

  setInterval(() => {
    // socket.emit("new number", speed);
    socket.to(roomName).emit("new number", speed);
  }, 100);

  socket.on("gas button state", (pressed) => {
    // socket.join(roomId);
    isGasPressed = pressed;
  });

  socket.on("brake button state", (pressedB) => {
    // socket.join(roomId);
    isBrakePressed = pressedB;
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

      //io.emit("new number", speed);
      socket.to(roomName).emit("new number", speed);
    }
  }, 1);

  socket.on("slider change", (_sliderValue) => {
    sliderValue = _sliderValue / 100;
  });

  socket.on("gas button has been pressed", () => {
    if (isGasPressed && sliderValue > 0) {
      const initialSpeed = speed; // Anfangsgeschwindigkeit
      const maxSpeed = 250; // Höchstgeschwindigkeit
      const accelerationTime = 10; // Zeit in Sekunden
      const deltaTime = 0.005; // Zeitintervall

      const acceleration = (maxSpeed - initialSpeed) / accelerationTime; //Beschleunigung = (maximale Geschwindigkeit - Anfangsgeschwindigkeit) / Beschleunigungszeit

      const deltaV = acceleration * deltaTime * sliderValue; //Geschwindigkeitsänderung = Beschleunigung * Zeitintervall

      speed = speed + deltaV;

      if (speed > maxSpeed) speed = maxSpeed;
      // io.emit("new number", speed);
      socket.to(roomName).emit("new number", speed);
    }
  });

  socket.on("gas button released", () => {
    isGasPressed = false;
  });

  socket.on("brake button pressed", () => {
    if (isBrakePressed && sliderValue < 0) {
      const brakeFriction = 0.9; //Bremskoeffizient

      const brakeForce = brakeFriction * m * g; //Bremskraft = Bremskoeffizient * Masse * Gravitation

      const speedFactor = speed / 250; //Geschwindigkeitsfaktor = Geschwindigkeit / maximale Geschwindigkeit

      const currentBrakeForce = brakeForce * speedFactor; //aktuelle Bremskraft = Bremskfraft * Geschwindigkeitsfaktor

      const delay = currentBrakeForce / m; //Verzögerung = aktuelle Bremskraft / Masse

      speed += delay * (sliderValue / 10);

      if (speed < 0) speed = 0;

      // socket.emit("new number", speed);
      socket.to(roomName).emit("new number", speed);
    }
  });

  socket.on("boxPosition", function (data) {
    // socket.emit("new number", data);
    socket.to(roomName).emit("update boxPosition", data);
  });
  let time = 0;
  const timeElapsed = setInterval(() => {
    time += 0.25;
  }, 10);

  let isSinusEnabled = false;

  const sinusInterval = setInterval(() => {
    if (isSinusEnabled && speed >= 1) {
      console.log("sinus interval on");
      const sinus = Math.sin((0.625 * Math.PI * time) / 60);
      speed += sinus;

      speed = Math.max(0, Math.min(speed, 250));

      socket.to(roomName).emit("new number", speed);
    }
  }, 50);

  socket.on("disconnect", () => {
    console.log("user disconnected");
    socket.leave(roomName);
    clearInterval(speedReductionInterval);
    clearInterval(sinusInterval);
    clearInterval(timeElapsed);
  });
});

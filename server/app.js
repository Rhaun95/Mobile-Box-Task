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

let roomMapper = new Map();
const adapter = io.sockets.adapter;

const mu = 0.015; // Rollwiderstandskoeffizient
const m = 1500; // Masse des Autos in kg
const g = 9.81; // Gravitation

const maxSpeed = 250; // Höchstgeschwindigkeit
const accelerationTime = 10; // Zeit in Sekunden
const deltaTime = 0.01; // Zeitintervall
const brakeFriction = 0.9; //Bremskoeffizient

io.on("connection", (socket) => {
  socket.on("join room", (data) => {
    roomMapper.set(data, {
      speed: 0,
      sliderValue: 0,
      isGasPressed: false,
      isBrakePressed: false,
      boxPosition: 0,
      time: 0,
    });
    socket.join(data);
    console.log("All rooms: ", adapter.rooms);
  });

  socket.on("join room from web", async (room, cb) => {
    if (io.sockets.adapter.rooms.has(room)) {
      socket.join(room);
      console.log("WEB JOINED: ", room);
      cb(true);
    } else {
      console.log(`incorrect roomname`);
      cb(false);
    }
  });

  setInterval(() => {
    roomMapper.forEach((data, currentRoom) => {
      io.to(currentRoom).emit("new number", { speed: data.speed });
    });
  }, 1);

  socket.on("gas button state", (data) => {
    if (data.isGasPressed)
      roomMapper.get(data.roomName).isGasPressed = data.isGasPressed;
  });

  socket.on("brake button state", (data) => {
    if (data.isBrakePressed)
      roomMapper.get(data.roomName).isBrakePressed = data.isBrakePressed;
  });

  const speedReductionInterval = setInterval(() => {
    roomMapper.forEach((data, currentRoom) => {
      if (currentRoom && !data.isGasPressed && data.speed > 0) {
        const rollingResistanceForce = mu * m * g; //Rollwiderstand = Rollwiderstandskoeffizient * Masse * Gravitation

        const reductionFactor = -rollingResistanceForce / m; // Geschwindigkeitsreduktion = -Rollwiderstand / Masse
        data.speed += reductionFactor;

        if (data.speed < 0) data.speed = 0;

        io.to(currentRoom).emit("new number", { speed: data.speed });
      }
    });
  }, 100);

  // let time = 0;
  const timeElapsed = setInterval(() => {
    roomMapper.forEach((data, roomName) => {
      data.time += 0.05;
    });
  }, 10);

  let isSinusEnabled = true;

  const sinusInterval = setInterval(() => {
    roomMapper.forEach((data, currentRoom) => {
      if (currentRoom && isSinusEnabled && data.speed >= 1) {
        const sinus = Math.sin(((0.625 * Math.PI * data.time) / 200) * 0.5);
        data.speed += sinus / 50;

        data.speed = Math.max(0, Math.min(data.speed, 250));

        io.to(currentRoom).emit("new number", { speed: data.speed });
      }
    });
  }, 10);

  socket.on("slider change", (data) => {
    if (data.sliderValue)
      roomMapper.get(data.roomName).sliderValue = data.sliderValue / 1000;
  });

  socket.on("gas button has been pressed", (data) => {
    const currentRoom = roomMapper.get(data.roomName);
    if (currentRoom.isGasPressed && currentRoom.sliderValue > 0) {
      const initialSpeed = currentRoom.speed; // Anfangsgeschwindigkeit

      const acceleration = (maxSpeed - initialSpeed) / accelerationTime; //Beschleunigung = (maximale Geschwindigkeit - Anfangsgeschwindigkeit) / Beschleunigungszeit

      const deltaV = (acceleration * deltaTime * data?.sliderValue) / 100; //Geschwindigkeitsänderung = Beschleunigung * Zeitintervall

      currentRoom.speed = currentRoom.speed + deltaV;
      if (currentRoom.speed > maxSpeed) currentRoom.speed = maxSpeed;
      io.to(data.roomName).emit("new number", { speed: currentRoom.speed });
    }
  });

  socket.on("brake button pressed", (data) => {
    const currentRoom = roomMapper.get(data.roomName);

    if (currentRoom.isBrakePressed && currentRoom.sliderValue < 0) {
      const brakeForce = brakeFriction * m * g; //Bremskraft = Bremskoeffizient * Masse * Gravitation

      const speedFactor = currentRoom.speed / maxSpeed; //Geschwindigkeitsfaktor = Geschwindigkeit / maximale Geschwindigkeit

      const currentBrakeForce = brakeForce * speedFactor; //aktuelle Bremskraft = Bremskfraft * Geschwindigkeitsfaktor

      const delay = currentBrakeForce / m; //Verzögerung = aktuelle Bremskraft / Masse

      currentRoom.speed += delay * currentRoom.sliderValue;

      if (currentRoom.speed < 0) currentRoom.speed = 0;
      io.to(data.roomName).emit("new number", { speed: currentRoom.speed });
    }
  });

  socket.on("boxPosition", (data) => {
    const currentRoom = roomMapper.get(data.roomName);
    if (currentRoom && currentRoom.speed >= 1) {
      const sinus = Math.sin(((0.75 * Math.PI * currentRoom.time) / 60) * 0.18);
      currentRoom.boxPosition = data.boxPosition + sinus;
      socket.to(data.roomName).emit("update boxPosition", {
        boxPosition: currentRoom.boxPosition,
        speed: currentRoom.speed,
      });
    }
  });

  socket.on("leaveRoom", (data) => {
    console.log("room to leave: ", data.roomName);
    socket.to(data.roomName).emit("leaveRoomFromServer");
    socket.leave(data.roomName);
    roomMapper.delete(data.roomName);
    console.log(Array.from(roomMapper.keys()));
  });

  socket.on("disconnect", () => {
    socket.disconnect();
    console.log("user disconnected");
    console.log("after leave2: ", adapter.rooms);
    // clearInterval(speedReductionInterval);
    // clearInterval(sinusInterval);
    // clearInterval(timeElapsed);
  });
});

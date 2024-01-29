import 'package:flutter/material.dart';
import 'package:mobile_box_task/provider/DrivingData.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider extends ChangeNotifier {
  late IO.Socket socket;

  SocketProvider() {
    socket = IO.io('http://192.168.1.15:3001', <String, dynamic>{
      // socket = IO.io('http://192.168.1.15:3001', <String, dynamic>{
      // socket = IO.io('http://192.168.178.22:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
  }

  void join() {
    socket.emit("join room", DrivingData.roomName);
  }

  IO.Socket getSocket() {
    return socket;
  }
}

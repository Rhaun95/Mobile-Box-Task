import 'package:flutter/material.dart';
import 'package:mobile_box_task/helper/DrivingHelper.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider extends ChangeNotifier {
  static IO.Socket socket =
      IO.io('http://box-task.imis.uni-luebeck.de', <String, dynamic>{
    // socket = IO.io('http://192.168.1.15:3001', <String, dynamic>{
    // socket = IO.io('http://192.168.178.22:3001', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  void join() {
    socket.emit("join room", DrivingHelper.roomName);
  }

  IO.Socket getSocket() {
    return socket;
  }
}

import 'dart:io';

class SocketManager {
  static final _service = SocketManager._internal();

  factory SocketManager() => _service;


  SocketManager._internal();

  WebSocket? _socket;

  final socketUrl = 'ws://api.quynhtao.com/ws/';

  Future connect(String name) async {
    try{
      print('connecting....');
      _socket = await WebSocket.connect('$socketUrl$name', headers: {});
      listen();
      print('Connect Susses: $name');
    } catch(e) {
      print('Error: ${e.toString()}');
    }
  }
  Future listen() async {
    _socket?.listen((event) {
      print('SocketManager.listen');
    });
  }

  // Future on() async {
  //   _socket?.listen((event) {
  //     print('SocketManager.listen');
  //   });
  // }
}

final socketManager = SocketManager();


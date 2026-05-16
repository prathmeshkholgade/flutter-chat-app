import 'package:flutter_chat/core/enviroment/enviroment.dart';
import 'package:flutter_chat/core/utils/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late Io.Socket _socket;

  bool isConnected = false;

  Future<void> init() async {
    _socket = Io.io(
      Enviroment.baseUrl,
      Io.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      isConnected = true;
      AppLogger.d("Socket Connected: ${_socket.id}");
    });

    _socket.onDisconnect((_) {
      isConnected = false;
      AppLogger.d("_socket Disconnected");
    });

    _socket.onConnectError((data) {
      isConnected = false;
      AppLogger.d("Connect Error: $data");
    });

    _socket.onError((data) {
      isConnected = false;
      AppLogger.d("Socket Error: $data");
    });
  }

  void joinRoom(chatId) {
    insureConnected();
    AppLogger.d("Joining Room: $chatId");
    _socket.emitWithAck(
      "join_chat",
      chatId,
      ack: (response) => {AppLogger.d("Join Room Response: $response")},
    );
  }

  void insureConnected() async {
    if (!isConnected) {
      await init();
    }
  }

  void leaveChat(chatId) {
    _socket.emitWithAck(
      "leave_chat",
      chatId,
      ack: (response) => {AppLogger.d("Leave Chat Response: $response")},
    );
  }

  void sendMessage({
    required int chatId,
    required int senderId,
    required String message,
  }) {
    insureConnected();
    _socket.emitWithAck(
      "send_message",
      {"chatId": chatId, "senderId": senderId, "message": message},
      ack: (response) => {AppLogger.d("Send Message Response: $response")},
    );
  }

  void onMessageReceive(Function(Map<String, dynamic>) callBack) {
    try {
      _socket.off("new_message");
      _socket.on("new_message", (data) {
        AppLogger.d("new message receive $data");
        callBack(data);
      });
    } catch (e) {
      AppLogger.e(e);
    }
  }
}

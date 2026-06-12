import 'dart:io';

class NetworkService {
  static Future<String> sendCommand(String ip, String command) async {
    try {
      final socket = await Socket.connect(ip, 7878);

      socket.write(command);

      await socket.flush();

      String response = "";

      await for (var data in socket) {
        response += String.fromCharCodes(data);
      }

      await socket.close();

      return response;
    } catch (e) {
      return "";
    }
  }
}

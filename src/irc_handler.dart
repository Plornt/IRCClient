part of IRCClient;


class IrcHandler {
  Socket _connection;
  ModuleHandler moduleHandler;
  int port;
  InternetAddress ip;
  IrcHandler () {
    
  }
  void startClient () {
    Socket.connect(ip, port).then((Socket socket) {
            socket.transform(new Utf8Decoder()).transform(new LineSplitter ()).listen(messageHandler);
    });
  }
  void messageHandler (String message) {
    if (message[0] == ":") {
      List<String> fullCommand = message.split(" ");
    }
  }
  void sendCommand (Command comm) {
    
  }
  
}


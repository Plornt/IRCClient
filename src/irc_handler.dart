part of IRCClient;


class IrcHandler {
  Socket _connection;
  ModuleHandler moduleHandler = new ModuleHandler();
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
      message = message.substring(1);
      List<String> fullCommand = message.split(" ");
      Nickname nickname;
      if (fullCommand[0].contains("@")) nickname = new Nickname.fromHostString(fullCommand[0]);
      else nickname = new Nickname(fullCommand[0]);
      String command = fullCommand[1];
      switch (command) {
        // TODO: Fix this up so it doesnt look absolutely ugly
        case CLIENT_COMMANDS.NICK:
          moduleHandler.sendCommand(new NickCommand(new Nickname(fullCommand[2])), nickname);
          break;
        case CLIENT_COMMANDS.QUIT:
          moduleHandler.sendCommand(new QuitCommand(fullCommand.getRange(2, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.SQUIT:
          moduleHandler.sendCommand(new SQuitCommand(new ServerName(fullCommand[2]), fullCommand.getRange(3, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.JOIN: 
          moduleHandler.sendCommand(new JoinCommand(new ChannelName(fullCommand[2])), nickname);
          break;
        case CLIENT_COMMANDS.CHAN_MODE: 
          
          break;
        
      }
    }
  }
  void sendCommand (Command comm) {
    
  }
  
}


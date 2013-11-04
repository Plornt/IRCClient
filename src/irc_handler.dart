part of IRCClient;


class IrcHandler {
  Socket _connection;
  ModuleHandler moduleHandler = new ModuleHandler();
  int port;
  Map<String, dynamic> iSupportResponse = new Map<String, dynamic> ();
  Nickname myNick; 
  
  InternetAddress ip;
  
  IrcHandler () {
    
  }
  
  void addISupportParameter (String parameter, dynamic value) {
    iSupportResponse[parameter] = value;
    if (parameter == ISUPPORT_PARAMS.CHAN_MODES) {
      if (value is List<String>) {
        int x = 1;
        value.forEach((f) { 
           List<String> modes = f.split("");
           modes.forEach((mode) {
             if (x == 1) new ChanModeValidator(mode,true, false);
             else if (x == 2) new ChanModeValidator(mode, true, false);
             else if (x == 3) new ChanModeValidator (mode, false, true);
             else if (x == 4) new ChanModeValidator (mode, false, false);
           });
           x++;
        });
      }
    }
    else if (parameter == ISUPPORT_PARAMS.PREFIX) {
      if (value is List<List<String>>) {
        value.forEach((List<String> prefixes) {
          new ChanModeValidator(prefixes[0], true, false);
          new NicknamePrefix(prefixes[0], prefixes[1]);
        });
      }
    }
    else if (parameter == ISUPPORT_PARAMS.CHAN_TYPES) {
      if (value is List<String>) {
        value.forEach((prefix) { new ChannelPrefix(prefix); });
      }
    }
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
          NickCommand nickCommand = new NickCommand(new Nickname(fullCommand[2]));
          if (nickname.name == myNick) {
            myNick = new Nickname(fullCommand[2].substring(1));
          }
          moduleHandler.sendCommand(new NickCommand(myNick), nickname);
          break;
        case CLIENT_COMMANDS.QUIT:
          moduleHandler.sendCommand(new QuitCommand(fullCommand.getRange(2, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.SQUIT:
          moduleHandler.sendCommand(new SQuitCommand(new ServerName(fullCommand[2]), fullCommand.getRange(3, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.JOIN: 
          moduleHandler.sendCommand(new JoinCommand(new ChannelName(fullCommand[2].substring(1))), nickname);
          break;
        case CLIENT_COMMANDS.PART: 
          
          moduleHandler.sendCommand(new PartCommand(new ChannelName(fullCommand[2]),fullCommand.getRange(3, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.CHAN_MODE: 
          //<- :Innocent!angelic@till.you.can.prove.otherwise MODE #zstaff -m 
          ChannelName channel = new ChannelName(fullCommand[2]);
          String modeStr = fullCommand[3];
          bool plus = true;
          int currParam = 3;
          List<ChanMode> changedModes = new List<ChanMode>();
          for (int x = 0; x < modeStr.length; x++) {
            if (modeStr[x] == "+") plus = true;
            else if (modeStr[x] == "-") plus = false;
            
            bool found = false;
            for (int i = 0; i < ChanModeValidator.modes.length; i++) {
              ChanModeValidator curMode = ChanModeValidator.modes[i];
              if (curMode.modeText == modeStr[x]) {
                String paramText = "";
                if (curMode.requiresParameter || (curMode.paramOnlyOnSet && plus == true)) {
                  currParam++;
                  paramText = fullCommand[currParam];
                }
                changedModes.add(new ChanMode(modeStr[x], paramText, plus));
                found = true;
              }
            }
            if (found == false) throwError("Incorrect mode found: $message");
          }
          moduleHandler.sendCommand(new ChannelModeCommand.fromList(channel, changedModes), nickname);
          break;
        case CLIENT_COMMANDS.TOPIC:
          moduleHandler.sendCommand(new TopicCommand.setTopic(new ChannelName(fullCommand[2]), fullCommand.getRange(3, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.KICK:
          moduleHandler.sendCommand(new KickCommand(new ChannelName(fullCommand[2]), new Nickname(fullCommand[3]),  fullCommand.getRange(4, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.PRIV_MSG:
          
          moduleHandler.sendCommand(new PrivMsgCommand(new Target(fullCommand[2]),  fullCommand.getRange(3, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.NOTICE:
          
          break;
      }
    }
  }
  void sendCommand (Command comm) {
    
  }
  
}


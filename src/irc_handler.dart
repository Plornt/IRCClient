part of IRCClient;


class IrcHandler {
  Socket _connection;
  ModuleHandler moduleHandler;
  int port;
  InternetAddress ip;
  String serverPassword;
  Map<String, dynamic> iSupportResponse = new Map<String, dynamic> ();
  Nickname myNick; 
  
  
  IrcHandler (this.ip, this.port, this.myNick, [this.serverPassword]) {
    moduleHandler = new ModuleHandler(this);
    moduleHandler.initialize();    
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
      _connection = socket;
      moduleHandler.sendPacket(new ConnectionStatusPacket(true));
      socket.transform(new Utf8Decoder()).transform(new LineSplitter ()).listen(messageHandler, 
          onError: (e) { moduleHandler.sendPacket(new ConnectionStatusPacket(false));}, 
          onDone: () { moduleHandler.sendPacket(new ConnectionStatusPacket(false)); });
    });
  }
  void messageHandler (String message) {
    print("< $message");
    if (message[0] == ":") {
      message = message.substring(1);
      List<String> fullCommand = message.split(" ");
      Nickname nickname;
      print("${fullCommand[0]} DEBUG");
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
          Target target;
          print(fullCommand[2]);
          if (ChannelPrefix.isChannel(fullCommand[2])) {
            target = new ChannelName(fullCommand[2]);
          }
          else target = new Nickname(fullCommand[2]);
          if (target is ChannelName) {
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
              moduleHandler.sendCommand(new ChannelModeCommand.fromList(target, changedModes), nickname);
          }
          else {
            moduleHandler.sendCommand(new UserModeCommand(target, new UserMode(fullCommand[3].substring(1))));
          }
          break;
        case CLIENT_COMMANDS.TOPIC:
          moduleHandler.sendCommand(new TopicCommand.setTopic(new ChannelName(fullCommand[2]), fullCommand.getRange(3, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.KICK:
          moduleHandler.sendCommand(new KickCommand(new ChannelName(fullCommand[2]), new Nickname(fullCommand[3]),  fullCommand.getRange(4, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.PRIV_MSG:
          Target target;
          if (ChannelPrefix.isChannel(fullCommand[2])) {
            target = new ChannelName(fullCommand[2]);
          }
          else target = new Nickname(fullCommand[2]);
          moduleHandler.sendCommand(new PrivMsgCommand(target,  fullCommand.getRange(3, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        case CLIENT_COMMANDS.NOTICE:
          Target target;
          if (ChannelPrefix.isChannel(fullCommand[2])) {
            target = new ChannelName(fullCommand[2]);
          }
          else target = new Nickname(fullCommand[2]);
          moduleHandler.sendCommand(new NoticeCommand(target,  fullCommand.getRange(3, fullCommand.length).join(" ").substring(1)), nickname);
          break;
        
      }
      print(command);
      RegExp num = new RegExp(r"^([0-9][0-9][0-9])$");
      if (num.hasMatch(command)) {
        print("Regex match");
        Match m = num.firstMatch(command);
        int raw = int.parse(m.group(0));
        print(raw);
        moduleHandler.sendPacket(new RawPacket(raw, fullCommand.getRange(2, fullCommand.length).join(" ")));
        
        // TODO: THIS WAS COPIED FROM ANOTHER FILE AND AS SUCH DOES POINTLESS GET RANGES ETC... FIX THIS.
        String packet = fullCommand.getRange(2, fullCommand.length).join(" ");
        if (raw == NUMERIC_REPLIES.RPL_BOUNCE_OR_ISUPPORT) {
          // Following is the only way to check if its a bounce or isupport that I know of
          // Worst... Protocol... EVER.

          List<String> isupport = packet.split(" ");
          print(isupport.getRange(isupport.length - 5, isupport.length).join(" "));
          if (isupport.getRange(isupport.length - 5, isupport.length).toList().join(" ") == ":are supported by this server") {
            print("Parsing ISUPPORT");
            List<String> s = isupport.getRange(1, isupport.length - 5).toList();
            String p = s.join(" ");
            print(p);
            ISupportParser parser = new ISupportParser.parse(p);
            parser.parameters.forEach((k, v) { 
              addISupportParameter(k, v);         
            });     
          }
          
        }
      
      
      
      }
    }
  }
  void sendCommand (Command comm) {
    if (_connection != null) {
      _connection.writeln(comm.toString());
    }
  }
  
}


part of IrcModule;

abstract class Module {
 
  
  SendPort _ircClient;
  ReceivePort _me;
  bool _loaded = false;
  Nickname _myName;
  
  Module (ModuleStartRequest packet) {
    _me = new ReceivePort();
    this._myName = packet.myName;
    _messageHandler(packet);
  }
  
  
  Nickname getBotName () {
    return _myName;
  }
  
  void setBotName (String nickname) {
    this.sendCommand(new NickCommand(new Nickname(nickname)));
  }
  
  
  void sendCommand (Command comm) {
    _ircClient.send(new SendCommand(comm));
  } 
  void sendPacket (IsolatePacket packet) {
    _ircClient.send(packet);
  }
  
  void _messageHandler (dynamic message) {
    if (message is ModuleStartRequest) {
      _ircClient = message.sendBack;
      _ircClient.send(new SendPortResponse(_me.sendPort));
    }
    else if (message is CommandEvent) { 
      Command comm = message.event;
      if (comm is JoinCommand) onChannelJoin(message.sender, comm);
      else if (comm is PartCommand) {
        onChannelPart(message.sender, comm);
      }
      else if (comm is NickCommand) {
        if (message.sender == comm.nick) {
          _myName = comm.nick;
        }
        onNickChange(message.sender, comm);
      }
      else if (comm is PrivMsgCommand) {
        if (comm.target is ChannelName) {
          onChannelMessage(message.sender, comm);
        }
        else if (comm.target is Nickname) {
          onPrivateMessage(message.sender, comm);
        }
      }
      else if (comm is NoticeCommand) {
        if (comm.target is ChannelName) {
          onChannelNotice(message.sender, comm);
        }
        else if (comm.target is Nickname) {
          onPrivateNotice(message.sender, comm);
        }
      }
      else if (comm is ErrorCommand) {
        onServerError(comm);
      }
      else if (comm is QuitCommand) {
        onQuit(message.sender, comm);
      }
      else if (comm is TopicCommand) {
        onTopicChange(message.sender, comm);
      }
      else if (comm is KickCommand) {
        onKick(message.sender, comm);
      }      
    }
  } 

  bool onSendCommand (Command command) { }
  bool onReceiveRaw (int code, String packet){ }
  bool onChannelJoin (Target user, JoinCommand command){ }
  bool onChannelPart (Target user, PartCommand command){ }
  bool onNickChange (Target user, NickCommand command){ }
  bool onChannelMessage (Target user, PrivMsgCommand command){ }
  bool onPrivateMessage (Target user, PrivMsgCommand command){ }
  bool onChannelNotice (Target user, NoticeCommand command){ }
  bool onPrivateNotice (Target user, NoticeCommand command){ }
  bool onServerError (ErrorCommand command){ }
  bool onQuit (Target user, QuitCommand command){ }
  bool onTopicChange (Target user, TopicCommand command){ }
  bool onKick (Target user, KickCommand command){ }
  
  bool onModuleStart (){ }
  bool onDisconnect (){ }
  bool onConnect (){ }
  bool onModuleDeactivate(){ }
  
}
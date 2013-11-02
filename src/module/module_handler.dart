part of IrcModule;

abstract class Module {
 
  
  SendPort _ircClient;
  ReceivePort _me;
  bool _loaded = false;
  
  Module (SendPortRequest packet) {
    _me = new ReceivePort();
    _messageHandler(packet);
  }
  
  
  void sendCommand (Command comm) {
    _ircClient.send(new SendCommand(comm));
  }
  
  void _messageHandler (dynamic message) {
    if (message is SendPortRequest) {
      _ircClient = message.sendBack;
      _ircClient.send(new SendPortResponse(_me.sendPort));
    }
    else if (message is CommandEvent) { 
      Command comm = message.event;
      if (comm is JoinCommand) onChannelJoin(comm);
      else if (comm is PartCommand) {
        onChannelPart(comm);
      }
      else if (comm is NickCommand) {
        onNickChange(comm);
      }
      else if (comm is PrivMsgCommand) {
        if (comm.target is ChannelName) {
          onChannelMessage(comm);
        }
        else if (comm.target is Nickname) {
          onPrivateMessage(comm);
        }
      }
      else if (comm is NoticeCommand) {
        if (comm.target is ChannelName) {
          onChannelNotice(comm);
        }
        else if (comm.target is Nickname) {
          onPrivateNotice(comm);
        }
      }
      else if (comm is ErrorCommand) {
        onServerError(comm);
      }
      else if (comm is QuitCommand) {
        onQuit(comm);
      }
      else if (comm is TopicCommand) {
        onTopicChange(comm);
      }
      else if (comm is KickCommand) {
        onKick(comm);
      }      
    }
  } 

  bool onSendCommand (Command command) { }
  bool onReceiveRaw (int code, String packet){ }
  bool onChannelJoin (JoinCommand command){ }
  bool onChannelPart (PartCommand command){ }
  bool onNickChange (NickCommand command){ }
  bool onChannelMessage (PrivMsgCommand command){ }
  bool onPrivateMessage (PrivMsgCommand command){ }
  bool onChannelNotice (NoticeCommand command){ }
  bool onPrivateNotice (NoticeCommand command){ }
  bool onServerError (ErrorCommand command){ }
  bool onQuit (QuitCommand command){ }
  bool onTopicChange (TopicCommand command){ }
  bool onKick (KickCommand command){ }
  
  bool onModuleStart (){ }
  bool onDisconnect (){ }
  bool onConnect (){ }
  bool onModuleDeactivate(){ }
  
}
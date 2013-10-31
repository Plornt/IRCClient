part of IrcModule;

abstract class ModuleHandler {
  String moduleName;
  String moduleAuthor;
  String moduleDescription;
  int moduleVersion;
  
  bool _loaded = false;
  void registerEvent (String EventName) {
    if (_loaded == true) {
      
    }
  }
    

  bool onSendCommand (Command command);
  bool onReceiveRaw (int code, String packet);
  bool onChannelJoin (JoinCommand command);
  bool onChannelPart (PartCommand command);
  bool onNickCommad (NickCommand command);
  bool onChannelMessage (PrivMsgCommand command);
  bool onPrivateMessage (PrivMsgCommand command);
  bool onChannelNotice (NoticeCommand command);
  bool onPrivateNotice (NoticeCommand command);
  bool onServerError (ErrorCommand command);
  bool onQuit (QuitCommand command); 
  bool onTopicChange (TopicCommand command);
  bool onKick (KickCommand command);
  bool onMOTD (MotdCommand command);
  
  bool onDisconnect ();
  bool onConnect ();
  bool onModuleLoad();
  bool onModuleDeactivate();
  
}
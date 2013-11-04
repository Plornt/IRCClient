part of IrcModule;

abstract class IsolatePacket {
  void handleMessage () {
    
  }
}

/// Used to request the sendport from a module
class ModuleStartRequest extends IsolatePacket {
  SendPort sendBack;
  Nickname myName;
  ModuleStartRequest (SendPort this.sendBack);
}

/// Used to send the sendport to the handler
class SendPortResponse extends IsolatePacket {
  SendPort port;
  SendPortResponse (SendPort this.port);
}

/// Used to request a command to be sent to the server
class SendCommand extends IsolatePacket {
  Command comm;
  SendCommand (this.comm);
}

/// Received by the module handler 
class CommandEvent extends IsolatePacket {
  Target sender;
  Command event;
  CommandEvent.withTarget (this.sender,this.event);
}


/// Received by the module handler 
class RawPacket extends IsolatePacket {
  int raw;
  String command;
  RawPacket (this.raw, this.command);
}

/// Received by the module handler 
class ISupportPacket extends IsolatePacket {
  Map<String, dynamic> parameters;
  ISupportPacket (this.parameters);
}
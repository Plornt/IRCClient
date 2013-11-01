part of IrcModule;

abstract class IsolatePacket {
  void handleMessage () {
    
  }
}

/// Used to request the sendport from a module
class SendPortRequest extends IsolatePacket {
  SendPort sendBack;
  SendPortRequest (SendPort this.sendBack);
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
  Command event;
  CommandEvent (this.event);
}
part of IRCClient;

class ModuleHandler {
 List<ModuleContainer> modules = new List<ModuleContainer>();
 ModuleHandler ();
 
 void sendPacket(IsolatePacket packet) {
   modules.forEach((module) {
     if (module.active) {
       module.sendMessage(packet);
     }
   });
 }
 void sendCommand (Command comm, [Nickname sender = null]) {
   sendPacket(new CommandEvent.withTarget(sender, comm));
 }
}

class ModuleContainer {
  Module module;
  ModuleHandler handler;
  Isolate _isolate;
  ReceivePort _port;
  SendPort _sender;
  String moduleName;
  bool _loaded = false;
  bool active = true;
  ModuleContainer (String this.moduleName, ModuleHandler this.handler);
  
  void initialize () {
    _port = new ReceivePort();
    SendPort sendPort = _port.sendPort;
    Isolate.spawnUri(Uri.parse(moduleName),[],sendPort).then((Isolate iso) { 
      _isolate = iso;
      _port.listen(handleMessage);
    });
  }
  
  void unloadModule () {
    
  }
  
  void sendMessage(IsolatePacket packet) {
    if (_loaded) {
      _sender.send(packet);
    }
  }
  
  void reloadModule() {
    if (_loaded == true) {
                  
    }
  }
  
  void handleMessage (dynamic message) {
     if (message is SendPortResponse) {
       _sender = message.port;
     }
     else if (message is SendCommand) {
       
     }
  }
}


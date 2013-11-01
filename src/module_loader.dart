part of IRCClient;

class ModuleHandler {
 
  
}

class ModuleContainer {
  Module module;
  IrcHandler handler;
  Isolate _isolate;
  ReceivePort _port;
  SendPort _sender;
  String moduleName;
  bool _loaded = false;
  ModuleContainer (String this.moduleName, IrcHandler this.handler);
  
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


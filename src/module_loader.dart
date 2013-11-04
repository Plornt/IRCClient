part of IRCClient;

class ModuleHandler {
 List<ModuleContainer> modules = new List<ModuleContainer>();
 IrcHandler ircHandler;
 ModuleHandler (this.ircHandler);
 
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
  bool _loaded = false;
  bool active = true;
  String moduleFolder;
  
  // Metadata
  String moduleName = "";
  String moduleAuthor = "";
  String moduleDescription = "";
  String moduleImage = "";
  num moduleVersion = 0;
  
  
  ModuleContainer (String this.moduleFolder, ModuleHandler this.handler);
  
  void initialize () {
    File f = new File("modules/$moduleFolder/module.dart");
    if (f.existsSync()) {
      File _moduleDescription = new File("modules/$moduleFolder/module.json");
      if (_moduleDescription.existsSync()) {
        try {
          dynamic obj = new JsonDecoder(null).convert(_moduleDescription.readAsStringSync());
          if (obj != null) {
            if (obj["name"] != null && obj["name"] is String) { moduleName = obj["name"]; }
            if (obj["author"] != null && obj["author"] is String) { moduleAuthor = obj["author"]; }
            if (obj["description"] != null && obj["description"] is String) { moduleDescription = obj["description"]; }
            if (obj["image"] != null && obj["image"] is String) { moduleImage = obj["image"]; }
            if (obj["version"] != null && obj["version"] is num) { moduleVersion = obj["version"]; }
          }
        }
        catch (e) {
          // Dont stop the script running, not that important that the module has a proper json file
          print ("Malformed json file in module $moduleFolder");
        }
      }
      _port = new ReceivePort();
      SendPort sendPort = _port.sendPort;
      Isolate.spawnUri(Uri.parse(moduleFolder),[],sendPort).then((Isolate iso) { 
        _isolate = iso;
        _port.listen(handleMessage);
      });
    }
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
     else if (message is ISupportPacket) {
       message.parameters.forEach((k, v) { 
         this.handler.ircHandler.addISupportParameter(k, v);         
       });      
     }
  }
}


part of IRCClient;

class ModuleHandler {
 
  
}

class ModuleContainer {
  Module module;
  Isolate _isolate;
  String moduleName;
  bool _loaded = false;
  ModuleContainer (String this.moduleName);
  
  void initialize () {
    Isolate.spawnUri(Uri.parse(moduleName),[],"").then((Isolate iso) { 
      _loaded = true;
      
    });
  }
}


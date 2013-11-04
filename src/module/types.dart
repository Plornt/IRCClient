part of IrcModule;

class Target {
  
}
class ChannelName extends Target  {
  ChannelName (String server) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
  }
}
class ServerName extends Target {
  ServerName (String server) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
  }
}
class UserMode {
  UserMode (String mode) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
  }
}
class ChanModeValidator {
  static List<ChanModeValidator> modes = new List<ChanModeValidator>();
  final bool requiresParameter;
  final bool paramOnlyOnSet;
  final String modeText;
  ChanModeValidator (this.modeText, this.requiresParameter, this.paramOnlyOnSet) {
    modes.add(this);
  }
  static bool validate (String mode, String parameters) {
    bool valid = false;
    modes.forEach((e) {
      if (e.modeText == mode) {
        if (e.requiresParameter && (parameters == null || parameters == "")) {
          valid = false;
        }
        else valid = true;
      }
    });
    return valid;
  }
}
class ChanMode {
  bool add = true;
  String modeText = "";
  String params = "";
  ChanMode (String this.modeText, String this.params, bool this.add) {
    
  }
}
class RealName {
  RealName (String name) {
    // TODO: IMPLEMENT
    
  }
  String toString () {
    // TODO: IMPLEMENT
  }
}

class NicknamePrefix { 
    static List<NicknamePrefix> NickPrefixes = new List<NicknamePrefix>();
    final String prefix;
    final String modeText;
    NicknamePrefix (this.prefix, this.modeText) {
      NickPrefixes.add(this);
    }
}
class Nickname extends Target {
  Host hostname;
  String name;
  List<NicknamePrefix> prefixes = new List<NicknamePrefix>();
  Nickname (String nickname) {
    parseName(nickname);
  }
  Nickname.fromHostString (String splitter) {
   List<String> nickHost = splitter.split("!");
   if (splitter.length == 2) { 
     parseName(splitter[0]);
     this.hostname = new Host(splitter[1]);
   }
   else {
      throw "Does not match required syntax";     
   }
  } 
  void parseName (String nickname) {
    int nameStarts = 0;
    for (int x = 0; x < name.length; x++) {
      NicknamePrefix.NickPrefixes.forEach((prefix) {
         if (name[x] == prefix.prefix) {
           prefixes.add(prefix);
         }
         else nameStarts = x;
      });
      if (nameStarts != 0) break;
    }
    this.name = name.substring(nameStarts);
  }
  String toString () {
    // TODO: IMPLEMENT
  }
}
class Host extends Target {
  Host (String host) {
    // TODO: IMPLEMENT
    
  }
  String toString () {
    // TODO: IMPLEMENT
  }
}

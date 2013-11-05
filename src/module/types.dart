part of IrcModule;

class Target {
  
}

class ChannelPrefix { 
  static List<ChannelPrefix> prefixes = new List<ChannelPrefix>();
  
  static bool isChannel (String name) { 
    for (int i = 0; i<prefixes.length;i++) {
      if (prefixes[i].prefix == name[0]) {
        return true;
      }
    }
    return false;
  }
  
  final String prefix;
  ChannelPrefix (String this.prefix) {
    prefixes.add(this);
  }
}
class ChannelName extends Target  {
  ChannelPrefix prefix;
  String channel;
  ChannelName (String this.channel) {

    //TODO: IMPLEMENT
  }
  String toString () {
    return channel;
  }
}
class ServerName extends Target {
  String server;
  ServerName (String this.server) {

    //TODO: IMPLEMENT
  }
  String toString () {
    return server;
  }
}
class UserMode {
  String mode;
  UserMode (String this.mode) {

    //TODO: IMPLEMENT
  }
  String toString () {
    return mode;
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
   if (nickname.length > 0) {
    int nameStarts = 0;
    for (int x = 0; x < nickname.length; x++) {
      NicknamePrefix.NickPrefixes.forEach((prefix) {
         if (nickname[x] == prefix.prefix) {
           prefixes.add(prefix);
         }
         else nameStarts = x;
      });
      if (nameStarts != 0) break;
    }
    this.name = nickname.substring(nameStarts);
   }
  }
  String toString () {
    return this.name;
  }
}
class Host extends Target {
  String host;
  Host (String this.host) {
    // TODO: IMPLEMENT
    
  }
  String toString () {
    return this.host;
  }
}

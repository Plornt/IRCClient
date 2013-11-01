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
class ChannelMode {
  bool add = true;
  String modeText = "";
  String params = "";
  ChannelMode (String mode) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
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
class Nickname extends Target {
  Host hostname;
  String name;
  Nickname (String name) {
    // TODO: IMPLEMENT
    name = name;
  }
  Nickname.fromHostString (String splitter) {
   List<String> nickHost = splitter.split("!");
   if (splitter.length == 2) { 
     this.name = splitter[0];
     this.hostname = new Host(splitter[1]);
   }
   else {
      throw "Does not match required syntax";     
   }
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

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
  Nickname (String name) {
    // TODO: IMPLEMENT
    
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

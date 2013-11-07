library TestModule;

import '../../module/main.dart';

void main (args, ModuleStartPacket packet) { 
  TestModule cm = new TestModule(packet);
}

class TestModule extends Module {
  String serverPassword;
  int state = 0;
  String prevTestedNick = "";
  TestModule (ModuleStartPacket packet):super(packet) {
    serverPassword = packet.serverPassword;
   
    
  }
  
  bool onChannelMessage (Target user, PrivMsgCommand command) {
    if (command.get(0) == "!disconnect") {
      this.sendCommand(new QuitCommand("BYE CRUEL WORLD"));
    }
  }
  bool onChannelJoin (Target user, JoinCommand command) {
    if (user is Nickname) {
      print("Name received: ${user.name}");
      if (user.name == this.getBotName().name) {
        ChannelName lobby = new ChannelName("#Lobby");
        if (command.channels.keys.elementAt(0).channel == "#Lobby") {
          this.sendCommand(new PartCommand(lobby, "I am a bot! :("));
        }
      }
    }
    
  }
  bool onConnect () {
    this.sendCommand(new JoinCommand(new ChannelName("#Mugs")));
  }
}



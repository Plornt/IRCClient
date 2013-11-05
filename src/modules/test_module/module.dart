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
  
  bool onChannelPrivMsg (Target user, PrivMsgCommand command) {
    List<String> msg = command.message.split(" ");
    if (msg[0] == "!test") {
      this.sendCommand(new PrivMsgCommand(command.target, "I am here ${user}!"));
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
        else if (command.channels.keys.elementAt(0).channel == "#zstaff") {
          this.sendCommand(new PrivMsgCommand(new ChannelName("#Zstaff"), "Test!"));
        }
      }
    }
  }
  bool onConnect () {
    this.sendCommand(new JoinCommand(new ChannelName("#Zstaff")));
  }
}



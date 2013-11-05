import '../../module/main.dart';
import 'database.dart';


void main (args, ModuleStartPacket packet) { 
  TestModule cm = new TestModule(packet);
}

class TestModule extends Module {
  TestModule (ModuleStartPacket packet):super(packet) {
    
  }
  
  bool onChannelMessage (Target user, PrivMsgCommand command) {
    if (command.get(0) == "!test") {
      this.sendCommand(new PrivMsgCommand(command.target, "I am here ${user}!"));
    }
  }
  bool onChannelJoin (Target user, JoinCommand command) {
 
  }
  bool onConnect () {
    
  }
}



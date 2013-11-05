import '../../module/main.dart';
import 'id_commands.dart';
import 'dart:async';


void main (args, ModuleStartPacket packet) { 
  TestModule cm = new TestModule(packet);
}

class TestModule extends Module {
  TestModule (ModuleStartPacket packet):super(packet) {
    
  }
  
  bool onChannelMessage (Nickname user, PrivMsgCommand command) {
    if (command.get(0) == "!id") {
      String name = (command.get(1) != "" ? command.get(1) : user.name);
      getID(name).then((int id) { 
        if (id == null) {
          this.SendMessage(command.target, "${user.name} there is no ID associated with that name, please add it with !addid $name <id>");
        }
        else this.SendMessage(command.target, "$name's ID: $id");
      });
    }
    else if (command.get(1) == "!addid") {
      String name = (command.get(2) != "" ? command.get(1) : user.name);
      getID(name).then((int id) {      
        if (id != null) {
          this.SendMessage(command.target, "${user.name}, $id is already associated with that name. Please ask an operator if thats incorrect");
        }
        else {
          String id = (command.get(2) != "" ? command.get(2) : command.get(1));
          addID(name, id);
          this.SendMessage(command.target, "${user.name}, associated the ID $id with the name $name");
        }
      });
    }    
  }
  bool onChannelJoin (Target user, JoinCommand command) {
 
  }
  bool onConnect () {
    
  }
}



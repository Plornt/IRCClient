library CoreTornModule;

import '../../module/main.dart';
import 'database.dart';
import 'core_lib.dart';
import 'dart:async';

String theme = "${k}03";
void main (args, ModuleStartPacket packet) { 
  CoreModule.idCommands.add("!id");
  Language.add("ID_!id", "");
  
  Language.add("ID_ADDED", "${theme}Added ${b}&1's${b} ID as${b} &2");
  Language.add("ID_INVALID", "${theme}Invalid parameters. Please use ${b}!addid ${u}Nick${u} ${u}ID${u}");
  Language.add("ID_DELETED", "${theme}Deleted ${b}&1's${b} ID.");
  Language.add("ID_NO_ID", "${theme}There is no ID for that nick given. You can add their ID with ${b}!addid ${u}Nick${u} ${u}ID${u}");
  Language.add("ID_NO_OP_INVALID", "${theme}You are not op or you did not enter a valid nickname to delete. Please use: ${b}!delid ${u}Nick${u}");
  Language.add("ID_ALREADY_ADDED", "${theme}${b}&1's${b} ID is already added as${b} &2${b}. If this is incorrect please ask an op to remove it.");
  Language.add("ID_COMMAND_THEME", "${theme}&1");
  CoreModule cm = new CoreModule(packet);
}

class CoreModule extends Module {
  static  List<String> idCommands = new List<String>();

  CoreModule (ModuleStartPacket packet):super(packet) {
    
  }
  
  bool onChannelMessage (Nickname user, PrivMsgCommand command) {
     if (command.get(0) == "!addid") {
      String name = (command.get(2) != "" ? command.get(1) : user.name);
      getID(name).then((int id) {      
        if (id != null) {
          this.SendMessage(command.target, Language.get("ID_ALREADY_ADDED", [name, id]));
        }
        else {
          String id = (command.get(2) != "" ? command.get(2) : command.get(1));
          addID(name, id);
          this.SendMessage(command.target, Language.get("ID_ADDED", [name, id]));
        }
      });
    }    
    else if (command.get(0) == "!delid") {
       if (user.isOp) {
         if (command.get(1).isNotEmpty) {
           deleteID(command.get(1));
           this.SendMessage(command.target, Language.get("ID_DELETED", [command.get(1)]));
         }
         else this.SendMessage(command.target, Language.get("ID_NO_OP_INVALID", []));
       }
       else this.SendMessage(command.target, Language.get("ID_NO_OP_INVALID", []));
    }
    else if (idCommands.contains(command.get(0))) {
      String name = (command.get(1).isNotEmpty ? command.get(1) : user.name);
      getID(name).then((int id) {      
        if (id == null) {
          this.SendMessage(command.target, Language.get("ID_NO_ID", [name]));
        }
        else {
          this.SendMessage(command.target, Language.get("ID_${command.get(0)}", [name, id]));
        }
      });
    }
  }
  bool onChannelJoin (Target user, JoinCommand command) {
    
  }
  bool onConnect () {
    
  }
}



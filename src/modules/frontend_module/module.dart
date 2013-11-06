import '../../module/main.dart';
import 'dart:io'
import 'dart:async';


void main (args, ModuleStartPacket packet) { 
  
  FrontEndModule fem = new FrontEndModule(packet);
}

class FrontEndModule extends Module {
  FrontEndModule (ModuleStartPacket packet):super(packet) {
    
  }
  
  bool onChannelMessage (Nickname user, PrivMsgCommand command) {
    
  }
  bool onChannelJoin (Target user, JoinCommand command) {
    
  }
  bool onConnect () {
    
  }
}



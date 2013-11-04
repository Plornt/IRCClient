import '../../module/main.dart';

void main (args, ModuleStartRequest packet) { 
  ConnectionModule cm = new ConnectionModule(packet);
}

class ConnectionModule extends Module {
  ConnectionModule (ModuleStartRequest packet):super(packet) {
    
  }
  bool onReceiveRaw (int code, String packet) {
    if (code == NUMERIC_REPLIES.RPL_BOUNCE_OR_ISUPPORT) {
      // Following is the only way to check if its a bounce or isupport that I know of
      // Worst... Protocol... EVER.
        if (packet.contains("is supported on this server")) {
          ISupportParser parser = new ISupportParser.parse(packet);
          this.sendPacket(new ISupportPacket(parser.parameters));
        }
        
    }
  }
}



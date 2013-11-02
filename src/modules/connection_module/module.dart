import '../../module/main.dart';

void main (args, SendPortRequest packet) { 
  ConnectionModule cm = new ConnectionModule(packet);
}

class ConnectionModule extends Module {
  ConnectionModule (SendPortRequest packet):super(packet) {
  }
  bool onReceiveRaw (int code, String packet) {
    if (code == NUMERIC_REPLIES.RPL_BOUNCE) {
      List<String> params = packet.split(" ");
      
    }
  }
}

class Numeric5Parser {
 Map<String, dynamic> parameters = new Map<String, dynamic>();
 Numeric5Parser.parse (String params) {
   List<String> splitParam = params.split(" ");
   splitParam.forEach( (String param) {
       List<String> furtherParam = params.split("=");
       switch (furtherParam[0]) {
         case NUMERIC5_PARAM.PREFIX: 
           Map<String, String> modes = new Map<String,String>();
           String 
            
           break;
         case NUMERIC5_PARAM.PREFIX: 
           
           break;
         case NUMERIC5_PARAM.PREFIX: 
           
           break;
         case NUMERIC5_PARAM.PREFIX: 
           
           break;
         case NUMERIC5_PARAM.PREFIX: 
           
           break;
         case NUMERIC5_PARAM.PREFIX: 
           
           break;
       }
   });
   
 }
}






import '../../module/main.dart';

void main (args, SendPortRequest packet) { 
  ConnectionModule cm = new ConnectionModule(packet);
}

class ConnectionModule extends Module {
  ConnectionModule (SendPortRequest packet):super(packet) {
  }
  bool onReceiveRaw (int code, String packet) {
    if (code == NUMERIC_REPLIES.RPL_BOUNCE_OR_ISUPPORT) {
              
    }
  }
}

class ISupportResponse {
 Map<String, dynamic> parameters = new Map<String, dynamic>();
 ISupportResponse.parse (String params) {
   List<String> splitParam = params.split(" ");
   splitParam.forEach( (String param) {
       List<String> furtherParam = params.split("=");
       bool error = false;
       switch (furtherParam[0]) {
         case ISUPPORT_PARAMS.PREFIX: 
             List<List<String>> modes = new List<List<String>>();
             if (furtherParam.length > 1) { 
               String modeStr = furtherParam[1];
               if (modeStr[0] == "(") {
                 for (var i = 0; i < ((modeStr.length - 2) / 2); i++) {
                   modes[i] = new List<String>();
                   modes[i][0] = modeStr[i];
                 }
                 for (var i = ((modeStr.length - 2) / 2); i < modeStr.length; i++) {
                   modes[i - ((modeStr.length - 2) / 2)] = new List<String>();
                   modes[i - ((modeStr.length - 2) / 2)][1] = modeStr[i];
                 }
                 parameters[ISUPPORT_PARAMS.PREFIX] = modes;
               }
               else error = true;
             }
             else error = true;
           break;
         case ISUPPORT_PARAMS.CHAN_TYPES: 
             if (furtherParam.length == 2) {
              parameters[ISUPPORT_PARAMS.CHAN_TYPES] = furtherParam[1].split("");
             }
             else error = true;
           break;
         case ISUPPORT_PARAMS.CHAN_MODES: 
             if (furtherParam.length == 2) {
              List<String> splitModes = furtherParam[1].split(",");
              if (splitModes.length == 4) {
                
              }
              else error = true;
             }
             else error = true;
            break;
         case ISUPPORT_PARAMS.PREFIX: 
           
           break;
         case ISUPPORT_PARAMS.PREFIX: 
           
           break;
         case ISUPPORT_PARAMS.PREFIX: 
           
           break;
       }
       if (error) throwError ("Malformed ISupport Message: $params");
   });
   
 }
}






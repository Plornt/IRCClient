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
                parameters[ISUPPORT_PARAMS.CHAN_MODES] = splitModes;  
              }
              else error = true;
             }
             else error = true;
            break;
         case ISUPPORT_PARAMS.MODES: 
           int maxModes = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (maxModes > 0) {
             parameters[ISUPPORT_PARAMS.MODES] = maxModes;
           }
           break;
         case ISUPPORT_PARAMS.MAX_CHANNELS: 
           int maxChannels = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (maxChannels > 0) {
             parameters[ISUPPORT_PARAMS.MAX_CHANNELS] = maxChannels;
           }
           break;
         case ISUPPORT_PARAMS.CHAN_LIMIT: 
           List<String> splitLimits = furtherParam[1].split(",");
           Map<String, int> limits = new Map<String, int>();
           splitLimits.forEach((String limitStr) {
             List<String> prefixToLimit = limitStr.split(":");
             if (prefixToLimit == 2) {
               int maxChannels = int.parse(prefixToLimit[1], onError: (String s) { error = true; });
               List<String> splitPrefix = prefixToLimit[0].split("");
               splitPrefix.forEach((e) { 
                 limits[e] = maxChannels;
               });
             }
           });
           if (limits.length > 0) parameters[ISUPPORT_PARAMS.CHAN_LIMIT] = limits;
           break;
         case ISUPPORT_PARAMS.NICK_LENGTH: 
           int nickLen = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (nickLen > 0) {
             parameters[ISUPPORT_PARAMS.NICK_LENGTH] = nickLen;
           }  
           break;
         case ISUPPORT_PARAMS.MAX_BANS: 
           int maxBans = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (maxBans > 0) {
             parameters[ISUPPORT_PARAMS.MAX_BANS] = maxBans;
           }  
           break;
         case ISUPPORT_PARAMS.MAX_LIST: 
           List<String> splitLimits = furtherParam[1].split(",");
           Map<String, int> limits = new Map<String, int>();
           splitLimits.forEach((String limitStr) {
             List<String> prefixToLimit = limitStr.split(":");
             if (prefixToLimit == 2) {
               int maxList = int.parse(prefixToLimit[1], onError: (String s) { error = true; });
               List<String> splitPrefix = prefixToLimit[0].split("");
               splitPrefix.forEach((e) { 
                 limits[e] = maxList;
               });
             }
           });
           if (limits.length > 0) parameters[ISUPPORT_PARAMS.MAX_LIST] = limits;
           break;
         case ISUPPORT_PARAMS.NETWORK: 
           if (furtherParam[1].length > 0) {
             parameters[ISUPPORT_PARAMS.NETWORK] = furtherParam[1];
           }
           break;
         case ISUPPORT_PARAMS.EXCEPTS: 
           if (furtherParam[1].length == 1) {
            parameters[ISUPPORT_PARAMS.EXCEPTS] = furtherParam[1];
           }
           break;
         case ISUPPORT_PARAMS.PREFIX: 
           
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






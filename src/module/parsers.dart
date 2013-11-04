part of IrcModule;

class ISupportParser {
 Map<String, dynamic> parameters = new Map<String, dynamic>();
 ISupportParser.parse (String params) {
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
         case ISUPPORT_PARAMS.INVEX: 
           if (furtherParam[1].length == 1) {
             parameters[ISUPPORT_PARAMS.INVEX] = furtherParam[1];
           }
           break;
         case ISUPPORT_PARAMS.WALL_CHANNEL_OPS: 
           parameters[ISUPPORT_PARAMS.WALL_CHANNEL_OPS] = true;
           break;
         case ISUPPORT_PARAMS.WALL_VOICES: 
           parameters[ISUPPORT_PARAMS.WALL_VOICES] = true;
           break;
         case ISUPPORT_PARAMS.STATUS_MESSAGE: 
           if (furtherParam[1].length > 0) { 
            parameters[ISUPPORT_PARAMS.STATUS_MESSAGE] = furtherParam[1].split("");
           }
           break;
         case ISUPPORT_PARAMS.CASE_MAPPING: 
           if (furtherParam[1].length > 0) {
             parameters[ISUPPORT_PARAMS.CASE_MAPPING] = furtherParam[1];
           }
           break;
         case ISUPPORT_PARAMS.EXTENSIONS_LIST: 
           if (furtherParam[1].length > 0) { 
             parameters[ISUPPORT_PARAMS.EXTENSIONS_LIST] = furtherParam[1].split("");
           }
           break;
         case ISUPPORT_PARAMS.TOPIC_LENGTH: 
           int topicLength = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (topicLength > 0) {
             parameters[ISUPPORT_PARAMS.TOPIC_LENGTH] = topicLength;
           }  
           break;
         case ISUPPORT_PARAMS.KICK_LENGTH: 
           int kickLength = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (kickLength > 0) {
             parameters[ISUPPORT_PARAMS.KICK_LENGTH] = kickLength;
           }  
           break;
         case ISUPPORT_PARAMS.CHANNEL_LENGTH: 
           int channelLength = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (channelLength > 0) {
             parameters[ISUPPORT_PARAMS.CHANNEL_LENGTH] = channelLength;
           }  
           break;
         case ISUPPORT_PARAMS.CHANNEL_ID_LENGTH: 
           int channelIDLength = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (channelIDLength > 0) {
             parameters[ISUPPORT_PARAMS.CHANNEL_ID_LENGTH] = channelIDLength;
           }  
           break;
         case ISUPPORT_PARAMS.ID_CHANNEL: 
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
           if (limits.length > 0) parameters[ISUPPORT_PARAMS.ID_CHANNEL] = limits;
           break;
         case ISUPPORT_PARAMS.STANDARD: 
           if (furtherParam[1].length > 0) {
             parameters[ISUPPORT_PARAMS.STANDARD] = furtherParam[1];
           }
           break;
         case ISUPPORT_PARAMS.SILENCE: 
           int silenceLength = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (silenceLength > 0) {
             parameters[ISUPPORT_PARAMS.SILENCE] = silenceLength;
           }  
           break;
         case ISUPPORT_PARAMS.RFC2812: 
           parameters[ISUPPORT_PARAMS.RFC2812] = true;
           break;
         case ISUPPORT_PARAMS.PENALTY: 
           parameters[ISUPPORT_PARAMS.PENALTY] = true;
           break;
         case ISUPPORT_PARAMS.FNC: 
           parameters[ISUPPORT_PARAMS.FNC] = true;
           break;
         case ISUPPORT_PARAMS.SAFELIST: 
           parameters[ISUPPORT_PARAMS.SAFELIST] = true;
           break;
         case ISUPPORT_PARAMS.AWAY_LENGTH: 
           int awayLength = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (awayLength > 0) {
             parameters[ISUPPORT_PARAMS.AWAY_LENGTH] = awayLength;
           }  
           break;     
         case ISUPPORT_PARAMS.NO_QUIT: 
           parameters[ISUPPORT_PARAMS.NO_QUIT] = true;
           break;          
         case ISUPPORT_PARAMS.USER_IP: 
           parameters[ISUPPORT_PARAMS.USER_IP] = true;           
           break;          
         case ISUPPORT_PARAMS.CHANNEL_PRIVATE_MESSAGE: 
           parameters[ISUPPORT_PARAMS.CHANNEL_PRIVATE_MESSAGE] = true;               
           break;          
         case ISUPPORT_PARAMS.CHANNEL_NOTICE: 
           parameters[ISUPPORT_PARAMS.CHANNEL_NOTICE] = true;   
           break;          
         case ISUPPORT_PARAMS.MAX_NICK_LENGTH: 
           int maxNickLength = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (maxNickLength > 0) {
             parameters[ISUPPORT_PARAMS.MAX_NICK_LENGTH] = maxNickLength;
           }  
           break;          
         case ISUPPORT_PARAMS.MAX_TARGETS: 
           int maxTargets = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (maxTargets > 0) {
             parameters[ISUPPORT_PARAMS.MAX_TARGETS] = maxTargets;
           }  
           break;           
         case ISUPPORT_PARAMS.KNOCK: 
           parameters[ISUPPORT_PARAMS.KNOCK] = true;   
           break;           
         case ISUPPORT_PARAMS.VIRTUAL_CHANNELS: 
           parameters[ISUPPORT_PARAMS.VIRTUAL_CHANNELS] = true;   
           break;           
         case ISUPPORT_PARAMS.WATCH: 
           int maxWatch = int.parse(furtherParam[1], onError: (String s) { error = true; });
           if (maxWatch > 0) {
             parameters[ISUPPORT_PARAMS.WATCH] = maxWatch;
           }  
           break;            
         case ISUPPORT_PARAMS.WHOX: 
           parameters[ISUPPORT_PARAMS.WHOX] = true;   
           break;                 
         case ISUPPORT_PARAMS.CALLER_ID: 
           parameters[ISUPPORT_PARAMS.CALLER_ID] = true;   
           break;                 
         case ISUPPORT_PARAMS.ACCEPT: 
           parameters[ISUPPORT_PARAMS.CALLER_ID] = true;   
           break;                      
       }
       if (error) throwError ("Malformed ISupport Message: $params");
   });
   
 }
}



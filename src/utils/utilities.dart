import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

class ClientCommand {
  String description;
  String toString () {
    
  }
  void handleResponse () {
    
  }
}

/** 
 * 3.1.1 Password message
 *   
 *   Command: PASS
 *   Parameters: <password>
 *   
 *   The PASS command is used to set a 'connection password'.  The
 *   optional password can and MUST be set before any attempt to register
 *   the connection is made.  Currently this requires that user send a
 *   PASS command before sending the NICK/USER combination.
 *   
 *   Numeric Replies:
 *   
 *     ERR_NEEDMOREPARAMS - ERR_ALREADYREGISTRED
 *     
 *   Example:
 *   
 *      - PASS secretpasswordhere
 */
class PassCommand extends ClientCommand {
  String password = "";
  PassCommand (this.password) {
   
  }
  
  String toString () => "${CLIENT_COMMANDS.PASS} $password";
}


class NickCommand extends ClientCommand {
  Nickname nick;
  NickCommand(this.nick);
  String toString() => "${CLIENT_COMMANDS.NICK} ${nick}";
}

class UserCommand extends ClientCommand {
  Nickname nick;
  RealName realName;
  int mode;
  UserCommand(this.nick, this.mode, this.realName);
  String toString() => "${CLIENT_COMMANDS.USER} $nick $mode * :$realName";
}

class OperCommand extends ClientCommand {
  String name;
  String password;
  OperCommand (this.name, this.password);
  String toString () => "${CLIENT_COMMANDS.OPER} $name $password";
}


class UserModeCommand {
  UserMode mode;
  Nickname nickname;
  UserModeCommand (this.nickname, this.mode); 
  String toString () => "MODE $nickname $mode";
}


class ServiceCommand {
  String serviceName;
  String distribution;
  int type;
  String info;
  ServiceCommand(this.serviceName, this.distribution, this.type, this.info);
  String toString() => "${CLIENT_COMMANDS.SERVICE} $serviceName 0 $distribution $type 0 :$info";  
}


class QuitCommand {
  String quitMessage = "";
  QuitCommand ([this.quitMessage]);
  String toString () => "${CLIENT_COMMANDS.QUIT} :$quitMessage";
}

class SQuitCommand {
  ServerName server;
  String comment;
  SQuitCommand (this.server, this.comment);
  String toString () => "SQUIT $server :$comment";
  
}


/// Parameters: ( <channel> *( "," <channel> ) [ <key> *( "," <key> ) ] )
class JoinCommand extends ClientCommand {  
  Map<ChannelName, String> channels;
  bool zero = false;
  JoinCommand (ChannelName channel,[String key = ""]) {
    channels = new Map<ChannelName, String>();
    channels[channel] = key;
  }
  JoinCommand.fromMap (Map<ChannelName,String> this.channels);
  JoinCommand.joinZero () {
    zero = true;
  }
  String toString () {
    if (zero) return "${CLIENT_COMMANDS.JOIN} 0";
    else {
      String channelList = "";
      String keyList = "";
    channels.forEach((ChannelName chname, String key) { 
        channelList = "$channelList${(channelList == "" ? "" : ",")}$chname";
        keyList = "$keyList${(keyList == "" ? "" : ",")}$key";
      });
    return "${CLIENT_COMMANDS.JOIN} $channelList $keyList";
    }
  }
}

/// Parameters: <channel> *( "," <channel> ) [ <Part Message> ]
class PartCommand extends ClientCommand {
  List<ChannelName> channels;
  String partMessage;
  PartCommand (ChannelName channel, [this.partMessage = ""]) {
    channels = new List<ChannelName>();
    channels.add(channel);
  }
  PartCommand.fromList (List<ChannelName> this.channels, [partMessage = ""]);
  String toString () {
    String channelList = "";
    channels.forEach((ChannelName chname) { 
        channelList = "$channelList${(channelList == "" ? "" : ",")}$chname";
      });
    return "${CLIENT_COMMANDS.PART} $channelList :$partMessage";
  }
}

/// Parameters: <channel> *( ( "-" / "+" ) *<modes> *<modeparams> )
//TODO: IMPLEMENT CHANNEL MODE COMMAND - TAKES FOREVER - SKIPPING FOR NOW
class ChannelModeCommand extends ClientCommand {
ChannelModeCommand ();
String toString () => "";
}

/// Parameters: <channel> [ <topic> ]
class TopicCommand extends ClientCommand {
  ChannelName channel;
  String topic;
  TopicCommand.setTopic (ChannelName this.channel, String this.topic);
  TopicCommand.getTopic (ChannelName this.channel);
  String toString () => "${CLIENT_COMMANDS.TOPIC} $channel${(topic != null ? " :$topic":"")}";
}

/// Parameters: [ <channel> *( "," <channel> ) [ <target> ] ]
class NamesCommand extends ClientCommand {
NamesCommand ();
String toString () => "";
}

/// Parameters: [ <channel> *( "," <channel> ) [ <target> ] ]
class LISTCommand extends ClientCommand {
LISTCommand ();
String toString () => "";
}

/// Parameters: <nickname> <channel>
class INVITECommand extends ClientCommand {
INVITECommand ();
String toString () => "";
}

/// Parameters: <channel> *( "," <channel> ) <user> *( "," <user> )
class KICKCommand extends ClientCommand {
KICKCommand ();
String toString () => "";
}

/// Parameters: <msgtarget> <text to be sent>
class PRIVMSGCommand extends ClientCommand {
PRIVMSGCommand ();
String toString () => "";
}

/// Parameters: <msgtarget> <text>
class NOTICECommand extends ClientCommand {
NOTICECommand ();
String toString () => "";
}

/// Parameters: [ <target> ]
class MOTDCommand extends ClientCommand {
MOTDCommand ();
String toString () => "";
}

/// Parameters: [ <mask> [ <target> ] ]
class LUSERSCommand extends ClientCommand {
LUSERSCommand ();
String toString () => "";
}

/// Parameters: [ <target> ]
class VERSIONCommand extends ClientCommand {
VERSIONCommand ();
String toString () => "";
}

/// Parameters: [ <query> [ <target> ] ]
class STATSCommand extends ClientCommand {
STATSCommand ();
String toString () => "";
}

/// Parameters: [ [ <remote server> ] <server mask> ]
class LINKSCommand extends ClientCommand {
LINKSCommand ();
String toString () => "";
}

/// Parameters: [ <target> ]
class TIMECommand extends ClientCommand {
TIMECommand ();
String toString () => "";
}

/// Parameters: <target server> <port> [ <remote server> ]
class CONNECTCommand extends ClientCommand {
CONNECTCommand ();
String toString () => "";
}

/// Parameters: [ <target> ]
class TRACECommand extends ClientCommand {
TRACECommand ();
String toString () => "";
}

/// Parameters: [ <target> ]
class ADMINCommand extends ClientCommand {
ADMINCommand ();
String toString () => "";
}

/// Parameters: [ <target> ]
class INFOCommand extends ClientCommand {
INFOCommand ();
String toString () => "";
}

/// Parameters: [ <mask> [ <type> ] ]
class SERVLISTCommand extends ClientCommand {
SERVLISTCommand ();
String toString () => "";
}

/// Parameters: <servicename> <text>
class SQUERYCommand extends ClientCommand {
SQUERYCommand ();
String toString () => "";
}

/// Parameters: [ <mask> [ "o" ] ]
class WHOCommand extends ClientCommand {
WHOCommand ();
String toString () => "";
}

/// Parameters: [ <target> ] <mask> *( "," <mask> )
class WHOISCommand extends ClientCommand {
WHOISCommand ();
String toString () => "";
}

/// Parameters: <nickname> *( "," <nickname> ) [ <count> [ <target> ] ]
class WHOWASCommand extends ClientCommand {
WHOWASCommand ();
String toString () => "";
}

/// Parameters: <nickname> <comment>
class KILLCommand extends ClientCommand {
KILLCommand ();
String toString () => "";
}

/// Parameters: <server1> [ <server2> ]
class PINGCommand extends ClientCommand {
PINGCommand ();
String toString () => "";
}

/// Parameters: <server> [ <server2> ]
class PONGCommand extends ClientCommand {
PONGCommand ();
String toString () => "";
}

/// Parameters: <error message>
class ERRORCommand extends ClientCommand {
ERRORCommand ();
String toString () => "";
}

/// Parameters: [ <text> ]
class AWAYCommand extends ClientCommand {
AWAYCommand ();
String toString () => "";
}

/// Parameters: None
class REHASHCommand extends ClientCommand {
REHASHCommand ();
String toString () => "";
}

/// Parameters: None
class DIECommand extends ClientCommand {
DIECommand ();
String toString () => "";
}

/// Parameters: None
class RESTARTCommand extends ClientCommand {
RESTARTCommand ();
String toString () => "";
}

/// Parameters: <user> [ <target> [ <channel> ] ]
class SUMMONCommand extends ClientCommand {
SUMMONCommand ();
String toString () => "";
}

/// Parameters: [ <target> ]
class USERSCommand extends ClientCommand {
USERSCommand ();
String toString () => "";
}

/// Parameters: <Text to be sent>
class WALLOPSCommand extends ClientCommand {
WALLOPSCommand ();
String toString () => "";
}

/// Parameters: <nickname> *( SPACE <nickname> )
class USERHOSTCommand extends ClientCommand {
USERHOSTCommand ();
String toString () => "";
}

/// Parameters: <nickname> *( SPACE <nickname> )
class ISONCommand extends ClientCommand {
ISONCommand ();
String toString () => "";
}

class ChannelName {
  ChannelName (String server) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
  }
}
class ServerName {
  ServerName (String server) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
  }
}
class UserMode {
  UserMode (String mode) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
  }
}
class ChannelMode {
  ChannelMode (String mode) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
  }
}
class RealName {
  RealName (String name) {
    // TODO: IMPLEMENT
    
  }
  String toString () {
    // TODO: IMPLEMENT
  }
}
class Nickname {
  Nickname (String name) {
    // TODO: IMPLEMENT
    
  }
  String toString () {
    // TODO: IMPLEMENT
  }
}
class Host {
  Host (String host) {
    // TODO: IMPLEMENT
    
  }
  String toString () {
    // TODO: IMPLEMENT
  }
}


class STRINGS {
  static RegExp servername;
  static RegExp nickname;
  static RegExp host;
  static RegExp message;
  static RegExp prefix;
  static RegExp mode;
  static RegExp nospcrlfcl;
  static RegExp middle;
  static RegExp trailing;
  static String space = " ";
  static String crlf = new Utf8Decoder().convert([13,10]);
}


class CLIENT_COMMANDS {
  static String PASS = "PASS";
  static String NICK = "NICK";
  static String USER = "USER";
  static String OPER = "OPER";
  static String USER_MODE = "MODE";
  static String SERVICE = "SERVICE";
  static String QUIT = "QUIT";
  static String SQUIT = "SQUIT";
  static String JOIN = "JOIN";
  static String PART = "PART";
  static String CHAN_MODE = "MODE";
  static String TOPIC = "TOPIC";
  static String NAMES = "NAMES";
  static String LIST = "LIST";
  static String INVITE = "INVITE";
  static String KICK = "KICK";
  static String PRIV_MSG = "SQUIT";
  static String NOTICE = "NOTICE";
  static String MOTD = "MOTD";
  static String L_USERS = "LUSERS";
  static String VERSION = "VERSION";
  static String STATS = "STATS";
  static String LINKS = "LINKS";
  static String TIME = "TIME";
  static String CONNECT = "CONNECT";
  static String TRACE = "TRACE";
  static String ADMIN = "ADMIN";
  static String INFO = "INFO";
  static String SERV_LIST = "SERVLIST";
  static String SQUERY = "SQUERY";
  static String WHO = "WHO";
  static String WHO_IS = "WHOIS";
  static String WHO_WAS = "WHOWAS";
  static String KILL = "KILL";
  static String PING = "PING";
  static String PONG = "PONG";
  static String ERROR = "ERROR";
  static String AWAY = "AWAY";
  static String REHASH = "REHASH";
  static String DIE = "DIE";
  static String RESTART = "RESTART";
  static String SUMMON= "SUMMON";
  static String USERS = "USERS";
  static String WALL_OPS = "WALLOPS";
  static String USER_HOST = "USERHOST";
  static String IS_ON = "ISON";
  
}

class NUMERIC_REPLIES {
  // Errors

  static int ERR_NOSUCHNICK = 401;
  static int ERR_NOSUCHSERVER = 402;
  static int ERR_NOSUCHCHANNEL = 403;
  static int ERR_CANNOTSENDTOCHAN = 404;
  static int ERR_TOOMANYCHANNELS = 405;
  static int ERR_WASNOSUCHNICK = 406;
  static int ERR_TOOMANYTARGETS = 407;
  static int ERR_NOSUCHSERVICE = 408;
  static int ERR_NOORIGIN = 409;
  static int ERR_NORECIPIENT = 411;
  static int ERR_NOTEXTTOSEND = 412;
  static int ERR_NOTOPLEVEL = 413;
  static int ERR_WILDTOPLEVEL = 414;
  static int ERR_BADMASK = 415;
  static int ERR_UNKNOWNCOMMAND = 421;
  static int ERR_NOMOTD = 422;
  static int ERR_NOADMININFO = 423;
  static int ERR_FILEERROR = 424;
  static int ERR_NONICKNAMEGIVEN = 431;
  static int ERR_ERRONEUSNICKNAME = 432;
  static int ERR_NICKNAMEINUSE = 433;
  static int ERR_NICKCOLLISION = 436;
  static int ERR_UNAVAILRESOURCE = 437;
  static int ERR_USERNOTINCHANNEL = 441;
  static int ERR_NOTONCHANNEL = 442;
  static int ERR_USERONCHANNEL = 443;
  static int ERR_NOLOGIN = 444;
  static int ERR_SUMMONDISABLED = 445;
  static int ERR_USERSDISABLED = 446;
  static int ERR_NOTREGISTERED = 451;
  static int ERR_NEEDMOREPARAMS = 461;
  static int ERR_ALREADYREGISTRED = 462;
  static int ERR_NOPERMFORHOST = 463;
  static int ERR_PASSWDMISMATCH = 464;
  static int ERR_YOUREBANNEDCREEP = 465;
  static int ERR_YOUWILLBEBANNED = 466;
  static int ERR_KEYSET = 467;
  static int ERR_CHANNELISFULL = 471;
  static int ERR_UNKNOWNMODE = 472;
  static int ERR_INVITEONLYCHAN = 473;
  static int ERR_BANNEDFROMCHAN = 474;
  static int ERR_BADCHANNELKEY = 475;
  static int ERR_BADCHANMASK = 476;
  static int ERR_NOCHANMODES = 477;
  static int ERR_BANLISTFULL = 478;
  static int ERR_NOPRIVILEGES = 481;
  static int ERR_CHANOPRIVSNEEDED = 482;
  static int ERR_CANTKILLSERVER = 483;
  static int ERR_RESTRICTED = 484;
  static int ERR_UNIQOPPRIVSNEEDED = 485;
  static int ERR_NOOPERHOST = 491;
  static int ERR_UMODEUNKNOWNFLAG = 501;
  static int ERR_USERSDONTMATCH = 502;
  
  // Replies
  static int RPL_WELCOME = 001;
  static int RPL_YOUREHOST = 002;
  static int RPL_CREATED = 003;
  static int RPL_MYINFO = 004;
  static int RPL_BOUNCE = 005;
  static int RPL_USERHOST = 302;
  static int RPL_ISON = 303;
  static int RPL_AWAY = 301;
  static int RPL_UNAWAY = 305;
  static int RPL_NOWAWAY = 306;
  static int RPL_WHOISUSER = 311;
  static int RPL_WHOISSERVER = 312;
  static int RPL_WHOISOPERATOR = 313;
  static int RPL_WHOISIDLE = 317;
  static int RPL_ENDOFWHOIS = 318;
  static int RPL_WHOISCHANNELS = 319;
  static int RPL_WHOWASUSER = 314;
  static int RPL_ENDOFWHOWAS = 369;
  /// DEPRECIATED
  static int RPL_LISTSTART = 321;
  static int RPL_LIST = 322;
  static int RPL_LISTEND = 323;
  static int RPL_UNIQOPIS = 325;
  static int RPL_CHANNELMODEIS = 324;
  static int RPL_INVITING = 341;
  static int RPL_SUMMONING = 342;
  static int RPL_INVITELIST = 346;
  static int RPL_ENDOFINVITELIST = 347;
  static int RPL_EXCEPTLIST = 348;
  static int RPL_ENDOFEXCEPTLIST = 349;
  static int RPL_VERSION = 351;
  static int RPL_WHOREPLY = 352;
  static int RPL_ENDOFWHO = 315;
  static int RPL_NAMREPLY = 353;
  static int RPL_ENDOFNAMES = 366;
  static int RPL_LINKS = 364;
  static int RPL_ENDOFLINKS = 365;
  static int RPL_BANLIST = 367;
  static int RPL_ENDOFBANLIST = 368;
  static int RPL_INFO = 371;
  static int RPL_ENDOFINFO = 374;
  static int RPL_MOTDSTART = 375;
  static int RPL_MOTD = 372;
  static int RPL_ENDOFMOTD = 376;
  static int RPL_YOUREOPER = 381;
  static int RPL_REHASHING = 382;
  static int RPL_YOURESERVICE = 383;
  static int RPL_TIME = 391;
  static int RPL_USERSSTART = 392;
  static int RPL_USERS = 393;
  static int RPL_ENDOFUSERS = 394;
  static int RPL_NOUSERS = 395;
  static int RPL_TRACELINK = 200;
  static int RPL_TRACECONNECTING = 201;
  static int RPL_TRACEHANDSHAKE = 202;
  static int RPL_TRACEUNKNOWN = 203;
  static int RPL_TRACEOPERATOR = 204;
  static int RPL_TRACEUSER = 205;
  static int RPL_TRACESERVER = 206;
  static int RPL_TRACESERVICE = 207;
  static int RPL_TRACENEWTYPE = 208;
  static int RPL_TRACECLASS = 209;
  static int RPL_TRACERECONNECT = 210;
  static int RPL_TRACELOG = 261;
  static int RPL_TRACEEND = 262;
  static int RPL_STATSLINKINFO = 211;
  static int RPL_STATSCOMMANDS = 212;
  static int RPL_ENDOFSTATS = 219;
  static int RPL_STATSUPTIME = 242;
  static int RPL_STATSOLINE = 243;
  static int RPL_UMODEIS = 221;
  static int RPL_SERVLIST = 234;
  static int RPL_SERVLISTEND = 235;
  static int RPL_LUSERCLIENT = 251;
  static int RPL_LUSEROP = 252;
  static int RPL_LUSERUNKNOWN = 253;
  static int RPL_LUSERCHANNELS = 254;
  static int RPL_LUSERME = 255;
  static int RPL_ADMINME = 256;
  static int RPL_ADMINLOC1 = 257;
  static int RPL_ADMINLOC2 = 258;
  static int RPL_ADMINEMAIL = 259;
  static int RPL_TRYAGAIN = 263;
}
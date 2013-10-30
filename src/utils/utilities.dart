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

/***
 * 3.1.2 Nick message
 *    
 *  Command: NICK
 *  Parameters: <nickname>
 *
 *  NICK command is used to give user a nickname or change the existing
 *  one.
 *
 *
 *  Numeric Replies:
 *
 *          ERR_NONICKNAMEGIVEN             ERR_ERRONEUSNICKNAME
 *          ERR_NICKNAMEINUSE               ERR_NICKCOLLISION
 *          ERR_UNAVAILRESOURCE             ERR_RESTRICTED
 *
 *  Examples:
 *
 *  NICK Wiz                ; Introducing new nick "Wiz" if session is
 *                          still unregistered, or user changing his
 *                          nickname to "Wiz"
 *
 *  :WiZ!jto@tolsun.oulu.fi NICK Kilroy
 *                          ; Server telling that WiZ changed his
 *                          nickname to Kilroy.
 */
class NickCommand extends ClientCommand {
  Nickname nick;
  NickCommand(this.nick) {
    
  }
  String toString() => return "${CLIENT_COMMANDS.NICK} ${nick}";
}

/**
 *  3.1.3 User message

      Command: USER
   Parameters: <user> <mode> <unused> <realname>

   The USER command is used at the beginning of connection to specify
   the username, hostname and realname of a new user.

   The <mode> parameter should be a numeric, and can be used to
   automatically set user modes when registering with the server.  This
   parameter is a bitmask, with only 2 bits having any signification: if
   the bit 2 is set, the user mode 'w' will be set and if the bit 3 is
   set, the user mode 'i' will be set.  (See Section 3.1.5 "User
   Modes").

   The <realname> may contain space characters.

   Numeric Replies:

           ERR_NEEDMOREPARAMS              ERR_ALREADYREGISTRED

   Example:

   USER guest 0 * :Ronnie Reagan   ; User registering themselves with a
                                   username of "guest" and real name
                                   "Ronnie Reagan".

   USER guest 8 * :Ronnie Reagan   ; User registering themselves with a
                                   username of "guest" and real name
                                   "Ronnie Reagan", and asking to be set
                                  invisible.
                                  */
class UserCommand extends ClientCommand {
  Nickname nick;
  RealName realName;
  int mode;
  UserCommand(this.nick, this.mode, this.realName);
  String toString() => "${CLIENT_COMMANDS.USER} $nick $mode * :$realName";
}


/**
 *   3.1.4 Oper message
  
        Command: OPER
     Parameters: <name> <password>
  
     A normal user uses the OPER command to obtain operator privileges.
     The combination of <name> and <password> are REQUIRED to gain
     Operator privileges.  Upon success, the user will receive a MODE
     message (see section 3.1.5) indicating the new user modes.
  
     Numeric Replies:
  
             ERR_NEEDMOREPARAMS              RPL_YOUREOPER
             ERR_NOOPERHOST                  ERR_PASSWDMISMATCH
  
     Example:
  
     OPER foo bar                    ; Attempt to register as an operator
                                     using a username of "foo" and "bar"
                                     as the password
 */
class OperCommand extends ClientCommand {
  String name;
  String password;
  OperCommand (this.name, this.password);
  String toString () => "${CLIENT_COMMANDS.OPER} $name $password";
}


/**
 * 3.1.5 User mode message

      Command: MODE
   Parameters: <nickname>
               *( ( "+" / "-" ) *( "i" / "w" / "o" / "O" / "r" ) )

   The user MODE's are typically changes which affect either how the
   client is seen by others or what 'extra' messages the client is sent.

   A user MODE command MUST only be accepted if both the sender of the
   message and the nickname given as a parameter are both the same.  If
   no other parameter is given, then the server will return the current
   settings for the nick.

      The available modes are as follows:

           a - user is flagged as away;
           i - marks a users as invisible;
           w - user receives wallops;
           r - restricted user connection;
           o - operator flag;
           O - local operator flag;
           s - marks a user for receipt of server notices.

   Additional modes may be available later on.

   The flag 'a' SHALL NOT be toggled by the user using the MODE command,
   instead use of the AWAY command is REQUIRED.

   If a user attempts to make themselves an operator using the "+o" or
   "+O" flag, the attempt SHOULD be ignored as users could bypass the
   authentication mechanisms of the OPER command.  There is no
   restriction, however, on anyone `deopping' themselves (using "-o" or
   "-O").

   On the other hand, if a user attempts to make themselves unrestricted
   using the "-r" flag, the attempt SHOULD be ignored.  There is no
   restriction, however, on anyone `deopping' themselves (using "+r").
   This flag is typically set by the server upon connection for
   administrative reasons.  While the restrictions imposed are left up
   to the implementation, it is typical that a restricted user not be
   allowed to change nicknames, nor make use of the channel operator
   status on channels.

   The flag 's' is obsolete but MAY still be used.

   Numeric Replies:

           ERR_NEEDMOREPARAMS              ERR_USERSDONTMATCH
           ERR_UMODEUNKNOWNFLAG            RPL_UMODEIS

   Examples:

   MODE WiZ -w                     ; Command by WiZ to turn off
                                   reception of WALLOPS messages.

   MODE Angel +i                   ; Command from Angel to make herself
                                   invisible.

   MODE WiZ -o                     ; WiZ 'deopping' (removing operator
                                   status).
 */
class UserModeCommand {
  Mode mode;
  Nickname nickname;
  UserModeCommand (this.nickname, this.mode); 
  String toString () => "MODE $nickname $mode";
}


/**
 * 3.1.6 Service message

      Command: SERVICE
   Parameters: <nickname> <reserved> <distribution> <type>
               <reserved> <info>

   The SERVICE command to register a new service.  Command parameters
   specify the service nickname, distribution, type and info of a new
   service.


   The <distribution> parameter is used to specify the visibility of a
   service.  The service may only be known to servers which have a name
   matching the distribution.  For a matching server to have knowledge
   of the service, the network path between that server and the server
   on which the service is connected MUST be composed of servers which
   names all match the mask.

   The <type> parameter is currently reserved for future usage.

   Numeric Replies:

           ERR_ALREADYREGISTRED            ERR_NEEDMOREPARAMS
           ERR_ERRONEUSNICKNAME
           RPL_YOURESERVICE                RPL_YOURHOST
           RPL_MYINFO

   Example:

   SERVICE dict * *.fr 0 0 :French Dictionary ; Service registering
                                   itself with a name of "dict".  This
                                   service will only be available on
                                   servers which name matches "*.fr".
 */
class ServiceCommand {
  String serviceName;
  String distribution;
  int type;
  String info;
  ServiceCommand(this.serviceName, this.distribution, this.type, this.info);
  String toString() => "${CLIENT_COMMANDS.SERVICE} $serviceName 0 $distribution $type 0 :$info";  
}


/**
 * 3.1.7 Quit

      Command: QUIT
   Parameters: [ <Quit Message> ]

   A client session is terminated with a quit message.  The server
   acknowledges this by sending an ERROR message to the client.

   Numeric Replies:

           None.

   Example:

   QUIT :Gone to have lunch        ; Preferred message format.

   :syrk!kalt@millennium.stealth.net QUIT :Gone to have lunch ; User
                                   syrk has quit IRC to have lunch.
 * 
 */
class QuitCommand {
  String quitMessage = "";
  QuitCommand ([this.quitMessage]);
  String toString () => "${CLIENT_COMMANDS.QUIT} :$quitMessage";
}

/**
 * 3.1.8 Squit

      Command: SQUIT
   Parameters: <server> <comment>

   The SQUIT command is available only to operators.  It is used to
   disconnect server links.  Also servers can generate SQUIT messages on
   error conditions.  A SQUIT message may also target a remote server
   connection.  In this case, the SQUIT message will simply be sent to
   the remote server without affecting the servers in between the
   operator and the remote server.

   The <comment> SHOULD be supplied by all operators who execute a SQUIT
   for a remote server.  The server ordered to disconnect its peer
   generates a WALLOPS message with <comment> included, so that other
   users may be aware of the reason of this action.

   Numeric replies:

           ERR_NOPRIVILEGES                ERR_NOSUCHSERVER
           ERR_NEEDMOREPARAMS

   Examples:

   SQUIT tolsun.oulu.fi :Bad Link ?  ; Command to uplink of the server
                                   tolson.oulu.fi to terminate its
                                   connection with comment "Bad Link".

   :Trillian SQUIT cm22.eng.umd.edu :Server out of control ; Command
                                   from Trillian from to disconnect
                                   "cm22.eng.umd.edu" from the net with
                                   comment "Server out of control".
 */
class SQuitCommand {
  ServerName server;
  String comment;
  SQuitCommand (this.server, this.comment);
  String toString () => "SQUIT $server :$comment";
  
}




class ServerName {
  ServerName (String server) {
    
  }
  String toString () {
    //TODO: IMPLEMENT
  }
}
class Mode {
  Mode (String mode) {
    
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
  static int ERR_NEEDMOREPARAMS = 0;
  static int ERR_ALREADYREGISTERED = 0;
  static int ERR_NONICKNAMEGIVEN = 0;
  static int ERR_ERRONEUSNICKNAME = 0;
  static int ERR_NICKNAMEINUSE = 0;
  static int ERR_NICKCOLLISION = 0;
  static int ERR_UNAVAILRESOURCE = 0;
  static int ERR_RESTRICTED = 0;
  static int ERR_NOOPERHOST = 0;
  static int ERR_PASSWDMISMATCH = 0;
  static int ERR_UMODEUNKNOWNFLAG = 0;
  static int ERR_USERSDONTMATCH = 0;
  static int ERR_NOPRIVILEGES = 0;
  static int ERR_NOSUCHSERVER = 0;
  
  // Replies
  static int RPL_YOUREOPER = 0;
  static int RPL_UMODEIS = 0;
}
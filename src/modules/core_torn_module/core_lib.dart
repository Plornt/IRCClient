library CoreLib;

import 'database.dart';
import 'dart:async';
import '../../module/main.dart';

Future<int> getID (String username) {
  Completer c = new Completer();
  getDatabase().prepareExecute("SELECT id FROM ids WHERE nickname = ?", [username]).then((query) {
    bool done = false;
    query.stream.listen((val) { if (done == false) { c.complete(val[0]); done = true; } },
      onDone: () { if (done == false) c.complete(null); });
  });
  
  return c.future;
}




Future<dynamic> deleteID (String username) {
  return getDatabase().prepareExecute("DELETE FROM ids WHERE nickname = ?",[username]);
}

void addID (String username, String id) {
  getDatabase().prepareExecute("INSERT INTO ids (nickname, id) VALUES (?, ?)", [username, id]).then((e) {
    print(e);
  });
}


class ChannelCommandStatus {
  static void changeStatus (ChannelName channel, String identifier, int status) {
    getDatabase().prepareExecute("SELECT status FROM command_status WHERE channelName = ? AND commandTag = ?", [channel.toString(), identifier])
      .then((res) {
        bool hasRows = false;
        res.stream.listen((d) { 
          if (hasRows == false) getDatabase().prepareExecute("UPDATE command_status SET status = ? WHERE channelName = ? AND commandTag = ? ", [status, channel, identifier]);
          
          hasRows = true;
          }, onDone: () { 
          if (hasRows == false) {
            getDatabase().prepareExecute("INSERT INTO command_status (channelName, commandTag, status) VALUES (?,?,?)", [channel, identifier, status]);
          }
        });
      }); 
  }
  static void turnOn (ChannelName channel, String identifier) {
      changeStatus(channel, identifier, 1);
  }
  static void turnOff (ChannelName channel, String identifier) {
    changeStatus(channel, identifier, 0);
  }
  static Future<int> getStatus (ChannelName channel, String identifier) {
    Completer c = new Completer();
    getDatabase().prepareExecute("SELECT status FROM command_status WHERE channelName = ? AND commandTag = ?", [channel.toString(), identifier])
                 .then((res) { 
                   res.stream.listen((val) { 
                     c.complete(val[0]); 
                     res.stream.close();
                   },onDone: () { c.complete(0); });
                 });
    return c.future;
  }
  static Future<bool> isOn (ChannelName channel, String identifier) {
    Completer c = new Completer();
    getStatus(channel, identifier).then((int status) {
      if (status == 1) c.complete(true);
      else c.complete(false);
    });
    return c.future;
    
  }
  static Future<List<String>> getAllOn(String identifier) {
    Completer c = new Completer();
    List<String> on = new List<String>();
    getDatabase().prepareExecute("SELECT channelName FROM command_status WHERE commandTag = ? AND status = 1", [identifier])
                 .then((res) { 
                   res.stream.listen((val) { 
                     on.add(val[0]);
                   }, onDone: () {
                     c.complete(on);
                   });
                 });
    return c.future;
  }
  
}




class Language {
  static Map<String, String> language = new Map<String, String>();
  static void add (String key, String message) {
    language[key]  = message;
  }
  static String get (String key, List<dynamic> arguments) {
    if (language.containsKey(key)) {
      RegExp langMatch = new RegExp(r"&([0-9]+?)");
      int x = 0;
      String sentence = language[key].replaceAllMapped(langMatch, (Match match) {
          x = int.parse(match.group(1)) - 1;
          return arguments[x];
      });
      return sentence;
    }
    else return "Language file error";
  }
}

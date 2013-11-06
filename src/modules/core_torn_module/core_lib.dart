import 'database.dart';
import 'dart:async';


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

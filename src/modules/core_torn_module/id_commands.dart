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
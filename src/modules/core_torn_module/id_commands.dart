import 'database.dart';
import 'dart:async';


Future<int> getID (String username) {
  Completer c = new Completer();
  getDatabase().prepareExecute("SELECT id FROM ids WHERE nickname = ?", [username]).then((query) {
    query.stream.first.then((vals) {
      c.complete(vals[0]);
    });
    query.stream.length.then((int rows) {
      if (rows == 0) c.complete(null);
    });
  });
  
  return c.future;
}

Future<dynamic> deleteID (String username) {
  return getDatabase().prepareExecute("DELETE FROM ids WHERE nickname = ?",[username]);
}

void addID (String username, String id) {
  getDatabase().prepareExecute("INSERT INTO ids (nickname, id) VALUES (?, ?)", [username, id]);
}
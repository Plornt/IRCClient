library Permissions;
import '../core_torn_module/database.dart';

class Permissions {
  static Map<String, PermUser> levels = new Map<String, PermUser>();
  static void init () {
    getDatabase().query("SELECT permLevel, permID, username, password FROM admin").then((data) { 
      data.rows.listen((row) { 
        
      });
    });
  }
}

class PermUser {
  String name;
  String host;
  int permID;
  int permLevel;
  PermUser (this.name, this.host, this.permLevel, this.permID);
}
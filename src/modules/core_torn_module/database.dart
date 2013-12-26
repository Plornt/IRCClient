library Database;

import 'package:sqljocky/sqljocky.dart';

ConnectionPool _cached;
ConnectionPool getDatabase () {
  if (_cached == null)  _cached = new ConnectionPool(host: 'localhost', port: 3306, user: 'plornt', password: 'G&!WG2kQtDr6KFt', db: 'ircbot', max: 5);
  return _cached;
}
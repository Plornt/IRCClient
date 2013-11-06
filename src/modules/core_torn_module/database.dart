import 'package:sqljocky/sqljocky.dart';

ConnectionPool _cached;
ConnectionPool getDatabase () {
  if (_cached == null)  _cached = new ConnectionPool(host: 'localhost', port: 3307, user: 'plornt', password: 'B:@_30v<0[L).9s', db: 'ircbot', max: 5);
  return _cached;
}
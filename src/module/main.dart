library IrcModule;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

part 'types.dart';
part 'commands.dart';
part 'enum.dart';
part 'module_handler.dart';
part 'isolate_packet.dart';
part 'parsers.dart';

void throwError (String error) {
  throw "Error found: $error"
        "Please pass this message on to the developers of this IRCBot.";
}
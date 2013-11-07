library MugModule;

import '../../module/main.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:html5lib/parser.dart' show parse;
import 'package:html5lib/dom.dart';
import 'package:sqljocky/sqljocky.dart';
import '../core_torn_module/database.dart';
import '../core_torn_module/core_lib.dart';


void main (args, ModuleStartPacket packet) { 
  MugsModule cm = new MugsModule(packet);
  ChannelCommandStatus.getAllOn("MUG_BOT").then((List<String> channels) {
    if (channels != null) {
      cm.channels = channels;
    }
  });
  int time = new DateTime.now().millisecondsSinceEpoch - 1800000;
  getDatabase().query("SELECT `hit_id`, `hit_name`, `vic_id`, `vic_name`, `key`, `time` FROM atts WHERE `time` >= $time")
               .then((Results res) {
                 res.stream.listen((data)  { 
                   new TornUser.get(data[1], data[0]).addAttack(data[4]);
                   new TornUser.get(data[3], data[2]).addHit(data[4]);                   
                 }, onDone: () { cm.init(); });
               });
}


class TornUser {
  static Map<int, TornUser> tornUser = new Map<int, TornUser>();
  int id;
  int timesHit = 0;
  int timesHitted = 0;
  Timer lastHit;
  int lastHitTime = 0;
  String name;
  int lastNotified = 0;
  List<String> ids = new List<String>();
  TornUser (this.name, this.id) {
    tornUser[this.id] = this; 
  }
  factory TornUser.get (String name, int id) {
    if (tornUser.containsKey(id)) {
      return tornUser[id];
    }
    else return new TornUser(name, id);
  }
  void addHit(String check) {
    if (!ids.contains(check)) { 
      print("Added hit to ${name} ${timesHit} ${check}");
      if (lastHit != null) lastHit.cancel();
      lastHitTime = new DateTime.now().millisecondsSinceEpoch;
      lastHit = new Timer(new Duration(minutes: 30), () { this.timesHit = 0; });
      this.timesHit++;
      ids.add(check);
    }
  }
  void addAttack (String check) {
    if (!ids.contains(check)) { 
      this.timesHitted++;
      ids.add(check);
    }
    else print("$check parsed already");
  }
  String toString () {
    return "$name (${k}04$timesHit${k}03:${k}07$timesHitted${k}03)";
  }
}
class MugsModule extends Module {
  static  List<String> idCommands = new List<String>();
  bool isActive = false;
  List<String> channels = new List<String>();
  HttpClient client = new HttpClient();
  Query preparedInsert;
  bool synced = false;
  int attackLogId = 0;
  int attackerID = 0;
  int defenderID = 0;
  String resyncName = "";
  ChannelName resyncChannel;
  
  MugsModule (ModuleStartPacket packet):super(packet) {
    client.userAgent = "Plornt Global Events Parser [1445055] If this is causing issues please contact me in game.";
    getDatabase().prepare("INSERT INTO atts (`hit_id`, `hit_name`, `vic_id`, `vic_name`, `key`, `time`) VALUES (?, ?, ?, ?, ?, ?)").then((query) { 
      print("------> QUERY PREPARED");
      this.preparedInsert = query;
    }).catchError((e)  {
      print("COULDNT PREPARE QUERY :( $e");
      throw "NOT DOING SHIT";
    });
  }

  void init () {
    new Timer.periodic(new Duration(seconds: 5), checkMugs);
  }
  void messageHits (TornUser user, int attackLog) {
    if (user.timesHit > 1) {
     String color = "";
     if (user.timesHit < 5) color = "${k}03";
     else if (user.timesHit > 5 && user.timesHit < 11) color = "${k}07";
     else color = "${k}04";
     if (synced) {
      sendToRequired("${k}$color${b}${user.name}${b} has been chain mugged ${b}${user.timesHit}${b} times - http://www.torn.com/profiles.php?XID=${user.id} - Assumed Log: ${attackLog}");
     }
     else {
       sendToRequired("${k}$color${b}${user.name}${b} has been chain mugged ${b}${user.timesHit}${b} times - http://www.torn.com/profiles.php?XID=${user.id} - Attack log not synced");
     }
    }
  }
  void sendToRequired (String message) {
    print("Attempting message $message");
    channels.forEach((String chan) { 
      this.SendMessage(new ChannelName(chan), message);
    });
  }
  
  void checkMugs(Timer t) {
    client.getUrl(Uri.parse(r"http://www.torn.com/torncity/global-events?boxes={%22global%22:{%22type%22:%22events%22}}"))
          .then((HttpClientRequest req) {
            return req.close();
          })
          .then((HttpClientResponse body) {
            StringBuffer respText = new StringBuffer();
            body.transform(new Utf8Decoder()).listen((String data) { respText.write(data); }, onDone: () {
              try {
                dynamic obj = new JsonDecoder(null).convert(respText.toString());
                if (obj != null) {
                  if (obj["global"] != null) {
                    List<Map<String, dynamic>> events = obj["global"];
                    for (var x = 0; x < events.length; x++) {
                      if (events[x] != null) {
                        Map<String, dynamic> event = events[x];
                        if (event["text"] is String) {
                          if (event["text"].contains(" mugged ") || event["text"].contains(" hospitalized ") || event["text"].contains(" left ")) {
                            var doc = parse(event["text"]);
                            attackLogId++;
                            List<Element> e = doc.queryAll("a");                         
                            if (event["text"].contains(" mugged ")) {
                              Element elemHitted = e[(e.length == 2 ? 1 : 0)];
                              int IDVictim = int.parse(elemHitted.attributes["href"].replaceAll("\/profiles\.php\?XID=", ""));
                              
                              TornUser victim = new TornUser.get(elemHitted.innerHtml,IDVictim);
                              if (preparedInsert != null && !victim.ids.contains(event["id"])) {
                                victim.addHit(event["id"]);
                                this.messageHits(victim, attackLogId);
                                if (e.length == 1) {
                                  preparedInsert.execute([0, "Someone", IDVictim, elemHitted.innerHtml, event["id"], new DateTime.now().millisecondsSinceEpoch])
                                                .then((res) { 
                                                  print("Inserted ${res.affectedRows} rows to change status");
                                                })
                                                .catchError((error) { 
                                                  print(new DateTime.now().millisecondsSinceEpoch);
                                                  print("ERROR ${error.toString()}");
                                                });       
                                }
                                else {
                                  Element element = e[0];
                                  int ID = int.parse(element.attributes["href"].replaceAll("\/profiles\.php\?XID=", ""));
                                  TornUser hitter = new TornUser.get(element.innerHtml,ID);
                                  hitter.addAttack(event["id"]);
                                  
                                                                    
                                  preparedInsert.execute([ID, element.innerHtml, IDVictim, elemHitted.innerHtml, event["id"], new DateTime.now().millisecondsSinceEpoch])
                                                .then((res) { 
                                                print("Inserted ${res.affectedRows} rows to change status");
                                                })
                                                .catchError((error) { 
                                                  print(new DateTime.now().millisecondsSinceEpoch);
                                                  print("ERROR ${error.toString()}");
                                                });                              
                                }
                              }
                              
                              
                            }
                            if (attackerID != 0 && defenderID != 0 && e.length == 2) {
                              Element elemHitted = e[1];
                              int IDVictim = int.parse(elemHitted.attributes["href"].replaceAll("\/profiles\.php\?XID=", ""));
                              Element element = e[0];
                              int ID = int.parse(element.attributes["href"].replaceAll("\/profiles\.php\?XID=", ""));
                              if (attackerID == ID && IDVictim == defenderID) { 
                                this.SendMessage(resyncChannel, "${k}03Okay${b} $resyncName${b}, I have found the attack. Please use: ${b}!resyncMugs complete ${u}LogID${u}${b}");
                                this.attackLogId = 0;
                                this.attackerID = 0;
                                this.defenderID = 0;
                              }
                            }
                        }
                        }
                      }
                    }
                  }
                }
              }
              catch (e) {
                print("Error parsing global events: ${e.toString()}  ");
              }
            });
          });
  }
  
  bool onChannelMessage (Nickname user, PrivMsgCommand command) {
      if (command.get(0) == "!mugsOn") {
        channels.add(command.target.toString());
        ChannelCommandStatus.turnOn(command.target, "MUG_BOT");
        this.SendMessage(command.target, "${k}03Mug messages are now on in ${b}${command.target}${b}.");
      }
      else if (command.get(0) == "!mugsOff") {
        if (channels.contains(command.target.toString())) {
          channels.remove(command.target.toString());
          ChannelCommandStatus.turnOff(command.target, "MUG_BOT");
          this.SendMessage(command.target, "${k}03Mug messages are now off in ${b}${command.target}${b}.");
        }
      }
      else if (command.get(0) == "!top10Mugs") {
        List<TornUser> tempL = TornUser.tornUser.values.toList();
        tempL.sort((TornUser a, TornUser b) { return b.timesHit.compareTo(a.timesHit); });
        if (tempL.length > 10) tempL = tempL.getRange(0,10).toList();
        this.SendMessage(command.target, "${k}03Most mugged in the last ${b}30${b} minutes: ${b}${tempL.join(", ")}${b}");
      }
      else if (command.get(0) == "!top10Hitters") {
        List<TornUser> tempL = TornUser.tornUser.values.toList();
        tempL.sort((TornUser a, TornUser b) { return b.timesHitted.compareTo(a.timesHitted); });
        if (tempL.length > 10) tempL = tempL.getRange(0,10).toList();
        this.SendMessage(command.target, "${k}03Highest mugging hitters in the last ${b}30${b} minutes: ${b}${tempL.join(", ")}${b}");
      }
      else if (command.get(0) == "!resyncMugs") {
        if (command.get(1) != "complete") { 
          bool err = false;
          int attID = int.parse(command.get(1), onError: (e) {err = true;});
          int defID = int.parse(command.get(2), onError: (e) {err = true;});
          if (!err) {
            this.SendMessage(command.target, "${k}03I am now going to look for an attack between ${b}$attID${b} and ${b}$defID${b}, after the attack wait for me to tell you its okay use the command: ${b}!resyncMugs complete ${u}LogID${u}${b}.");
            this.resyncName = user.toString();
            this.attackerID = attID;
            this.defenderID = defID;
            this.resyncChannel = command.target;
          }
          else {
            this.SendMessage(command.target, "${k}03You did not supply valid IDs for the bot to sync to. Command: ${b}!resyncMugs ${u}AttackerID${u} ${u}DefenderID${u}");
          }       
        }   
        else {
          if (resyncName == user.toString()) {
            int logID = int.parse(command.get(2));
            attackLogId += logID;
            this.synced = true;
            this.resyncName = "";
            this.SendMessage(command.target, "${k}03I have resynced the attack logs. Thank you.");
          }
          else this.SendMessage(command.target, "${k}03You are not the user who initiated the resync.");
        }
     }
  }
  bool onChannelJoin (Target user, JoinCommand command) {
    
  }
  bool onConnect () {
    
  }
}



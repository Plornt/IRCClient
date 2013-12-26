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
  int lastHitTime = 0;
  String name;
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
      int curTime = new DateTime.now().millisecondsSinceEpoch;
      if ((curTime - lastHitTime) > 1800000) this.timesHit = 0;
      lastHitTime = curTime;
      this.timesHit++;
      ids.add(check);
    }
  }
  void addAttack (String check) {
    if (!ids.contains(check)) { 
      this.timesHitted++;
      ids.add(check);
    }
  }
  String toString () {   return "$name (${k}04$timesHit${k}03:${k}07$timesHitted${k}03)";  }
}
class MugsModule extends Module {
  static  List<String> idCommands = new List<String>();
  bool isActive = false;
  List<String> channels = new List<String>();
  HttpClient client = new HttpClient();
  Query preparedInsert;
  Timer pereodic;
  
  List<String> checked = new List<String>();
  MugsModule (ModuleStartPacket packet):super(packet) {
    client.userAgent = "Plornt Global Events Parser [1445055] If this is causing issues please contact me in game.";
    getDatabase().prepare("INSERT INTO atts (`hit_id`, `hit_name`, `vic_id`, `vic_name`, `key`, `time`) VALUES (?, ?, ?, ?, ?, ?)").then((query) { 
      this.preparedInsert = query;
    });
  }

  void init () {
    pereodic = new Timer.periodic(new Duration(seconds: 5), checkMugs);
  }
  void messageHits (TornUser user) {
    if (user.timesHit > 1) {
     String color = "";
     if (user.timesHit < 5) color = "${k}10";
     else if (user.timesHit >= 5 && user.timesHit < 11) color = "${k}07";
     else color = "${k}03";
     sendToRequired("${k}$color${b}${user.name}${b} has been chain mugged ${b}${user.timesHit}${b} times - http://www.torn.com/profiles.php?XID=${user.id}");
    }
  }
  void sendToRequired (String message) {
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
                            List<Element> e = doc.queryAll("a");                         
                            if (event["text"].contains(" mugged ")) {
                              Element elemHitted = e[(e.length == 2 ? 1 : 0)];
                              int IDVictim = int.parse(elemHitted.attributes["href"].replaceAll("\/profiles\.php\?XID=", ""));
                              
                              TornUser victim = new TornUser.get(elemHitted.innerHtml,IDVictim);
                              if (preparedInsert != null && !victim.ids.contains(event["id"])) {
                                victim.addHit(event["id"]);
                                this.messageHits(victim);
                                if (e.length == 1) {
                                  preparedInsert.execute([0, "Someone", IDVictim, elemHitted.innerHtml, event["id"], new DateTime.now().millisecondsSinceEpoch]);  
                                }
                                else {
                                  Element element = e[0];
                                  int ID = int.parse(element.attributes["href"].replaceAll("\/profiles\.php\?XID=", ""));
                                  TornUser hitter = new TornUser.get(element.innerHtml,ID);
                                  hitter.addAttack(event["id"]);
                                  preparedInsert.execute([ID, element.innerHtml, IDVictim, elemHitted.innerHtml, event["id"], new DateTime.now().millisecondsSinceEpoch]);
                                }
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
      if (command.get(0) == "!toggleMugs") {
        if (!channels.contains(command.target.toString())) {
          channels.add(command.target.toString());
          ChannelCommandStatus.turnOn(command.target, "MUG_BOT");
          this.SendMessage(command.target, "${k}03Mug messages are now ${b}on${b} in ${b}${command.target}${b}.");
        }
        else {
          channels.remove(command.target.toString());
          ChannelCommandStatus.turnOff(command.target, "MUG_BOT");
          this.SendMessage(command.target, "${k}03Mug messages are now ${b}off${b} in ${b}${command.target}${b}.");
        }
      }
      else if (command.get(0) == "!top10Mugs") {
        List<TornUser> tempL = TornUser.tornUser.values.toList();
        tempL.sort((TornUser a, TornUser b) {
          int curTime = new DateTime.now().millisecondsSinceEpoch;
          if ((curTime - a.lastHitTime) > 1800000) a.timesHit = 0;
          if ((curTime - b.lastHitTime) > 1800000) b.timesHit = 0;
          return b.timesHit.compareTo(a.timesHit); 
        });
        if (tempL.length > 10) tempL = tempL.getRange(0,10).toList();
        this.SendMessage(command.target, "${k}03Most mugged in the last ${b}30${b} minutes: ${b}${tempL.join(", ")}${b}");
      }
      else if (command.get(0) == "!top10Hitters") {
        List<TornUser> tempL = TornUser.tornUser.values.toList();
        tempL.sort((TornUser a, TornUser b) { return b.timesHitted.compareTo(a.timesHitted); });
        if (tempL.length > 10) tempL = tempL.getRange(0,10).toList();
        this.SendMessage(command.target, "${k}03Highest mugging hitters in the last ${b}30${b} minutes: ${b}${tempL.join(", ")}${b}");
      }
      
  }
  bool onModuleDeactivate() {
    pereodic.cancel();
  }
  bool onChannelJoin (Target user, JoinCommand command) {
    
  }
  bool onConnect () {
    
  }
}



import 'package:unittest/unittest.dart';
import '../../src/module/main.dart';

void main() {
   test("ISupportParser", () { 
//     {
//       ISupportParser parser = new ISupportParser.parse("PREFIX=(ov)@+");
//       expect({ 'PREFIX':[["o", "@"], ["v", "+"]] },parser.parameters);
//     }
//     
//     {
//       ISupportParser parser = new ISupportParser.parse("PREFIX=(ovh)@+%");
//       expect({ 'PREFIX':[["o", "@"], ["v", "+"], ["h", "%"]] },parser.parameters);
//     }
//     
//     {
//       ISupportParser parser = new ISupportParser.parse("CHANTYPES=#&");
//       expect({'CHANTYPES': ['#', '&']}, parser.parameters);
//     }
//     {
//       ISupportParser parser = new ISupportParser.parse("CHANMODES=b,k,l,imnpstr");
//       expect({'CHANMODES': ['b', 'k', 'l', 'imnpstr']}, parser.parameters);
//     }
     {
       ISupportParser parser = new ISupportParser.parse("MAXTARGETS=20 CHANTYPES=#&");
       expect({'MAXTARGETS': 20}, parser.parameters);
     }
     
     
     
   });
}

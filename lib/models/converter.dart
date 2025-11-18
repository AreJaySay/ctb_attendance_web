import 'dart:convert';

class ConverterModels{
  String hexToString(String hexString) {
    List<int> bytes = [];
    for (int i = 0; i < hexString.length; i += 2) {
      String hexPair = hexString.substring(i, i + 2);
      bytes.add(int.parse(hexPair, radix: 16));
    }
    return utf8.decode(bytes);
  }
}
final ConverterModels converterModels = new ConverterModels();
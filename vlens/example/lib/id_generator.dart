import 'dart:math';

String generateUUID() {
  const uuidTemplate = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
  final random = Random();

  return uuidTemplate.replaceAllMapped(RegExp(r'[xy]'), (match) {
    final c = match.group(0);
    final r = (random.nextDouble() * 16).floor();
    final v = (c == 'x') ? r : (r & 0x3) | 0x8;
    return v.toRadixString(16);
  });
}
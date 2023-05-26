
//// TOKEN ENCRYPTION
///  -- uses XOR Operation Encryption
///  -- uses [firstTimeLogin] as key

/// encryptToken
///
String encryptToken(String message, String key) {
  String encryptedMessage = '';
  String secretKey = key.split('').reversed.join();
  for (int i = 0; i < message.length; i++) {
    int charCode = message.codeUnitAt(i);
    int keyCharCode = secretKey.codeUnitAt(i % secretKey.length);
    int encryptedCharCode = charCode ^ keyCharCode; // XOR operation
    encryptedMessage += String.fromCharCode(encryptedCharCode);
  }
  return encryptedMessage;
}

/// decryptToken
///
String decryptToken(String encryptedMessage, String key) {
  String decryptedMessage = '';
  String secretKey = key.split('').reversed.join();
  for (int i = 0; i < encryptedMessage.length; i++) {
    int encryptedCharCode = encryptedMessage.codeUnitAt(i);
    int keyCharCode = secretKey.codeUnitAt(i % secretKey.length);
    int decryptedCharCode = encryptedCharCode ^ keyCharCode; // XOR operation
    decryptedMessage += String.fromCharCode(decryptedCharCode);
  }
  return decryptedMessage;
}

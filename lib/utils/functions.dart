import 'dart:convert';

String toBase64(String password) {
  final bytes = utf8.encode(password); // Convert string to bytes
  return base64.encode(bytes);        // Encode bytes to Base64
}
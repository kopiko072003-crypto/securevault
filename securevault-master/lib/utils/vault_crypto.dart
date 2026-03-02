import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// Vault encryption: key derived with SHA-256, passwords encrypted with AES-256.
/// Same fixed IV is used for encrypt and decrypt so decryption works.
class VaultCrypto {
  static const String _keySeed = 'SecureVaultDemoKey2024';

  static Key _getKey() {
    final bytes = utf8.encode(_keySeed);
    final digest = sha256.convert(bytes);
    return Key(Uint8List.fromList(digest.bytes));
  }

  /// Fixed IV (first 16 bytes of SHA-256 of seed+"iv") so encrypt/decrypt match.
  static IV get _iv {
    final bytes = utf8.encode('$_keySeed iv');
    final digest = sha256.convert(bytes);
    return IV(Uint8List.fromList(digest.bytes.take(16).toList()));
  }

  /// Encrypt plain password for storage. Key from SHA-256, cipher AES-256.
  static String encrypt(String plain) {
    final key = _getKey();
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plain, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt stored password for display/copy.
  static String decrypt(String encryptedBase64) {
    final key = _getKey();
    final encrypter = Encrypter(AES(key));
    final encrypted = Encrypted.fromBase64(encryptedBase64);
    return encrypter.decrypt(encrypted, iv: _iv);
  }
}

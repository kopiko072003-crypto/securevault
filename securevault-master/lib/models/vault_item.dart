/// A saved account entry for the vault (service name, username, encrypted password).
class VaultItem {
  final String id;
  final String serviceName;
  final String username;
  /// Stored encrypted (AES-256, key derived with SHA-256). Decrypt only when user reveals/copies.
  final String encryptedPassword;

  const VaultItem({
    required this.id,
    required this.serviceName,
    required this.username,
    required this.encryptedPassword,
  });
}

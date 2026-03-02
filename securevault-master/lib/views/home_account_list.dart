import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_icons/simple_icons.dart';
import '../models/vault_item.dart';
import '../utils/constants.dart';
import '../utils/vault_crypto.dart';

/// Demo saved accounts for Jhonn Lee Maning (show only). Passwords stored encrypted (SHA-256 key + AES-256).
List<VaultItem> getDemoVaultItems() {
  const email = 'jhonnleemaning07@gmail.com';
  final items = [
    ('Facebook', 'Fb2024!secure'),
    ('Google', 'G00gle#Pass'),
    ('Canvas LMS', 'CanvasLMS@123'),
    ('Instagram', r'Insta$gram1'),
    ('Netflix', 'Netfl1x!Watch'),
    ('Twitter / X', 'X_Tw1tter!'),
    ('LinkedIn', 'Link3dIn!Pro'),
  ];
  return [
    for (var i = 0; i < items.length; i++)
      VaultItem(
        id: 'vault_$i',
        serviceName: items[i].$1,
        username: email,
        encryptedPassword: VaultCrypto.encrypt(items[i].$2),
      ),
  ];
}

/// Home screen: list of saved accounts. Password masked; tap 👁 to reveal, 📋 to copy (clears in 30s).
class HomeAccountList extends StatefulWidget {
  const HomeAccountList({super.key});

  @override
  State<HomeAccountList> createState() => _HomeAccountListState();
}

class _HomeAccountListState extends State<HomeAccountList> {
  late final List<VaultItem> _items = getDemoVaultItems();
  final Set<String> _revealedIds = <String>{};

  void _copyPassword(String encrypted) {
    try {
      final plain = VaultCrypto.decrypt(encrypted);
      Clipboard.setData(ClipboardData(text: plain));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copy failed: $e')),
        );
      }
    }
  }

  void _togglePasswordVisible(String id) {
    setState(() {
      if (_revealedIds.contains(id)) {
        _revealedIds.remove(id);
      } else {
        _revealedIds.add(id);
      }
    });
  }

  Widget _buildServiceIcon(String service) {
    final (icon, color) = _iconAndColorFor(service);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  /// Brand icon and color per service (simple_icons). Fallback for unknown services.
  (IconData icon, Color color) _iconAndColorFor(String service) {
    switch (service) {
      case 'Facebook':
        return (SimpleIcons.facebook, SimpleIconColors.facebook);
      case 'Google':
        return (SimpleIcons.google, SimpleIconColors.google);
      case 'Instagram':
        return (SimpleIcons.instagram, SimpleIconColors.instagram);
      case 'Netflix':
        return (SimpleIcons.netflix, SimpleIconColors.netflix);
      case 'LinkedIn':
        return (Icons.business_center_rounded, const Color(0xFF0A66C2));
      case 'Twitter / X':
        return (SimpleIcons.x, SimpleIconColors.x);
      case 'Canvas LMS':
        return (Icons.school_rounded, AppConstants.primaryColor);
      default:
        return (Icons.lock_rounded, AppConstants.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('My Accounts'),
        elevation: 0,
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildServiceIcon(item.serviceName),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.serviceName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.username,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Password: ', style: TextStyle(fontSize: 13, color: AppConstants.textSecondary)),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final isRevealed = _revealedIds.contains(item.id);
                            String displayText;
                            if (isRevealed) {
                              try {
                                displayText = VaultCrypto.decrypt(item.encryptedPassword);
                              } catch (_) {
                                displayText = 'Error decrypting password';
                              }
                            } else {
                              displayText = item.encryptedPassword;
                            }
                            return Text(
                              displayText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: AppConstants.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _revealedIds.contains(item.id)
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        tooltip: 'Show / hide password',
                        onPressed: () => _togglePasswordVisible(item.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy password',
                        onPressed: () => _copyPassword(item.encryptedPassword),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

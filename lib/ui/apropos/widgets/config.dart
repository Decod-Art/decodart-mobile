import 'package:decodart/data/api/offline/offline.dart' show OfflineManager;
import 'package:decodart/util/online.dart' show hostName, cdn, cdnImages;
import 'package:decodart/ui/core/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    OfflineManager offline = OfflineManager();
    return DecodPageScaffold(
      title: 'Configuration',
      smallTitle: true,
      showTrailing: false,
      withScrolling: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildRow('API', hostName),
              _buildRow('Images', cdnImages),
              _buildRow('Fichiers', cdn),
              _buildRow('Hors ligne', "${offline.isAvailable}"),
              _buildRow('Version de l\'application', _appVersion),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
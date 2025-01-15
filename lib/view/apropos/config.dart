import 'package:decodart/api/offline/offline.dart';
import 'package:decodart/util/online.dart';
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

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
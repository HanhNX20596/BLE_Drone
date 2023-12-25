import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth/utils/byte_extension.dart';

import "../utils/snackbar.dart";

class DescriptorTile extends StatefulWidget {
  final BluetoothDescriptor descriptor;

  const DescriptorTile({Key? key, required this.descriptor}) : super(key: key);

  @override
  State<DescriptorTile> createState() => _DescriptorTileState();
}

class _DescriptorTileState extends State<DescriptorTile> {
  String _value = '';

  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();

    _lastValueSubscription = widget.descriptor.lastValueStream.listen((value) {
      if (mounted) setState(() => _value = value.decode());
    });

    onReadPressed();
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothDescriptor get d => widget.descriptor;

  Future onReadPressed() async {
    try {
      await d.read();
      Snackbar.show(ABC.c, "Descriptor Read : Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Descriptor Read Error:", e),
          success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.descriptor.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton() {
    return TextButton(
      onPressed: onReadPressed,
      child: const Text("Read"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          buildUuid(context),
          buildValue(context),
        ],
      ),
      subtitle: buildReadButton(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/components/outlineTextField.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/server.dart';

class ServerForm extends StatefulWidget {
  ServerForm({this.onPressed});

  final VoidCallback onPressed;
  @override
  State<StatefulWidget> createState() {
    return _ServerFormState();
  }
}

class _ServerFormState extends State<ServerForm> {
  final TextEditingController _serverNameFilter = new TextEditingController();
  final TextEditingController _urlFilter = new TextEditingController();
  final FocusNode urlFocusNode = new FocusNode();
  String _serverName = "";
  String _url = "";

  _ServerState() {
    _serverNameFilter.addListener(_serverNameListen);
    _urlFilter.addListener(_urlListen);
  }

  void _serverNameListen() {
    if (_serverNameFilter.text.isEmpty) {
      _serverName = "";
    } else {
      _serverName = _serverNameFilter.text;
    }
  }

  void _urlListen() {
    if (_urlFilter.text.isEmpty) {
      _url = "";
    } else {
      _url = _urlFilter.text;
    }
  }

  void addServer() {
    Server s = new Server();
    s.name = _serverNameFilter.text;
    s.url = _urlFilter.text;

    server = s;
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          "Server configuration",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.height * 0.01),
        OutlineTextField(
          'server name',
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => FocusScope.of(context).requestFocus(urlFocusNode),
          controller: _serverNameFilter,
        ),
        OutlineTextField(
          "url",
          controller: _urlFilter,
          textInputAction: TextInputAction.done,
          focusNode: urlFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).unfocus();
            addServer();
          },
          prefixIcon: Icon(Icons.http),
        ),
        SizedBox(height: size.height * 0.03),
        GradienButton('Add server', addServer)
      ],
    );
  }
}

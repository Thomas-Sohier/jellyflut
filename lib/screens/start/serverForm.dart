import 'package:flutter/material.dart';
import 'package:jellyflut/components/gradientButton.dart';
import 'package:jellyflut/components/outlineTextField.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';

class ServerForm extends StatefulWidget {
  ServerForm({this.onPressed});

  final VoidCallback onPressed;
  @override
  State<StatefulWidget> createState() {
    return _ServerFormState();
  }
}

class _ServerFormState extends State<ServerForm> {
  final TextEditingController _serverNameFilter = TextEditingController();
  final TextEditingController _urlFilter = TextEditingController();
  final FocusNode urlFocusNode = FocusNode();

  void addServer() {
    server =
        Server(name: _serverNameFilter.text, url: _urlFilter.text, id: null);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Server configuration',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.height * 0.01),
        OutlineTextField(
          'server name',
          textInputAction: TextInputAction.next,
          autofocus: true,
          colorFocus: Theme.of(context).accentColor,
          colorUnfocus: Colors.grey[200],
          onSubmitted: (_) => FocusScope.of(context).requestFocus(urlFocusNode),
          controller: _serverNameFilter,
        ),
        OutlineTextField(
          'url',
          controller: _urlFilter,
          autofocus: false,
          textInputAction: TextInputAction.done,
          focusNode: urlFocusNode,
          colorFocus: Theme.of(context).accentColor,
          colorUnfocus: Colors.grey[200],
          onSubmitted: (_) {
            FocusScope.of(context).nextFocus();
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

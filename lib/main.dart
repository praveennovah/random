import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _webViewController;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    
    String initialHtml = '''
      <!DOCTYPE html>
      <html>
        <head>
          <title>Registration Form</title>
        </head>
        <body>
          <h1>Registration</h1>
          <form>
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required><br><br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required><br><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required><br><br>

            <button type="button" onclick="showMessageInFlutter()">Register</button>
          </form>

          <script>
            function showMessageInFlutter() {
              alert('Registered Successfully');
              FlutterChannel.postMessage('Registered Successfully');
            }
          </script>
        </body>
      </html>
    ''';

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('WebView Flutter'),
        ),
        body: WebView(
          initialUrl: Uri.dataFromString(initialHtml,
                  mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
              .toString(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
          },
          javascriptChannels: <JavascriptChannel>{
            _createJavascriptChannel(),
          },
        ),
        
      ),
    );
  }

  JavascriptChannel _createJavascriptChannel() {
    return JavascriptChannel(
      name: 'FlutterChannel', 
      onMessageReceived: (JavascriptMessage message) {
       
        if (message.message == 'Registered Successfully') {
          
          _showSnackBar();
        }
      },
    );
  }

  void _showSnackBar() {
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text('Registered Successfully'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}

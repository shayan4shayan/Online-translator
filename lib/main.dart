import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api.dart';
import 'models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Translator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Online Translator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String translatedText = "";

  String text;

  List<RandomWord> words;

  void onTextChanged(String text) {
    this.text = text;
  }

  void translate() {
    translateWord(text).then((translate) => {
          setState(() => {this.translatedText = translate})
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadWords();
  }

  void _loadWords() {
    print("loading random words");
    loadRandomWords().then((words) => {
          setState(() => {this.words = words})
        });
  }

  Future<bool> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(

              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter a word to translate"),
                              onChanged: onTextChanged,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: FloatingActionButton(
                            onPressed: translate,
                            child: Icon(
                              Icons.g_translate,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("$translatedText"),
                    )
                  ],
                ),
              ),
            ),
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text("Powered by", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 24),),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                    child: Text("Yandex.com", style: TextStyle(color: Colors.redAccent),),
                    onTap: () {_launchURL("https://yandex.com");},
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Random words",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: _getRandomWordsContent(),
              ),
            ),
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text("Powered by", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 24),),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                  child: Text("random-word-api.herokuapp.com", style: TextStyle(color: Colors.indigo),),
                    onTap: () {_launchURL("https://random-word-api.herokuapp.com");},
                )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _getRandomWordsContent() {
    if (words == null) {
      return CircularProgressIndicator();
    } else {
      return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: List.generate(
              words.length,
              (index) {
                return ListTile(
                  title: Text(words[index].word),
                  subtitle: Text(words[index].translation),
                );
              },
            ),
          ));
    }
  }
}

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'models.dart';

Future<String> translateWord(String word) async {
  print(word);
  String url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20180315T180433Z.ace9368cd05ee426.a844889d9519ce7c18952bbb36162cd3d1060360&text=$word&lang=fa";
  var response = await get(url);
  var content = response.body;
  print(content);
  Map<String,dynamic> json = jsonDecode(content);
  if(json['code'] == 200){
    return json['text'][0];
  }
  return null;
}

Future<List<RandomWord>> loadRandomWords() async {
  String url = "https://random-word-api.herokuapp.com/word?number=20";
  var response = await get(url);
  var content = response.body;
  List<dynamic> words = jsonDecode(content);
  print(words);
  List<RandomWord> randomWords = new List();
  for (var word in words){
    RandomWord randomWord = new RandomWord();
    randomWord.word = word;
    randomWord.translation = await translateWord(word);
    randomWords.add(randomWord);
  }

  return randomWords;
}
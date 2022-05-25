import 'package:flutter/material.dart';
import 'package:quiz_app/options.dart';
import 'package:quiz_app/question.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const questions = [
    {
      "question": "What\'s your favourite hero?",
      "options": [
        {"optionTitle": "Batman", "score": 5},
        {"optionTitle": "Iron Man", "score": 4},
        {"optionTitle": "Captian America", "score": 3},
        {"optionTitle": "Wonder man", "score": 2}
      ]
    },
    {
      "question": "What\'s your favourite movie ?",
      "options": [
        {"optionTitle": "Batman", "score": 5},
        {"optionTitle": "Iron Man", "score": 4},
        {"optionTitle": "Captian America", "score": 3},
        {"optionTitle": "Wonder man", "score": 2}
      ]
    },
    {
      "question": "What programming Langugae you like?",
      "options": [
        {"optionTitle": "javascript", "score": 5},
        {"optionTitle": "Java", "score": 4},
        {"optionTitle": "Dart", "score": 3},
        {"optionTitle": "others", "score": 2}
      ]
    }
  ];
  var questionNumber = 0;
  var mostLikableOptionsScore = 0;

  void _optionClicked(int score) {
    setState(() {
      questionNumber += 1;
      mostLikableOptionsScore += score;
    });
  }

  void _resetQuiz() {
    setState(() {
      questionNumber = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: questionNumber < questions.length
            ? Column(
                children: <Widget>[
                  Question(
                    questionTitle:
                        questions[questionNumber]["question"] as String,
                  ),
                  ...(questions[questionNumber]["options"]
                          as List<Map<String, Object>>)
                      .map((option) {
                    return Options(
                        optionsTitle: option["optionTitle"] as String,
                        optionsPressed: () =>
                            _optionClicked(option["score"] as int));
                  }).toList()
                ],
              )
            : Column(children: [
                Question(
                    questionTitle:
                        "Your most likable options is $mostLikableOptionsScore"),
                TextButton(
                    onPressed: _resetQuiz,
                    child: const Text("Click to reset the Quiz puzzle"))
              ]));
  }
}

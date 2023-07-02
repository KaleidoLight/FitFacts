
import 'package:flutter/material.dart';
import 'package:fitfacts/quizview/QuizBuilder.dart';
import 'package:fitfacts/quizview/QuizDatabase.dart';
import 'package:url_launcher/url_launcher.dart';


class QuizView extends StatefulWidget {

  QuizTopic topic;

  QuizView({Key? key, required this.topic}) : super(key: key);

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  QuizQuestion? selectedQuestion;
  late QuizActivity quiz;
  bool areButtonsEnabled = true;

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    quiz = quizDatabase.getQuiz(widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
        end: 20,
        bottom: 40,
        top: 20,
      ),
      child: Wrap(
        children: [
          Column(
            children: [
              Text(
                quiz.title,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: null,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(height: 20,),
          Column(
            children: quiz.questions.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              // Generate the widgets using the index and item
              return QuestionButton(
                  questionData: item.body,
                  isSelected: item == selectedQuestion,
                  onPressed: areButtonsEnabled
                      ? () => handleButtonPressed(index)
                      : null,
                  isCorrect: item.isCorrect);
            }).toList(),
          ),
          Container(height: 20,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (areButtonsEnabled)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Choose one option',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      maxLines: null,
                      textAlign: TextAlign.center,),
                  ],
                ),
              if (!areButtonsEnabled)
                QuizOutcome(quizActivityData: quiz,),
            ],
          )

        ],
      ),
    );
  }

  void handleButtonPressed(int index) {
    setState(() {
      selectedQuestion = quiz.questions[index];
      areButtonsEnabled = false;
    });
  }

}

class QuestionButton extends StatelessWidget {
  final String questionData;
  final bool isCorrect;
  final bool isSelected;
  final VoidCallback? onPressed;

  const QuestionButton({
    Key? key,
    required this.questionData,
    required this.isSelected,
    required this.onPressed,
    required this.isCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? (isCorrect ? Colors.green : Colors.deepOrange)
        : Colors.grey[300];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            color: color,
            height: 60,
            child: Center(
              child: Text(questionData, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
            ),
          ),
        ),
      ),
    );
  }
}

class QuizOutcome extends StatefulWidget {
  QuizActivity quizActivityData;

  QuizOutcome({Key? key, required this.quizActivityData}) : super(key: key);

  @override
  State<QuizOutcome> createState() => _QuizOutcomeState();
}

class _QuizOutcomeState extends State<QuizOutcome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.quizActivityData.answer,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  maxLines: null,
                  textAlign: TextAlign.center,
                ),
                Container(height: 10,),
                Text(
                  (10000 > widget.quizActivityData.reference)
                      ? 'Wonderful! This week you did better than average'
                      : 'Don\'t give up! This week you did ...',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  maxLines: null,
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 30,
                ),
                QuizActions(quizActivityData: widget.quizActivityData,)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class QuizActions extends StatefulWidget {

  QuizActivity quizActivityData;
  QuizActions({Key? key, required this.quizActivityData}) : super(key: key);

  @override
  State<QuizActions> createState() => _QuizActionsState();
}

class _QuizActionsState extends State<QuizActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        QuizButton(title: 'Close', points:1, action: () {
          Navigator.pop(context);
        }),
        Container(width: 10,),
        QuizButton(title: 'Read More', points: 5,action: () async {
          final Uri url =
          Uri.parse(widget.quizActivityData.link);
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        })
      ],
    );
  }
}

class QuizButton extends StatelessWidget {

  void Function()? action;
  String title;
  int points;
  QuizButton({Key? key, required this.title, required this.points, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            height: 55,
            width: 180,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stars_rounded),
                  Container(width: 5,),
                  Text('$points', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Container(width: 10,),
                  Text(title, style: TextStyle(fontSize: 18),)
                ],
              ),],
            )
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fitfacts/quizview/QuizBuilder.dart';
import 'package:fitfacts/quizview/QuizDatabase.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/DatabaseRepo.dart';
import '../themes/theme.dart';

//ignore: must_be_immutable
class QuizView extends StatefulWidget {

  QuizTopic topic;

  QuizView({Key? key, required this.topic}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  QuizQuestion? selectedQuestion;
  late QuizActivity quiz;
  bool areButtonsEnabled = true;

  @override
  void initState() {
    super.initState();
    // Do not access the context here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the context-dependent data here
    final quizDatabase = createQuizDatabase(context);
    quiz = quizDatabase.getQuiz(widget.topic); // <-- selecting question from the quiz database
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
        end: 20,
        bottom: 40,
        top: 5,
      ),
      child: Wrap(
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                    child: Container(height: 5, width: 45, color: Theme.of(context).disabledColor,)),
                  Container(height: 35,)
              ],),
              Text(
                quiz.title,
                style: const TextStyle(
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
                  children: const [
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
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? greyColor = (themeMode == ThemeMode.light) ? Colors.grey[350] : Colors.grey[700];
    final color = isSelected
        ? (isCorrect ? Colors.green : Colors.deepOrange[400])
        : greyColor;

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
              child: Text(questionData, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
            ),
          ),
        ),
      ),
    );
  }
}

//ignore: must_be_immutable
class QuizOutcome extends StatefulWidget {
  QuizActivity quizActivityData;

  QuizOutcome({Key? key, required this.quizActivityData}) : super(key: key);

  @override
  State<QuizOutcome> createState() => _QuizOutcomeState();
}

class _QuizOutcomeState extends State<QuizOutcome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRepository>( // link the consumer of the provider
      builder: (context, dbr, child){
        return FutureBuilder( // Call Future builder
            future: Future.wait([widget.quizActivityData.personalRef!, widget.quizActivityData.reference]), /// <= GET THE DATA FROM THE DATABASE with the desired function
            builder: (context, snapshot){
          if (snapshot.hasData){
            final personalRef = snapshot.data![0];
            final reference = snapshot.data![1];
            final roundType = widget.quizActivityData.roundType;// CHANGE DataType to output type of Future
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
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                          maxLines: null,
                          textAlign: TextAlign.center,
                        ),
                        Container(height: 10,),
                        Text(
                          (personalRef >= reference)
                              ? '${widget.quizActivityData.positive} (${roundResult(personalRef, roundType)} > ${roundResult(reference, roundType)}) ${widget.quizActivityData.unit}'
                              : '${widget.quizActivityData.negative} (${roundResult(personalRef, roundType)} < ${roundResult(reference, roundType)}) ${widget.quizActivityData.unit}',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
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
          }else{
            return Container();
          }
        });
      },
    );
  }
}

//ignore: must_be_immutable
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
        QuizButton(title: 'Close', points:1, action: () async {
          await Provider.of<DatabaseRepository>(context, listen: false).updateUserInfo((info) { info.smartStars += 1;});
          Navigator.pop(context);
        }),
        Container(width: 10,),
        QuizButton(title: 'Read More', points: 5,
            action: () async {
              final Uri url = Uri.parse(widget.quizActivityData.link);
              await Provider.of<DatabaseRepository>(context, listen: false).updateUserInfo((info) { info.smartStars += 5;});
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
                print('Webpage dismissed!');
                Navigator.pop(context);
              } else {
                throw Exception('Could not launch $url');
              }
            }
        )
      ],
    );
  }
}

//ignore: must_be_immutable
class QuizButton extends StatelessWidget {

  void Function()? action;
  String title;
  int points;
  QuizButton({Key? key, required this.title, required this.points, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = context
        .watch<ThemeModel>()
        .mode;
    final Color? bkColor = (themeMode == ThemeMode.light) ? Colors.grey[300] : Colors.grey[800];
    return InkWell(
      onTap: action,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            height: 55,
            width: 180,
            color: bkColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars_rounded),
                  Container(width: 5,),
                  Text('$points', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Container(width: 10,),
                  Text(title, style: const TextStyle(fontSize: 18),)
                ],
              ),],
            )
        ),
      ),
    );
  }
}

// END OF CLASSES

void showModalQuiz(QuizTopic topic, BuildContext context){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
    ),
    builder: (context) {
      return QuizView(topic: topic,);
    },
  );
}

enum Roundings{
  integer,
  decimals
}

num roundResult(num value, Roundings rounding){
  if (rounding == Roundings.integer){
    return value.round();
  }else {
    return roundToTwoDecimals(value);
  }
}

double roundToTwoDecimals(num num) {
  return double.parse(num.toStringAsFixed(2));
}
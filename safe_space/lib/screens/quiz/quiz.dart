
import 'package:safe_space/models/question.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> selectedAnswers = {}; // questionIndex -> answerIndex
  
  // Mental health quiz questions
  final List<Question> questions = [
    Question(
      question: "How often do you feel overwhelmed by daily activities?",
      options: [
        "Never",
        "Rarely",
        "Sometimes", 
        "Often",
        "Always"
      ],
    ),
    Question(
      question: "How would you rate your current stress level?",
      options: [
        "Very low",
        "Low",
        "Moderate",
        "High",
        "Very high"
      ],
    ),
    Question(
      question: "How often do you engage in activities you enjoy?",
      options: [
        "Daily",
        "Weekly",
        "Monthly",
        "Rarely",
        "Never"
      ],
    ),
    Question(
      question: "How well do you sleep at night?",
      options: [
        "Very well",
        "Well",
        "Average",
        "Poorly",
        "Very poorly"
      ],
    ),
    Question(
      question: "How connected do you feel to your friends and family?",
      options: [
        "Very connected",
        "Somewhat connected",
        "Neutral",
        "Somewhat disconnected",
        "Very disconnected"
      ],
    ),
    Question(
      question: "How often do you practice self-care activities?",
      options: [
        "Daily",
        "Several times a week",
        "Weekly",
        "Rarely",
        "Never"
      ],
    ),
    Question(
      question: "How confident do you feel about handling life's challenges?",
      options: [
        "Very confident",
        "Confident",
        "Neutral",
        "Not very confident",
        "Not confident at all"
      ],
    ),
    Question(
      question: "How often do you feel anxious or worried?",
      options: [
        "Never",
        "Rarely",
        "Sometimes",
        "Often",
        "Always"
      ],
    ),
  ];

  void selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = answerIndex;
    });
    
    // Auto-advance to next question after selection
    Future.delayed(Duration(milliseconds: 300), () {
      if (currentQuestionIndex < questions.length - 1) {
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void finishQuiz() {
    // Handle quiz completion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Completed'),
          content: Text('Thank you for completing the mental health assessment. Your responses help us understand your current wellbeing.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to home
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;
    final selectedAnswer = selectedAnswers[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Quiz'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 20),
            
            // Question counter
            Text(
              'Question ${currentQuestionIndex + 1} of ${questions.length}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            
            // Question text
            Text(
              currentQuestion.question,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            
            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedAnswer == index;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Material(
                      elevation: isSelected ? 4 : 1,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => selectAnswer(index),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected ? Colors.blue[50] : Colors.white,
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  currentQuestion.options[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected ? Colors.blue[800] : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                currentQuestionIndex > 0
                    ? ElevatedButton.icon(
                        onPressed: previousQuestion,
                        icon: Icon(Icons.arrow_back),
                        label: Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      )
                    : SizedBox.shrink(),
                
                // Next/Finish button
                selectedAnswer != null
                    ? ElevatedButton.icon(
                        onPressed: isLastQuestion ? finishQuiz : nextQuestion,
                        icon: Icon(isLastQuestion ? Icons.check : Icons.arrow_forward),
                        label: Text(isLastQuestion ? 'Finish' : 'Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
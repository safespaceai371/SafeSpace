import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  
  // Variable to control chatbot responses
  final List<String> _botResponses = [
    "I understand how you're feeling. Can you tell me more about that?",
    "That sounds challenging. How are you coping with this situation?",
    "Thank you for sharing that with me. What would help you feel better right now?",
    "It's normal to feel this way sometimes. What usually makes you feel more positive?",
    "I'm here to listen. Would you like to talk about what's been on your mind?",
    "That's a valid concern. Have you tried any relaxation techniques?",
    "Your feelings are important. What kind of support do you find most helpful?",
    "I appreciate you opening up. What are some things that bring you joy?",
    "It's okay to have difficult days. What helps you get through tough times?",
    "Thank you for trusting me with your thoughts. How can I best support you today?",
  ];
  
  int _currentResponseIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Add initial bot message
    _addBotMessage("Hello! I'm here to listen and support you. How are you feeling today?");
  }

  void _sendMessage() {
    String userMessage = _messageController.text.trim();
    
    if (userMessage.isNotEmpty) {
      // Add user message
      setState(() {
        _messages.add(ChatMessage(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ));
      });
      
      // Clear input field
      _messageController.clear();
      
      // Scroll to bottom
      _scrollToBottom();
      
      // Generate bot response after a delay
      Future.delayed(Duration(milliseconds: 1000), () {
        _generateBotResponse(userMessage);
      });
    }
  }
  
  void _generateBotResponse(String userMessage) {
    // This is where you can control the bot response
    String botResponse = _getBotResponse(userMessage);
    
    _addBotMessage(botResponse);
  }
  
  String _getBotResponse(String userMessage) {
    // Convert user message to lowercase for better matching
    String message = userMessage.toLowerCase();
    
    // Simple keyword-based responses (you can modify this logic)
    if (message.contains('sad') || message.contains('depressed') || message.contains('down')) {
      return "I'm sorry you're feeling sad. It's okay to have these feelings. What usually helps you when you're feeling down?";
    } else if (message.contains('anxious') || message.contains('worried') || message.contains('stress')) {
      return "Anxiety can be overwhelming. Try taking a few deep breaths. What's been causing you the most stress lately?";
    } else if (message.contains('angry') || message.contains('frustrated') || message.contains('mad')) {
      return "I understand you're feeling frustrated. It's normal to feel angry sometimes. What triggered these feelings?";
    } else if (message.contains('happy') || message.contains('good') || message.contains('great')) {
      return "I'm glad to hear you're feeling positive! What's been going well for you?";
    } else if (message.contains('tired') || message.contains('exhausted') || message.contains('sleep')) {
      return "Being tired can affect how we feel. Have you been getting enough rest? What's your sleep routine like?";
    } else if (message.contains('help') || message.contains('support')) {
      return "I'm here to help and support you. You're not alone in this. What kind of support would be most helpful right now?";
    } else {
      // Use rotating default responses
      String response = _botResponses[_currentResponseIndex % _botResponses.length];
      _currentResponseIndex++;
      return response;
    }
  }
  
  void _addBotMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }
  
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Support Chat'),
        backgroundColor: Colors.teal[300],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Input area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.teal[100],
              child: Icon(Icons.psychology, color: Colors.teal),
              radius: 16,
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? Colors.blue[500] 
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, color: Colors.blue),
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
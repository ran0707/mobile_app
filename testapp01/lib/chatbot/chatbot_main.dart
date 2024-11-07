import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatBotMain extends StatefulWidget {
  const ChatBotMain({super.key});

  @override
  State<ChatBotMain> createState() => _ChatBotMainState();
}

class _ChatBotMainState extends State<ChatBotMain> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final _greetings = ['hi', 'hello', 'hey'];
  final _suggestion = [
    "About Tea",
    "About Red Spider mite",
    "About Tea Mosquito bug",
    "Talk to Expert",
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({"text": text, "isSentByMe": true});
    });
    _controller.clear();
    _simulateResponse(text.toLowerCase());
  }

  Future<void> _simulateResponse(String message) async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      final response = _handleGreeting(message) ?? "What can I help you with?";
      _messages.add({"text": response, "isSentByMe": false});
      if (_greetings.contains(message)) {
        for (var suggestion in _suggestion) {
          _messages.add({
            "text": suggestion,
            "isSentByMe": false,
            "isSuggestion": true,
            "isClickable":true
          });
        }
      }
    });
  }

  String? _handleGreeting(String message) {
    if (_greetings.contains(message.toLowerCase())) {
      return " Hi there! How can I help you today?";
    } else if (message == "about red spider mite") {
      return "Red spider mites are common pests that feed on plant leaves.";
    } else if (message == "about tea mosquito bug") {
      return "Tea mosquito bugs are pests that affect tea plants, causing damage to the leaves.";
    } else if (message == "about tea") {
      return "Tea is a popular beverage made from the leaves of the Camellia sinensis plants.";
    }else if (message == "talk to expert") {
      return "Expert Contact:\nMobile: +1234567890\nEmail: expert@example.com\nRegion: North Region";
    }
    return "Sorry, I didn't understand";
  }

  void _handleSuggestionClick(String suggestion){
    setState(() {
      _messages.add({"text":suggestion, "isSentByMe": true});
    });
    _simulateResponse(suggestion.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Camellia chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                if(message["isClickable"] == true){
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: ()=> _handleSuggestionClick(message["text"]),
                      child: IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            message["text"],
                            style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return ChatBubble(
                  clipper: ChatBubbleClipper1(
                    type: message["isSentByMe"]
                        ? BubbleType.sendBubble
                        : BubbleType.receiverBubble,
                  ),
                  alignment: message["isSentByMe"]
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20),
                  backGroundColor: message["isSentByMe"]
                      ? Colors.blueAccent
                      : Colors.grey[200],
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(
                      message["text"],
                      style: TextStyle(
                        color:
                            message["isSentByMe"] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

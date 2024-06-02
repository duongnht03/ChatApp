import 'package:flutter/material.dart';
import 'package:chatapp/models/chat_bubble.dart';

class BoxChat extends StatefulWidget {
  const BoxChat({Key? key}) : super(key: key);

  @override
  State<BoxChat> createState() => _BoxChatScreenState();
}

class _BoxChatScreenState extends State<BoxChat> {
  final _controller = TextEditingController();
  final List<ChatBubble> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.insert(0, ChatBubble(text: _controller.text, isCurrentUser: true));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (ctx, index) => _messages[index],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Nhập tin nhắn...'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
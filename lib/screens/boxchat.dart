import 'dart:ui';

import 'package:chatapp/models/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/chat_bubble.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import 'call_screen.dart';

class BoxChat extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  // final String otherUserAvatar;

  BoxChat({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    // required this.otherUserAvatar,
  });

  @override
  State<BoxChat> createState() => _BoxChatScreenState();
}

class _BoxChatScreenState extends State<BoxChat> {
  final _controller = TextEditingController();
  String? _selectedMessageId;
  final ImagePicker _picker = ImagePicker();
  Color _bubbleColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadBubbleColor();
  }

  void _loadBubbleColor() async {
    try {
      DocumentSnapshot chatDoc = await FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatId)
          .get();

      if (chatDoc.exists && chatDoc.data() != null) {
        final data = chatDoc.data() as Map<String, dynamic>;
        final bubbleColorHex = data['bubbleColor'] as String?;
        if (bubbleColorHex != null) {
          setState(() {
            _bubbleColor = _colorFromHex(bubbleColorHex);
          });
        }
      }
    } catch (e) {
      print('Error loading bubble color: $e');
    }
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  void _sendMessage(String content, String senderId) async {
    if (content.trim().isEmpty) {
      return;
    }

    Message message = Message(
      senderId: senderId,
      content: content,
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.chatId)
        .collection('listMessage')
        .add(message.toJson());

    _controller.clear();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Handle image upload to Firestore storage and get the URL here

      // Example: Assume `imageUrl` is the URL of the uploaded image
      String imageUrl =
          pickedFile.path; // Replace this with actual upload logic

      final user = Provider.of<UserProvider>(context, listen: false).user;

      Message message = Message(
        senderId: user!.id.toString(),
        content: imageUrl,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatId)
          .collection('listMessage')
          .add(message.toJson());
    }
  }

  void _toggleSelectedMessage(String messageId) {
    setState(() {
      if (_selectedMessageId == messageId) {
        _selectedMessageId = null;
      } else {
        _selectedMessageId = messageId;
      }
    });
  }

  void _openColorPicker() async {
    Color pickedColor = await showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _bubbleColor;
        return AlertDialog(
          title: Text("Chọn màu cho chat bubble"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text("Chọn"),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );

    setState(() {
      _bubbleColor = pickedColor;
    });

    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.chatId)
        .update({
      'bubbleColor': _colorToHex(_bubbleColor),
    });
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // CircleAvatar(
            //   backgroundImage: widget.otherUserAvatar.isNotEmpty
            //       ? NetworkImage(widget.otherUserAvatar)
            //       : AssetImage('assets/default_avatar.png') as ImageProvider,
            // ),
            SizedBox(width: 10),
            Text(widget.otherUserName),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openColorPicker,
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CallScreen(channelId: widget.chatId),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc(widget.chatId)
                  .collection('listMessage')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs.map((doc) {
                  var message =
                      Message.fromJson(doc.data() as Map<String, dynamic>);
                  return {
                    'message': message,
                    'messageId': doc.id,
                  };
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    var messageData = messages[index];
                    var message = messageData['message'] as Message;
                    var messageId = messageData['messageId'] as String;
                    return GestureDetector(
                      onTap: () {
                        _toggleSelectedMessage(messageId);
                      },
                      child: Column(
                        children: [
                          ChatBubble(
                            text: message.content,
                            isCurrentUser:
                                message.senderId == user!.id.toString(),
                            imageUrl: message.content.startsWith('http')
                                ? message.content
                                : null,
                            color: _bubbleColor,
                          ),
                          if (_selectedMessageId == messageId)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    message.senderId == user.id.toString()
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sent at ${message.timestamp}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Nhập tin nhắn...'),
                    onSubmitted: (_) =>
                        _sendMessage(_controller.text, user!.id.toString()),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () =>
                      _sendMessage(_controller.text, user!.id.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

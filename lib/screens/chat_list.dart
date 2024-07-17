import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dio/dio.dart';
import 'package:chatapp/screens/boxchat.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/user_provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatList> {
  Future<List<Map<String, dynamic>>> _loadChats(BuildContext context) async {
    String? userId =
        Provider.of<UserProvider>(context, listen: false).user?.id.toString();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Chats')
        .where('firstID', isEqualTo: userId)
        .get();

    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('Chats')
        .where('secondID', isEqualTo: userId)
        .get();

    // Kết hợp hai kết quả truy vấn
    List<QueryDocumentSnapshot> allChats = [];
    allChats.addAll(querySnapshot.docs);
    allChats.addAll(querySnapshot2.docs);

    List<Map<String, dynamic>> loadedChats = [];
    // Tải thông tin người dùng khác
    for (var chatDoc in allChats) {
      String otherUserId = chatDoc['firstID'] == userId
          ? chatDoc['secondID']
          : chatDoc['firstID'];
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(otherUserId)
          .get();
      // Xử lý thông tin người dùng khác (bạn có thể lưu vào danh sách để hiển thị)
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        loadedChats.add({
          'chatId': chatDoc.id,
          'otherUserId': userDoc.id,
          'otherUserName': userData['name'],
          'otherUserAvatar': userData['avatar'],
        });
      }
    }
    return loadedChats;
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
    Icon(Icons.chat),
    Icon(Icons.call),
    Icon(Icons.contact_phone),
    Icon(Icons.book),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Provider.of<UserProvider>(context, listen: false).clearUser();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/loginScreen',
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? 'No Name'),
              accountEmail: Text(user?.email ?? 'No Email'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings navigation
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadChats(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No chats available'));
                } else {
                  List<Map<String, dynamic>> chatList = snapshot.data!;
                  return ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      var chat = chatList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BoxChat(chatId: chat['chatId'], otherUserId: chat['otherUserId'], otherUserName: chat['otherUserName'])));
                        },
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {}),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoxChat(chatId: chat['chatId'], otherUserId: chat['otherUserId'], otherUserName: chat['otherUserName'])));
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.details,
                                label: 'Details',
                              ),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1),
                            ),
                            child: ListTile(
                              title: Text('${chat['otherUserName']}'),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Call',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone),
              label: 'Contacts',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Story',
              backgroundColor: Colors.black)
        ],
      ),
    );
  }
}

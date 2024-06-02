import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dio/dio.dart';
import 'package:chatapp/screens/boxchat.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatList> {
  final TextEditingController _email = TextEditingController();
  // Future<List<ProductModel>> getAllProduct() async {
  //   final res = await Dio().get("https://dummyjson.com/products");
  //   List<ProductModel> data = (res.data["products"] as List)
  //       .map((e) => ProductModel.fromJson(e))
  //       .toList();
  //   return data;
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text("Đoạn chat"),
        actions: <Widget>[
          Icon(Icons.type_specimen),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Tiến Anh Nguyễn'), // Tên người dùng
              accountEmail: Text('anhnht@gmail.com'), // Email người dùng
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://zpsocial-f52-org.zadn.vn/9088a6052d40cc1e9551.jpg'), // Ảnh đại diện
              ),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Tìm kiếm'),
              onTap: () {
                // Xử lý khi người dùng chọn tìm kiếm
                // TODO: Chuyển đến trang tìm kiếm
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Đăng xuất'),
              onTap: () {
                // Xử lý khi người dùng chọn đăng xuất
                Navigator.pop(context); // Đóng Drawer
                // TODO: Thực hiện đăng xuất
              },
            ),
          ],
        ),
      ),
      // body: FutureBuilder(
      //   future: getAllProduct(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else {
      //       return ListView.builder(
      //         itemCount: snapshot.data.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return InkWell(
      //             onTap: () {
      //               Navigator.push(context, MaterialPageRoute(
      //                   builder: (context) => const BoxChat()));
      //             },
      //             child: Slidable(
      //               endActionPane: ActionPane(
      //                 motion: ScrollMotion(),
      //                 dismissible: DismissiblePane(onDismissed: () {}),
      //                 children: [
      //                   SlidableAction(
      //                     onPressed: (context) {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) => Detail(index: index + 1)),
      //                       );
      //                     },
      //                     backgroundColor: Color(0xFFFE4A49),
      //                     foregroundColor: Colors.white,
      //                     icon: Icons.details,
      //                     label: 'Details',
      //                   ),
      //                 ],
      //               ),
      //               child: Container(
      //                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      //                 margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      //                 decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   border: Border.all(width: 1),
      //                 ),
      //                 child: ListTile(
      //                   title: Text('ID: ${snapshot.data[index].id}'),
      //                   subtitle: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: <Widget>[
      //                       Text('Title: ${snapshot.data[index].title}'),
      //                       Text('Price: ${snapshot.data[index].price}'),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),
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

// void doNothing(BuildContext context) {}
}

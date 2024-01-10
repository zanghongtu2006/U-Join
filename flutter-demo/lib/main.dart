import 'package:flutter/material.dart';
import 'package:flutter_demo/service/ChatService.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    chatService.connectWithRetry();
    return MaterialApp(
      title: 'IM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // 假设这是聊天记录的数据
  List<String> chatList = [
    "Alice: Hi!",
    "Bob: Hello!",
    "Carol: Good Morning!"
    // 更多聊天数据...
  ];

  // 搜索逻辑
  List<String> searchResults = [];

  void searchChats(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = chatList;
      });
      return;
    }
    setState(() {
      searchResults = chatList
          .where((chat) => chat.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    searchResults = chatList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聊天'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        color: Colors.blue[50], // 设置背景颜色为浅蓝色
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: searchChats,
                decoration: const InputDecoration(
                  labelText: '搜索聊天记录',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    // 使用卡片样式显示每条聊天记录
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150'), // 这是一个占位符图片，你可以替换成任何你想要的图片URL
                      ),
                      title: Text(searchResults[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 固定显示所有菜单项
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '聊天'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: '通讯录'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '我'),
        ],
        selectedItemColor: Colors.blue, // 设置选中项的颜色
      ),
    );
  }
}

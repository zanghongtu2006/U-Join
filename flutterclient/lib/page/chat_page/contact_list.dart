import 'package:flutter/material.dart';

import 'contact_bottom_sheet_content.dart';

class ContactListPage extends StatelessWidget {
  final String filter;

  const ContactListPage({Key? key, required this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(filter)],
      )),
      body: ListView.separated(
        itemCount: 10, // 假设有10个联系人
        itemBuilder: (context, index) {
          // 这里应该用您的数据模型替换假数据，并应用筛选条件 `filter`
          return ContactListItem(
            avatarUrl:
                'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F9e18d14b-8a44-41b0-97d9-6aed05b70e7f%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1708239669&t=7419a9b0c446be680b50cf09098fe810',
            // 用户头像URL
            nickname: '$filter $index',
            // 使用筛选条件作为昵称的一部分
            age: '26',
            // 用户年龄
            height: '177cm',
            // 用户身高
            extraInfo: '信息',
            // 其他信息，如职业
            bio: '这里是用户的个性签名或简介',
            // 用户简介
            isOnline: true, // 用户是否在线
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}

class ContactListItem extends StatelessWidget {
  final String avatarUrl;
  final String nickname;
  final String age;
  final String height;
  final String extraInfo;
  final String bio;
  final bool isOnline;

  const ContactListItem({
    Key? key,
    required this.avatarUrl,
    required this.nickname,
    required this.age,
    required this.height,
    required this.extraInfo,
    required this.bio,
    required this.isOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
          title: Row(
            children: [
              Text('$nickname ', style: const TextStyle()),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(' $age · $height ',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(bio, style: const TextStyle(fontSize: 12)),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return BottomSheetContent(); // 使用我们定义的类
                },
              );
            },
          ),
          onTap: () {
            // 点击后的行为，例如导航到新页面
          },
        ),
      ],
    );
  }
}

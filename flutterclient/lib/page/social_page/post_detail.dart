// import 'package:flutter/material.dart';
//
// class PostDetailsPage extends StatelessWidget {
//   final Post post; // 假设Post是你的朋友圈内容模型
//
//   PostDetailsPage({Key? key, required this.post}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('朋友圈详情'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildUserInfo(post.user), // 构建用户信息行
//                 Text(post.content), // Post内容
//                 _buildMedia(post.mediaType, post.mediaUrl), // 构建媒体内容
//                 _buildPostStats(post.likesCount, post.commentsCount, post.location), // 点赞、评论数和位置信息
//               ],
//             ),
//           ),
//           Expanded(
//             child: _buildCommentsList(post.comments), // 构建评论列表
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUserInfo(User user) {
//     return Row(
//       children: [
//         CircleAvatar(
//           backgroundImage: NetworkImage(user.avatarUrl),
//         ),
//         SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(user.name),
//             Text('${user.gender}, ${user.age}, ${user.height}cm'),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMedia(String mediaType, String mediaUrl) {
//     switch (mediaType) {
//       case 'image':
//         return Image.network(mediaUrl);
//       case 'video':
//       // 这里你需要使用VideoPlayerWidget来播放视频
//         return Container(); // 示例中暂时使用空容器代替
//       case 'audio':
//       // 这里你需要自己实现音频播放的逻辑
//         return Container(); // 示例中暂时使用空容器代替
//       default:
//         return SizedBox.shrink();
//     }
//   }
//
//   Widget _buildPostStats(int likesCount, int commentsCount, String location) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text('点赞: $likesCount'),
//         Text('评论: $commentsCount'),
//         Text(location),
//       ],
//     );
//   }
//
//   Widget _buildCommentsList(List<Comment> comments) {
//     return ListView.builder(
//       itemCount: comments.length,
//       itemBuilder: (context, index) {
//         final comment = comments[index];
//         return ListTile(
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(comment.user.avatarUrl),
//           ),
//           title: Text(comment.user.name),
//           subtitle: Text(comment.content),
//         );
//       },
//     );
//   }
// }
//
// // 假设你有以下模型
// class Post {
//   User user;
//   String content;
//   String mediaType;
//   String mediaUrl;
//   int likesCount;
//   int commentsCount;
//   String location;
//   List<Comment> comments;
//
//   Post({
//     required this.user,
//     required this.content,
//     required this.mediaType,
//     required this.mediaUrl,
//     required this.likesCount,
//     required this.commentsCount,
//     required this.location,
//     required this.comments,
//   });
// }
//
// class User {
//   String name;
//   String avatarUrl;
//   String gender;
//   int age;
//   int height;
//
//   User({
//     required this.name,
//     required this.avatarUrl,
//     required this.gender,
//     required this.age,
//     required this.height,
//   });
// }
//
// class Comment {
//   User user;
//   String content;
//
//   Comment({required this.user, required this.content});
// }

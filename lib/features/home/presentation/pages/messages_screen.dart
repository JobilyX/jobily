import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../chat/domain/entities/chat_user.dart';
import '../../../chat/presentation/pages/chat_page.dart';

class MesagesScreen extends StatelessWidget {
  const MesagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<LoginCubit>().user.body.user;
    return Padding(
        padding: sidePadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SpaceV20BE(),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.id.toString())
                    .collection("mychats")
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(mainColor)));
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No_Messages_Yet".tr(),
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    );
                  }
                  List<ChatUser> myChatsUsers = snapshot.data!.docs
                      .map<ChatUser>((e) => ChatUser.fromMap(e.data()))
                      .toList();
                  return ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) => const Divider(
                            height: 2,
                            thickness: 2,
                          ),
                      itemBuilder: (ctx, i) => GestureDetector(
                          onTap: () {
                            final user =
                                context.read<LoginCubit>().user.body.user;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ChatPage(
                                      user1: ChatUser.fromAppUser(user),
                                      user2: (myChatsUsers[i]),
                                    )));
                          },
                          child: _buildChatCard(
                              myChatsUsers[i], user.id.toString())),
                      itemCount: myChatsUsers.length);
                }),
          )
        ]));
  }

  Widget _buildChatCard(ChatUser user, String id) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: mainColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
                progressIndicatorBuilder: (ctx, st, d) => CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      backgroundImage: NetworkImage(
                        user.image,
                      ),
                    ),
                fit: BoxFit.fill,
                imageUrl: user.image,
                imageBuilder: (ctx, im) {
                  return CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      backgroundImage: im);
                },
                errorWidget: (ctx, string, e) => const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      backgroundImage: AssetImage(
                        "assets/images/logo.png",
                      ),
                    )),
            Text(user.username,
                style: const TextStyle(color: mainColor, fontSize: 16.0)),
            _buildUnReadNumber(user, id),
          ],
        ));
  }

  Widget _buildUnReadNumber(ChatUser doc, String id) {
    String chatGroupId;
    if (id.hashCode > doc.id.hashCode) {
      chatGroupId = '$id-${doc.id}';
    } else {
      chatGroupId = '${doc.id}-$id';
    }
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(chatGroupId)
            .collection(chatGroupId)
            .where('isRead', isEqualTo: false)
            .where("idFrom", isEqualTo: doc.id.toString())
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> sh) {
          if (!sh.hasData) return Container();
          if (sh.data == null) return Container();
          if (sh.data!.docs.isEmpty) return Container();
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(10)),
            child: Text(sh.data!.docs.length.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12.0)),
          );
        });
  }
}

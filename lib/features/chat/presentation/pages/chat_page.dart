import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../domain/entities/chat_user.dart';
import '../../domain/usecases/set_chatting_Id_for_users.dart';
import '../cubit/chat_cubit.dart';
import '../widgets/message_input_widget.dart';
import '../widgets/message_list_widget.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/chat-page';
  final ChatUser user2;
  final ChatUser user1;

  const ChatPage({Key? key, required this.user2, required this.user1})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final String chatGroupId;
  final _focusNode = FocusNode();

  late final String userId;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // _focusNode.addListener(_onFocusChanged);
    _readUserData();
    userId = widget.user1.id.toString();
    context.read<ChatCubit>().cancelReplay();
    context.read<ChatCubit>().isSendingImages = false;
    context.read<ChatCubit>().fSetChattingIdForUsers(
        params: SetChattingIdForUsersParams(
          user1: widget.user1,
          user2: widget.user2,
          userId1: widget.user1.id.toString(),
          userId2: widget.user2.id.toString(),
        ),
        scaffoldKey: scaffoldKey);
  }

  _readUserData() {
    if (widget.user1.id.hashCode > widget.user2.id.hashCode) {
      chatGroupId = '${widget.user1.id}-${widget.user2.id}';
    } else {
      chatGroupId = '${widget.user2.id}-${widget.user1.id}';
    }
  }

  // widget and ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              widget.user1.userType == "hr" ? accentColor : mainColor,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: FittedBox(
            child: Text(
              widget.user2.username.toString(),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            // pageAppBar(
            //   pageTitle: widget.user2.username.toString(),
            //   withoutBackBtn: false,
            // ),
            Expanded(
                child: MessagesList(
              scaffoldKey: scaffoldKey,
              userId: userId,
              chatGroupId: chatGroupId,
              user2: widget.user2,
            )),
            MessageInput(
              onCancelReplay: () {
                context.read<ChatCubit>().cancelReplay();
              },
              scaffoldKey: scaffoldKey,
              chatGroupId: chatGroupId,
              user1: widget.user1,
              user2: widget.user2,
            ),
          ],
        ));
  }
}

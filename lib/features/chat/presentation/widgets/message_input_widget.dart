import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../domain/entities/chat_user.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/uplaod_Image_to_server.dart';
import '../cubit/chat_cubit.dart';

class MessageInput extends StatefulWidget {
  final ChatUser user1, user2;
  final String chatGroupId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback onCancelReplay;
  const MessageInput({
    Key? key,
    required this.user1,
    required this.user2,
    required this.chatGroupId,
    required this.scaffoldKey,
    required this.onCancelReplay,
  }) : super(key: key);
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  late final ScrollController listScrollController;
  late File _image;
  final picker = ImagePicker();
  late final FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = context.read<ChatCubit>().focusNode;
    listScrollController = context.read<ChatCubit>().listScrollController;
  }

  final messageFieldController = TextEditingController();
  bool isImageOptionClicked = false;
  bool isTyping = false;
  bool isTypingInArabic = false;
  Future<void> sendIndImage(Uint8List imageData) async {
    final result = await context.read<ChatCubit>().fuplaodImageToServer(
        scaffoldKey: widget.scaffoldKey,
        params: UplaodImageToServerParams(
          chatGroupId: widget.chatGroupId,
          image: imageData,
        ));
    final message = Message(
      senderName: widget.user1.username,
      idFrom: widget.user1.id.toString(),
      idTo: widget.user2.id.toString(),
      content: result?.url ?? "",
      type: MessageType.image,
      isRead: false,
      timestamp: result?.fileName ?? "",
    );
    // await _sendMessage(message);
    await context.read<ChatCubit>().fsendMessage(
        params: SendMessageParams(
            reciver: widget.user2,
            sender: widget.user1,
            message: message,
            chatGroupId: widget.chatGroupId),
        scaffoldKey: widget.scaffoldKey);
  }

  Future getImage(bool camera) async {
    late final PickedFile? pickedFile;
    if (camera) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      final byteData = await _image.readAsBytes();
      Uint8List imageData = byteData.buffer.asUint8List();
      await sendIndImage(imageData);
    }
  }

  bool _checkForArabicLetter(String text) {
    final arabicRegex = RegExp(r'[ء-ي-_ \.]*$');
    final englishRegex = RegExp(r'[a-zA-Z ]');
    return text.contains(arabicRegex) && !text.startsWith(englishRegex);
  }

  Future<void> _sendMessage(Message message) async {
    context.read<ChatCubit>().fsendMessage(
        params: SendMessageParams(
            reciver: widget.user2,
            sender: widget.user1,
            message: message,
            chatGroupId: widget.chatGroupId),
        scaffoldKey: widget.scaffoldKey);
    if (listScrollController.hasClients) {
      listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, ch) {
      Message? replayMessage = context.watch<ChatCubit>().replayMessage;
      return Column(
        children: [
          if (replayMessage != null)
            ReplayWidget(
              isView: false,
              replayMessage: replayMessage,
            ),
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    focusNode.unfocus();
                    setState(() {
                      isImageOptionClicked = !isImageOptionClicked;
                    });
                    getImage(false);
                  },
                  onTapDown: (_) {
                    setState(() {
                      isImageOptionClicked = !isImageOptionClicked;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      isImageOptionClicked = !isImageOptionClicked;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.image,
                      color: isImageOptionClicked ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getImage(true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.camera_alt,
                      color: isImageOptionClicked ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 4.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 4.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      focusNode: focusNode,
                      controller: messageFieldController,
                      textAlign:
                          isTypingInArabic ? TextAlign.right : TextAlign.left,
                      textDirection: isTypingInArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      // maxLines: 6,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        // hoverColor: Colors.white,
                        // fillColor: Colors.white,
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: mainColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: mainColor,
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged: (String value) {
                        value = value.replaceAll(r'>', "&gt;");
                        value = value.replaceAll(r'<', "&lt;");
                        if (value.trim().isNotEmpty) {
                          isTyping = true;
                          if (_checkForArabicLetter(value)) {
                            isTypingInArabic = true;
                          }
                        } else {
                          isTyping = false;
                          isTypingInArabic = false;
                        }
                        setState(() {});
                      },
                      onEditingComplete: isTyping
                          ? () {
                              final message = Message(
                                senderName: widget.user1.username,
                                idFrom: widget.user1.id.toString(),
                                idTo: widget.user2.id.toString(),
                                content: messageFieldController.text.trim(),
                                type: MessageType.text,
                                isRead: false,
                                timestamp: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                              );
                              messageFieldController.clear();
                              focusNode.unfocus();
                              setState(() {
                                isTypingInArabic = false;
                                isTyping = !isTyping;
                              });
                              _sendMessage(message);
                            }
                          : null,
                    ),
                  ),
                ),
                InkWell(
                  onTap: isTyping
                      ? () {
                          final message = Message(
                            senderName: widget.user1.username,
                            idFrom: widget.user1.id.toString(),
                            idTo: widget.user2.id.toString(),
                            content: messageFieldController.text.trim(),
                            type: MessageType.text,
                            isRead: false,
                            timestamp: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                          );
                          messageFieldController.clear();
                          focusNode.unfocus();
                          setState(() {
                            isTypingInArabic = false;
                            isTyping = !isTyping;
                          });
                          _sendMessage(message);
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.send,
                      color: isTyping ? mainColor : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class ReplayWidget extends StatelessWidget {
  const ReplayWidget(
      {Key? key, required this.replayMessage, required this.isView})
      : super(key: key);
  final Message replayMessage;
  final bool isView;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: replayMessage.type == MessageType.image ? 200 : null,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        color: Colors.grey.withOpacity(.25),
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(color: mainColor, width: 4),
            const SizedBox(width: 10),
            Expanded(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        replayMessage.senderName,
                      ),
                    ),
                    if (!isView)
                      GestureDetector(
                        onTap: () {
                          context.read<ChatCubit>().cancelReplay();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 18,
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 8),
                replayMessage.type == MessageType.text
                    ? Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          replayMessage.content,
                        ))
                    : SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: replayMessage.content,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                        ),
                      )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

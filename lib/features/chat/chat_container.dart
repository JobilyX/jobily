import 'package:get_it/get_it.dart';

import 'data/datasources/chat_remote_datasource.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/usecases/get_messages.dart';
import 'domain/usecases/get_new_messages.dart';
import 'domain/usecases/mark_peer_messages_as_read.dart';
import 'domain/usecases/send_message.dart';
import 'domain/usecases/set_chatting_Id_for_users.dart';
import 'domain/usecases/uplaod_Image_to_server.dart';
import 'presentation/cubit/chat_cubit.dart';

Future<void> initChatInjection(GetIt sl) async {
  sl.registerLazySingleton(() => ChatCubit(
        getNewMessagesCount: sl(),
        markPeerMessagesAsRead: sl(),
        uplaodImageToServer: sl(),
        getAllMessages: sl(),
        sendMessage: sl(),
        setChattingIdForUsers: sl(),
      ));
  sl.registerLazySingleton(() => SetChattingIdForUsers(repository: sl()));
  sl.registerLazySingleton(() => SendMessage(repository: sl()));
  sl.registerLazySingleton(() => GetAllMessages(repository: sl()));
  sl.registerLazySingleton(() => UplaodImageToServer(repository: sl()));
  sl.registerLazySingleton(() => MarkPeerMessagesAsRead(repository: sl()));
  sl.registerLazySingleton(() => GetNewMessagesCount(repository: sl()));

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remote: sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      firebaseMessaging: sl(),
      firestore: sl(),
      storage: sl(),
    ),
  );
}

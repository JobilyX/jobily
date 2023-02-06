part of 'get_posts_cubit.dart';

abstract class GetPostsState extends Equatable {
  const GetPostsState();

  @override
  List<Object> get props => [];
}

class GetPostsInitial extends GetPostsState {}

class GetPostsSuccess extends GetPostsState {}

class GetPostsLoading extends GetPostsState {}

class DeleteLoading extends GetPostsState {
  final int id;

  const DeleteLoading({required this.id});
}

class GetPostsError extends GetPostsState {
  const GetPostsError({required this.message});
  final String message;
}

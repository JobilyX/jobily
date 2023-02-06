part of 'add_post_cubit.dart';

abstract class AddPostState extends Equatable {
  const AddPostState();

  @override
  List<Object> get props => [];
}

class AddPostInitial extends AddPostState {}

class AddPostSuccess extends AddPostState {}

class AddPostLoading extends AddPostState {}

class AddPostError extends AddPostState {
  const AddPostError({required this.message});
  final String message;
}

class AddPostChangeSkill extends AddPostState {}

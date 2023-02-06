part of 'get_post_by_id_cubit.dart';

abstract class GetPostByIdState extends Equatable {
  const GetPostByIdState();

  @override
  List<Object> get props => [];
}

class GetPostByIdInitial extends GetPostByIdState {}

class GetPostByIdSuccess extends GetPostByIdState {
  final JobByIdResponse response;
  const GetPostByIdSuccess({
    required this.response,
  });
}

class GetPostByIdLoading extends GetPostByIdState {}

class GetPostByIdChangeStatusLoading extends GetPostByIdState {
  final int id;

  const GetPostByIdChangeStatusLoading({required this.id});
}

class GetPostByIdError extends GetPostByIdState {
  const GetPostByIdError({required this.message});
  final String message;
}

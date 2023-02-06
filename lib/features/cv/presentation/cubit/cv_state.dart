// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cv_cubit.dart';

abstract class CvState extends Equatable {
  const CvState();

  @override
  List<Object> get props => [];
}

class CvInitial extends CvState {}

class CvChangeSkill extends CvState {}

class CvLoading extends CvState {}

class CvDeleteLoading extends CvState {}

class CvError extends CvState {
  final String message;
  const CvError({
    required this.message,
  });
}

class CvSuccess extends CvState {}

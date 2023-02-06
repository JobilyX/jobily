import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../domain/usecases/connect_us.dart';
import '../../../domain/usecases/get_complaint_types.dart';

import '../../../domain/entities/get_complain_types.dart';
import '../../../domain/usecases/complaint_and_suggestion.dart';

part 'connect_us_states.dart';

class ConnectUsCubit extends Cubit<ConnectUsState> {
  ConnectUsCubit(
      {required this.complaintAndSuggestion,
      required this.getComplaintTypes,
      required this.connectUs})
      : super(ConnectUsInitial());
  final ConnectUs connectUs;
  final ComplaintAndSuggestion complaintAndSuggestion;
  final GetComplaintTypes getComplaintTypes;
  String connectUsBody = "";
  List<ComplaintTypesDetails> types = [];
  // ComplaintTypes types = [] as ComplaintTypes;
  ComplaintTypesDetails? selectedType;

  Future<void> fConnectUs({
    required String email,
    required String name,
    required String message,
    required String phone,
  }) async {
    emit(ConnectUsLoading());
    final ConnectUsParams params = ConnectUsParams(
      email: email,
      name: name,
      message: message,
      phone: phone,
    );
    final response = await connectUs(params);
    response.fold((fail) async {
      String message = 'please try again later';
      if (fail is ServerFailure) {
        message = fail.message;
      }
      emit(ConnectUsError(message: message));
      emit(ConnectUsInitial());
    }, (info) async {
      emit(ConnectUsSuccess());
    });
  }

  Future<void> fSendComplaint({
    required String email,
    required String name,
    required String message,
  }) async {
    final ComplaintAndSuggestionParams params = ComplaintAndSuggestionParams(
        email: email,
        name: name,
        message: message,
        complaintTypeId: selectedType!.id);
    emit(ConnectUsLoading());
    final response = await complaintAndSuggestion(params);
    response.fold((fail) async {
      String message = 'please try again later';
      if (fail is ServerFailure) {
        message = fail.message;
      }
      emit(ConnectUsError(message: message));
      emit(ConnectUsInitial());
    }, (info) async {
      emit(ConnectUsSuccess());
    });
  }

  Future<void> fGetComplaint({final ComplaintTypes? complaintTypes}) async {
    emit(ComplaintTypesLoading());
    final response = await getComplaintTypes(NoParams());
    response.fold((fail) async {
      String message = 'please try again later';
      if (fail is ServerFailure) {
        message = fail.message;
      }
      emit(ComplaintTypesError(message: message));
      emit(ComplaintTypesInitial());
    }, (info) async {
      if (info.complaintTypes.isNotEmpty) {
        selectedType = info.complaintTypes.first;
      }
      types = info.complaintTypes;
      emit(ComplaintTypesSuccess());
    });
  }

  changeType(ComplaintTypesDetails type) {
    selectedType = type;
  }
}

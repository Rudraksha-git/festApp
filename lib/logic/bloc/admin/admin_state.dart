import 'package:equatable/equatable.dart';

sealed class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminIdle extends AdminState {
  const AdminIdle();
}

class AdminActionProgress extends AdminState {
  const AdminActionProgress();
}

class AdminActionSuccess extends AdminState {
  final String message;

  const AdminActionSuccess([this.message = 'Success']);

  @override
  List<Object?> get props => [message];
}

class AdminActionError extends AdminState {
  final String message;

  const AdminActionError(this.message);

  @override
  List<Object?> get props => [message];
}


import 'package:equatable/equatable.dart';

sealed class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegIdle extends RegistrationState {
  const RegIdle();
}

class RegSubmitting extends RegistrationState {
  const RegSubmitting();
}

class RegSuccess extends RegistrationState {
  final String ticketId;

  const RegSuccess(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class RegFailure extends RegistrationState {
  final String message;

  const RegFailure(this.message);

  @override
  List<Object?> get props => [message];
}


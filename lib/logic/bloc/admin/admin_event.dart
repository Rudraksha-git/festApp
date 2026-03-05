import 'package:equatable/equatable.dart';

sealed class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class CreateNewEvent extends AdminEvent {
  final Map<String, dynamic> eventData;

  const CreateNewEvent(this.eventData);

  @override
  List<Object?> get props => [eventData];
}

class PostNotice extends AdminEvent {
  final Map<String, dynamic> noticeData;

  const PostNotice(this.noticeData);

  @override
  List<Object?> get props => [noticeData];
}

class DeleteEvent extends AdminEvent {
  final String eventId;

  const DeleteEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}


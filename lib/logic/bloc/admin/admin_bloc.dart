import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final FirebaseFirestore _firestore;

  AdminBloc({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(const AdminIdle()) {
    on<CreateNewEvent>(_onCreateNewEvent);
    on<PostNotice>(_onPostNotice);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onCreateNewEvent(
    CreateNewEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminActionProgress());
    try {
      await _firestore.collection('events').add(<String, dynamic>{
        ...event.eventData,
        'createdAt': FieldValue.serverTimestamp(),
        'registeredCount': event.eventData['registeredCount'] ?? 0,
      });
      emit(const AdminActionSuccess('Event created'));
      emit(const AdminIdle());
    } on FirebaseException catch (e) {
      emit(AdminActionError(e.message ?? 'Permission denied or upload failed'));
    } catch (_) {
      emit(const AdminActionError('Permission denied or upload failed'));
    }
  }

  Future<void> _onPostNotice(
    PostNotice event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminActionProgress());
    try {
      await _firestore.collection('notices').add(<String, dynamic>{
        ...event.noticeData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      emit(const AdminActionSuccess('Notice posted'));
      emit(const AdminIdle());
    } on FirebaseException catch (e) {
      emit(AdminActionError(e.message ?? 'Permission denied'));
    } catch (_) {
      emit(const AdminActionError('Permission denied'));
    }
  }

  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminActionProgress());
    try {
      await _firestore.collection('events').doc(event.eventId).delete();
      emit(const AdminActionSuccess('Event deleted'));
      emit(const AdminIdle());
    } on FirebaseException catch (e) {
      emit(AdminActionError(e.message ?? 'Permission denied'));
    } catch (_) {
      emit(const AdminActionError('Permission denied'));
    }
  }
}


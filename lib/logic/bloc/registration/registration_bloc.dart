import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final FirebaseFirestore _firestore;

  RegistrationBloc({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(const RegIdle()) {
    on<SubmitRegistration>(_onSubmitRegistration);
  }

  Future<void> _onSubmitRegistration(
    SubmitRegistration event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegSubmitting());

    try {
      final userId = (event.userData['userId'] ?? '').toString().trim();
      if (userId.isEmpty) {
        emit(const RegFailure('Missing userId'));
        return;
      }

      final eventRef = _firestore.collection('events').doc(event.eventId);
      final regDocId = '${event.eventId}_$userId';
      final regRef = _firestore.collection('registrations').doc(regDocId);

      await _firestore.runTransaction((tx) async {
        final regSnap = await tx.get(regRef);
        if (regSnap.exists) {
          throw const _RegistrationException.alreadyRegistered();
        }

        final eventSnap = await tx.get(eventRef);
        if (!eventSnap.exists) {
          throw const _RegistrationException.eventNotFound();
        }

        final data = eventSnap.data() ?? <String, dynamic>{};
        final capacity = (data['capacity'] as int?) ?? 0;
        final registeredCount = (data['registeredCount'] as int?) ?? 0;
        final isFull = capacity > 0 && registeredCount >= capacity;
        if (isFull) {
          throw const _RegistrationException.eventFull();
        }

        tx.set(regRef, <String, dynamic>{
          'eventId': event.eventId,
          'userId': userId,
          'userData': event.userData,
          'createdAt': FieldValue.serverTimestamp(),
        });

        tx.update(eventRef, <String, dynamic>{
          'registeredCount': FieldValue.increment(1),
        });
      });

      emit(RegSuccess(regDocId));
    } on _RegistrationException catch (e) {
      emit(RegFailure(e.message));
    } on FirebaseException catch (e) {
      emit(RegFailure(e.message ?? 'Registration failed'));
    } catch (_) {
      emit(const RegFailure('Registration failed'));
    }
  }
}

class _RegistrationException implements Exception {
  final String message;

  const _RegistrationException._(this.message);

  const _RegistrationException.alreadyRegistered()
      : this._('Already registered');

  const _RegistrationException.eventFull() : this._('Event full');

  const _RegistrationException.eventNotFound() : this._('Event not found');
}


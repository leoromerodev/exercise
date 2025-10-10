import 'package:flutter/material.dart';

// Muscle role enum and colors
enum MuscleRole { primary, secondary, stabilizer, antagonist }

extension MuscleRoleExtension on MuscleRole {
  String get displayName {
    switch (this) {
      case MuscleRole.primary:
        return 'Primary';
      case MuscleRole.secondary:
        return 'Secondary';
      case MuscleRole.stabilizer:
        return 'Stabilizer';
      case MuscleRole.antagonist:
        return 'Antagonist';
    }
  }

  Color get color {
    switch (this) {
      case MuscleRole.primary:
        return const Color(0xFFF6000F);
      case MuscleRole.secondary:
        return const Color(0xFFE75340);
      case MuscleRole.stabilizer:
        return const Color(0xFFD1776B);
      case MuscleRole.antagonist:
        return const Color(0xFFB29497);
    }
  }
}

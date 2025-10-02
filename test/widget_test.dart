// Basic unit tests for Heavek Mobile
//
// These tests verify basic functionality without UI components

import 'package:flutter_test/flutter_test.dart';
import 'package:heavek/utils/functions.dart';

void main() {
  group('Utility Functions Tests', () {
    test('toBase64 function works correctly with valid input', () {
      const testString = 'test123';
      final result = toBase64(testString);
      
      expect(result, isNotEmpty);
      expect(result, isA<String>());
      // Expected base64 encoding of 'test123'
      expect(result, equals('dGVzdDEyMw=='));
    });
    
    test('toBase64 handles empty string', () {
      const testString = '';
      final result = toBase64(testString);
      
      expect(result, isEmpty);
    });
    
    test('toBase64 handles special characters', () {
      const testString = 'Hello World!@#';
      final result = toBase64(testString);
      
      expect(result, isNotEmpty);
      expect(result, equals('SGVsbG8gV29ybGQhQCM='));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/muscle_roles.dart';
import 'package:xml/xml.dart';
import 'package:path_drawing/path_drawing.dart';

class MuscleModel {
  final String id;
  final String path;
  MuscleModel({required this.id, required this.path});
}

class VisualMuscleSelector extends StatefulWidget {
  final Set<String> selectedMuscles;
  final Map<String, MuscleRole> muscleRoles;
  final Function(String)? onMuscleSelected;

  const VisualMuscleSelector({
    Key? key,
    required this.selectedMuscles,
    this.muscleRoles = const {},
    this.onMuscleSelected,
  }) : super(key: key);

  @override
  State<VisualMuscleSelector> createState() => _VisualMuscleSelectorState();
}

class _VisualMuscleSelectorState extends State<VisualMuscleSelector> {
  List<MuscleModel> muscles = [];
  static const double _svgScale = 0.20;
  static const double _svgCenterX = 30.1;
  static const double _svgCenterY = -10.0;

  @override
  void initState() {
    super.initState();
    _loadMuscles();
  }

  Future<void> _loadMuscles() async {
    try {
      final svgContent = await rootBundle.loadString(
        'assets/images/body-siluettes.svg',
      );
      final document = XmlDocument.parse(svgContent);
      final paths = document.findAllElements('path');

      muscles = paths
          .where((element) => element.getAttribute('id')?.isNotEmpty == true)
          .where((element) => element.getAttribute('id') != 'Outline')
          .map(
            (element) => MuscleModel(
              id: element.getAttribute('id')!,
              path: element.getAttribute('d') ?? '',
            ),
          )
          .toList();

      if (mounted) setState(() {});
    } catch (e) {
      print('Error loading muscles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color:
            kVisualMuscleSelectorContainer, // Use your desired background color here
        border: Border.all(color: kVisualMuscleSelectorContainer),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: muscles.isEmpty
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : CustomPaint(
                painter: MuscleDiagramPainter(
                  muscles: muscles,
                  selectedMuscles: widget.selectedMuscles,
                  muscleRoles: widget.muscleRoles,
                  scale: _svgScale,
                  centerX: _svgCenterX,
                  centerY: _svgCenterY,
                ),
                child: GestureDetector(
                  onTapDown: (details) => _handleTap(details.localPosition),
                ),
              ),
      ),
    );
  }

  void _handleTap(Offset position) {
    // Find which muscle was tapped (simplified hit testing)
    for (final muscle in muscles) {
      try {
        final path = parseSvgPathData(muscle.path);
        final matrix = Matrix4.identity();
        matrix.translate(_svgCenterX, _svgCenterY);
        matrix.scale(_svgScale, _svgScale);

        final transformedPath = path.transform(matrix.storage);
        if (transformedPath.contains(position)) {
          widget.onMuscleSelected?.call(muscle.id);
          break;
        }
      } catch (e) {
        // Skip invalid paths
        continue;
      }
    }
  }
}

class MuscleDiagramPainter extends CustomPainter {
  final List<MuscleModel> muscles;
  final Set<String> selectedMuscles;
  final Map<String, MuscleRole> muscleRoles;
  final double scale;
  final double centerX;
  final double centerY;

  static const Color _defaultColor = Color(0xFFD7D3D2);

  const MuscleDiagramPainter({
    required this.muscles,
    required this.selectedMuscles,
    this.muscleRoles = const {},
    required this.scale,
    required this.centerX,
    required this.centerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final muscle in muscles) {
      _paintMuscle(canvas, muscle);
    }
  }

  void _paintMuscle(Canvas canvas, MuscleModel muscle) {
    try {
      final path = parseSvgPathData(muscle.path);
      final matrix = Matrix4.identity();
      matrix.translate(centerX, centerY);
      matrix.scale(scale, scale);

      final transformedPath = path.transform(matrix.storage);

      // Fill - use role color if muscle is selected and has a role
      Color fillColor = _defaultColor;
      if (selectedMuscles.contains(muscle.id)) {
        final role = muscleRoles[muscle.id];
        if (role != null) {
          fillColor = role.color;
        } else {
          fillColor =
              MuscleRole.primary.color; // Default to primary if no role set
        }
      }

      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = fillColor;

      canvas.drawPath(transformedPath, fillPaint);

      // Stroke
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = kPrimaryColor;

      canvas.drawPath(transformedPath, strokePaint);
    } catch (e) {
      // Skip invalid paths silently
    }
  }

  @override
  bool shouldRepaint(covariant MuscleDiagramPainter oldDelegate) {
    return oldDelegate.selectedMuscles != selectedMuscles ||
        oldDelegate.muscleRoles != muscleRoles;
  }
}

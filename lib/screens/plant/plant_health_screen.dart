import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_theme.dart';
import '../../services/plant_health_service.dart';

class PlantHealthScreen extends StatefulWidget {
  const PlantHealthScreen({Key? key}) : super(key: key);

  @override
  State<PlantHealthScreen> createState() => _PlantHealthScreenState();
}

class _PlantHealthScreenState extends State<PlantHealthScreen> with SingleTickerProviderStateMixin {
  File? _image;
  bool _isLoading = false;
  HealthDiagnosis? _diagnosis;
  String? _errorMessage;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _diagnosis = null;
          _errorMessage = null;
        });
        await _diagnosePlant();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się pobrać zdjęcia: $e';
      });
    }
  }

  Future<void> _diagnosePlant() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final diagnosis = await PlantHealthService.diagnose(_image!);
      setState(() {
        _diagnosis = diagnosis;
        _isLoading = false;
      });
      _animationController.forward(from: 0.0);
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się zdiagnozować rośliny: $e';
        _isLoading = false;
      });
    }
  }

  void _reset() {
    setState(() {
      _image = null;
      _diagnosis = null;
      _errorMessage = null;
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      appBar: AppBar(
        title: const Text('Diagnoza Zdrowia Rośliny'),
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryGreen.withOpacity(0.1),
              AppTheme.backgroundGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Zrób zdjęcie rośliny, aby sprawdzić jej stan zdrowia',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textDark.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Image preview or placeholder
                  _buildImagePreview(),

                  const SizedBox(height: 24),

                  // Camera and Gallery buttons
                  if (_image == null && !_isLoading) ...[
                    _buildActionButton(
                      icon: Icons.camera_alt,
                      label: 'Zrób zdjęcie 📷',
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.photo_library,
                      label: 'Wybierz z galerii 🖼️',
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ],

                  // Loading indicator
                  if (_isLoading) ...[
                    const SizedBox(height: 24),
                    _buildLoadingIndicator(),
                  ],

                  // Diagnosis result
                  if (_diagnosis != null && !_isLoading) ...[
                    const SizedBox(height: 24),
                    _buildDiagnosisCard(),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      icon: Icons.refresh,
                      label: 'Sprawdź inną roślinę',
                      onPressed: _reset,
                      color: AppTheme.lightGreen,
                    ),
                  ],

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 24),
                    _buildErrorCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _image != null
            ? Image.file(
                _image!,
                fit: BoxFit.cover,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 64,
                      color: AppTheme.lightGreen.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Zrób zdjęcie rośliny\nlub wybierz z galerii',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textDark.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppTheme.primaryGreen,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          ),
          const SizedBox(height: 16),
          Text(
            'Analizuję stan zdrowia rośliny...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textDark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisCard() {
    final isHealthy = _diagnosis!.issue == HealthIssue.healthy;
    final color = isHealthy ? Colors.green : Colors.orange;

    return FadeTransition(
      opacity: _animationController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        )),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      PlantHealthService.getHealthEmoji(_diagnosis!.issue),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _diagnosis!.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Pewność: ${(_diagnosis!.confidence * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Description
              Text(
                _diagnosis!.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textDark.withOpacity(0.7),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              const Divider(),

              const SizedBox(height: 16),

              // Recommendations
              Row(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Zalecenia',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ..._diagnosis!.recommendations.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textDark.withOpacity(0.8),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _reset,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }
}

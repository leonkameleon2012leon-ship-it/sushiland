import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_theme.dart';
import '../../services/plant_health_service.dart';
import '../onboarding/plant_selection_screen.dart';

/// Screen for checking plant health using leaf images
class PlantHealthCheckScreen extends StatefulWidget {
  final Plant plant;
  
  const PlantHealthCheckScreen({
    Key? key,
    required this.plant,
  }) : super(key: key);

  @override
  State<PlantHealthCheckScreen> createState() => _PlantHealthCheckScreenState();
}

class _PlantHealthCheckScreenState extends State<PlantHealthCheckScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  
  File? _imageFile;
  HealthDiagnosis? _diagnosis;
  bool _isAnalyzing = false;
  String? _errorMessage;
  
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _errorMessage = null;
        _diagnosis = null;
      });
      
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
        
        // Automatically start analysis
        await _analyzeHealth();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Błąd podczas wybierania zdjęcia';
      });
    }
  }
  
  Future<void> _analyzeHealth() async {
    if (_imageFile == null) return;
    
    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      _diagnosis = null;
    });
    
    try {
      // Analyze plant health (uses demo for now)
      final diagnosis = await PlantHealthService.getDemoDiagnosis();
      
      setState(() {
        _diagnosis = diagnosis;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się przeanalizować zdjęcia';
        _isAnalyzing = false;
      });
    }
  }
  
  void _checkAgain() {
    setState(() {
      _imageFile = null;
      _diagnosis = null;
      _errorMessage = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundGreen,
              AppTheme.lightGreen.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _animationController,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sprawdź zdrowie',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 24,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.plant.emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.plant.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  Text(
                                    'Analiza zdrowia',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textDark.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      if (_imageFile == null) ...[
                        _buildEmptyState(),
                      ] else ...[
                        _buildImagePreview(),
                        const SizedBox(height: 24),
                        
                        if (_isAnalyzing) ...[
                          _buildAnalyzingIndicator(),
                        ] else if (_errorMessage != null) ...[
                          _buildErrorMessage(),
                        ] else if (_diagnosis != null) ...[
                          _buildDiagnosisResult(),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        const Icon(
          Icons.medical_services,
          size: 80,
          color: AppTheme.lightGreen,
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Zrób zdjęcie liści',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'Sfotografuj liście rośliny, aby przeanalizować\njeśli jest zdrowa',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textDark.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Camera button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.camera_alt, size: 24),
            label: const Text(
              'Otwórz aparat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Gallery button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(
                color: AppTheme.primaryGreen,
                width: 2,
              ),
            ),
            icon: const Icon(Icons.photo_library, size: 24),
            label: const Text(
              'Wybierz z galerii',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.file(
        _imageFile!,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
  
  Widget _buildAnalyzingIndicator() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          ),
          const SizedBox(height: 24),
          Text(
            'Analizuję zdrowie rośliny...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textDark.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorMessage() {
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
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _checkAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiagnosisResult() {
    Color statusColor;
    switch (_diagnosis!.status) {
      case HealthStatus.healthy:
        statusColor = Colors.green;
        break;
      case HealthStatus.warning:
        statusColor = Colors.orange;
        break;
      case HealthStatus.critical:
        statusColor = Colors.red;
        break;
    }
    
    return Column(
      children: [
        // Status card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _diagnosis!.statusEmoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _diagnosis!.statusText,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _diagnosis!.diagnosis,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textDark.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              
              // Symptoms
              Text(
                'Objawy:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              ..._diagnosis!.symptoms.map((symptom) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: AppTheme.lightGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        symptom,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textDark.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              
              // Recommendations
              Text(
                'Rekomendacje:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              ..._diagnosis!.recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 20, color: AppTheme.primaryGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textDark.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Action button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _checkAgain,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.camera_alt),
            label: const Text(
              'Sprawdź ponownie',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

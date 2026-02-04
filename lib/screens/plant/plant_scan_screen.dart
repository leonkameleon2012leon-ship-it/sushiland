import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_theme.dart';
import '../../services/plant_recognition_service.dart';

class PlantScanScreen extends StatefulWidget {
  const PlantScanScreen({Key? key}) : super(key: key);

  @override
  State<PlantScanScreen> createState() => _PlantScanScreenState();
}

class _PlantScanScreenState extends State<PlantScanScreen> with SingleTickerProviderStateMixin {
  File? _image;
  bool _isLoading = false;
  PlantIdentification? _result;
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
          _result = null;
          _errorMessage = null;
        });
        await _identifyPlant();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się pobrać zdjęcia: $e';
      });
    }
  }

  Future<void> _identifyPlant() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await PlantRecognitionService.identifyPlant(_image!);
      setState(() {
        _result = result;
        _isLoading = false;
      });
      _animationController.forward(from: 0.0);
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się rozpoznać rośliny: $e';
        _isLoading = false;
      });
    }
  }

  void _reset() {
    setState(() {
      _image = null;
      _result = null;
      _errorMessage = null;
    });
    _animationController.reset();
  }

  void _addPlant() {
    if (_result != null) {
      Navigator.of(context).pop(_result!.plantName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      appBar: AppBar(
        title: const Text('Skanuj Roślinę'),
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
                  // Image preview or placeholder
                  _buildImagePreview(),

                  const SizedBox(height: 24),

                  // Camera and Gallery buttons
                  if (_image == null && !_isLoading) ...[
                    _buildActionButton(
                      icon: Icons.camera_alt,
                      label: 'Aparat 📷',
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.photo_library,
                      label: 'Galeria 🖼️',
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ],

                  // Loading indicator
                  if (_isLoading) ...[
                    const SizedBox(height: 24),
                    _buildLoadingIndicator(),
                  ],

                  // Result display
                  if (_result != null && !_isLoading) ...[
                    const SizedBox(height: 24),
                    _buildResultCard(),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      icon: Icons.add_circle,
                      label: 'Dodaj tę roślinę',
                      onPressed: _addPlant,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.refresh,
                      label: 'Skanuj ponownie',
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
                      Icons.photo_camera,
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
            'Rozpoznaję roślinę...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textDark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
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
                color: AppTheme.primaryGreen.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Roślina rozpoznana!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _result!.plantName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _result!.scientificName,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppTheme.textDark.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      size: 18,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pewność: ${(_result!.confidence * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Opis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _result!.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textDark.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
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

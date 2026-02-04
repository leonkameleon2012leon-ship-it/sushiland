import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_theme.dart';
import '../../services/plant_recognition_service.dart';
import '../onboarding/plant_selection_screen.dart';
import '../onboarding/plant_details_screen.dart';

/// Screen for scanning and identifying plants using camera or gallery
class PlantScanScreen extends StatefulWidget {
  const PlantScanScreen({Key? key}) : super(key: key);

  @override
  State<PlantScanScreen> createState() => _PlantScanScreenState();
}

class _PlantScanScreenState extends State<PlantScanScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  
  File? _imageFile;
  PlantIdentification? _identification;
  bool _isLoading = false;
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
        _identification = null;
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
        
        // Automatically start identification
        await _identifyPlant();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Błąd podczas wybierania zdjęcia: $e';
      });
    }
  }
  
  Future<void> _identifyPlant() async {
    if (_imageFile == null) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _identification = null;
    });
    
    try {
      // Validate image
      final isValid = await PlantRecognitionService.validateImage(_imageFile!);
      if (!isValid) {
        throw Exception('Nieprawidłowe zdjęcie. Spróbuj innego.');
      }
      
      // Identify plant
      final identification = await PlantRecognitionService.identifyPlant(_imageFile!);
      
      setState(() {
        _identification = identification;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się rozpoznać rośliny. Spróbuj ponownie.';
        _isLoading = false;
      });
    }
  }
  
  void _addPlant() {
    if (_identification == null) return;
    
    // Try to find matching plant from our predefined list
    Plant? matchingPlant;
    final polishName = _identification!.polishName;
    
    for (final plant in availablePlants) {
      if (plant.name.toLowerCase().contains(polishName.toLowerCase()) ||
          polishName.toLowerCase().contains(plant.name.toLowerCase())) {
        matchingPlant = plant;
        break;
      }
    }
    
    // If no match, use first plant as template (Monstera)
    matchingPlant ??= availablePlants.first;
    
    // Navigate to details screen
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsScreen(
          selectedPlant: matchingPlant!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    ).then((result) {
      // If plant was added, return it
      if (result != null) {
        Navigator.of(context).pop(result);
      }
    });
  }
  
  void _scanAgain() {
    setState(() {
      _imageFile = null;
      _identification = null;
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
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Skanuj roślinę',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 24,
                            color: AppTheme.textDark,
                          ),
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
                        // No image selected - show options
                        _buildEmptyState(),
                      ] else ...[
                        // Image selected - show preview and results
                        _buildImagePreview(),
                        const SizedBox(height: 24),
                        
                        if (_isLoading) ...[
                          _buildLoadingIndicator(),
                        ] else if (_errorMessage != null) ...[
                          _buildErrorMessage(),
                        ] else if (_identification != null) ...[
                          _buildIdentificationResult(),
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
        const SizedBox(height: 40),
        
        const Icon(
          Icons.camera_alt,
          size: 80,
          color: AppTheme.lightGreen,
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Zrób zdjęcie rośliny',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'Użyj aparatu lub wybierz zdjęcie z galerii,\naby rozpoznać roślinę',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textDark.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
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
  
  Widget _buildLoadingIndicator() {
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
            'Rozpoznawanie rośliny...',
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
            onPressed: _scanAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIdentificationResult() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.primaryGreen,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Roślina rozpoznana!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              Text(
                _identification!.polishName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                _identification!.scientificName,
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
                child: Text(
                  'Pewność: ${_identification!.confidencePercent}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                _identification!.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textDark.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Action buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _scanAgain,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(
                    color: AppTheme.primaryGreen,
                    width: 2,
                  ),
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text(
                  'Skanuj ponownie',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addPlant,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'Dodaj roślinę',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

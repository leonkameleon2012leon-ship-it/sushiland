enum DifficultyLevel { latwy, sredni, trudny }

enum LightRequirement { pelneSlonce, polcien, cien }

enum PlantType { doniczkowa, wiszaca, sukulentowa, kwitnaca }

class Plant {
  final String name;
  final String emoji;
  final String description;
  final int wateringDays;
  final int age; // w latach
  final int height; // w cm
  final DifficultyLevel difficulty;
  final LightRequirement lightRequirement;
  final PlantType plantType;
  final bool toxicToAnimals;
  final String? notes;
  
  const Plant({
    required this.name,
    required this.emoji,
    required this.description,
    required this.wateringDays,
    this.age = 1,
    this.height = 30,
    this.difficulty = DifficultyLevel.latwy,
    this.lightRequirement = LightRequirement.polcien,
    this.plantType = PlantType.doniczkowa,
    this.toxicToAnimals = false,
    this.notes,
  });
  
  Plant copyWith({
    String? name,
    String? emoji,
    String? description,
    int? wateringDays,
    int? age,
    int? height,
    DifficultyLevel? difficulty,
    LightRequirement? lightRequirement,
    PlantType? plantType,
    bool? toxicToAnimals,
    String? notes,
  }) {
    return Plant(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      wateringDays: wateringDays ?? this.wateringDays,
      age: age ?? this.age,
      height: height ?? this.height,
      difficulty: difficulty ?? this.difficulty,
      lightRequirement: lightRequirement ?? this.lightRequirement,
      plantType: plantType ?? this.plantType,
      toxicToAnimals: toxicToAnimals ?? this.toxicToAnimals,
      notes: notes ?? this.notes,
    );
  }
}

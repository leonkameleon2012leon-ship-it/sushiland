import 'package:flutter/foundation.dart';

enum GameState { menu, playing, paused, gameOver, upgrade }

enum PlayerState { idle, walking, preparing, serving, interacting }

enum CustomerState { entering, waiting, eating, leaving, angry }

enum CustomerMood { happy, neutral, annoyed, angry, furious }

enum StationType { storage, preparation, counter, dishwashing, decoration }

enum IngredientType { rice, salmon, tuna, shrimp, nori, cucumber, avocado, wasabi, ginger, soySauce }

enum SushiType { maki, nigiri, sashimi, californiaRoll, dragonRoll, rainbowRoll, specialRoll }

enum SushiQuality { poor, normal, good, excellent }

enum UpgradeCategory { player, restaurant, menu, automation }

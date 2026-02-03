# 🍣 Sushiland - Flame Engine Implementation

## Overview
This document describes the Flame engine implementation for Sushiland, a restaurant management game built with Flutter and the Flame game engine.

## Architecture

### Core Components

#### 1. **SushilandGame** (`lib/game/sushiland_game.dart`)
Main FlameGame class that manages:
- Game world and camera system
- Component lifecycle
- Collision detection
- Particle effect spawning
- Customer synchronization

**Key Features:**
- 800x600 world bounds
- Camera with smooth following (lerp factor: 0.1)
- Zoom level: 1.5x
- Automatic customer component management

#### 2. **GameWorld** (`lib/game/world/game_world.dart`)
World component that contains:
- Floor tiles (64x64 alternating brown/tan pattern)
- Entrance door at (400, 50)
- All game entities (players, customers, stations, tables)

#### 3. **PlayerComponent** (`lib/game/components/player_component.dart`)
Handles player character with:
- Smooth 8-directional movement
- Collision detection with furniture
- Visual inventory display
- Held item display
- Speed: 100 pixels/second
- Interaction with nearby stations

**Collision Detection:**
- Circle-based player collision (20px radius)
- Prevents walking through work stations (40px threshold)
- Prevents walking through tables (45px threshold)
- World boundary constraints (20-780 x, 20-580 y)

#### 4. **CustomerComponent** (`lib/game/components/customer_component.dart`)
AI-controlled customer with:
- A* pathfinding to assigned tables
- Patience bar display (60 seconds max)
- Mood emoji system (😊 😐 😠 😡 💢)
- Speech bubble showing order
- Ghost collision (doesn't block other entities)
- Speed: 50 pixels/second

**Mood States:**
- Happy: > 70% patience
- Neutral: 30-70% patience
- Annoyed/Angry: < 30% patience
- Furious: 0% patience (leaving)

#### 5. **WorkStationComponent** (`lib/game/components/workstation_component.dart`)
Interactive stations with:
- Visual highlighting when player is nearby (< 80px)
- "Press A" prompt display
- Different icons for each type:
  - 📦 Storage
  - 🔪 Preparation
  - 💰 Counter
- Collision boundaries (60x60)

#### 6. **TableComponent** (`lib/game/components/table_component.dart`)
Restaurant tables with:
- Visual states (green = available, red = occupied)
- Table number display
- Circle collision (50px diameter)

#### 7. **FoodComponent** (`lib/game/components/food_component.dart`)
Visual food items with:
- Floating animation effect
- Quality stars (⭐ based on quality)
- Different emojis per sushi type
- 30x30 size

### World Systems

#### Pathfinding (`lib/game/world/pathfinding.dart`)
A* pathfinding implementation:
- Grid-based (32x32 tiles)
- 4-directional movement
- Obstacle avoidance
- Manhattan distance heuristic

#### Collision Detection (`lib/game/world/collision_detection.dart`)
Utilities for:
- Circle-circle collision
- Circle-rectangle collision
- Rectangle-rectangle collision
- Point-in-shape tests
- Collision resolution

### Particle Effects (`lib/game/components/particle_effects.dart`)

#### SparkleEffect
- Triggered when collecting items
- 7 yellow particles
- 1 second lifetime
- Radiates outward

#### StarBurstEffect
- Triggered when completing a dish
- 8 stars radiating in all directions
- 1.2 second lifetime
- Yellow color

#### MoneyFloatEffect
- Shows money earned (+$XX)
- Floats upward
- 2 second lifetime
- Fades out

#### HeartEffect
- Shows customer happiness
- 3 pink hearts
- Floats upward
- 1.5 second lifetime

### UI Components

#### GameHUD (`lib/widgets/ui/hud.dart`)
Displays:
- Money 💰
- Reputation ⭐
- Current customers / max customers 👥
- Game time ⏱️

#### GameToast (`lib/widgets/game_overlay.dart`)
Toast notifications for events:
- "New Customer Arrived! 👤"
- "Order Complete! ✨"
- Slide-in animation from top
- Auto-dismiss after 2 seconds

#### VirtualJoystick (`lib/widgets/controls/virtual_joystick.dart`)
Touch-based movement control:
- 120x120 circular boundary
- 50px max drag distance
- Returns normalized Vector2 direction

#### ActionButtons (`lib/widgets/controls/action_buttons.dart`)
- "A" button for interactions (green)
- "Menu" button for pause menu (blue)

## Game World Layout

```
┌─────────────────────────────────────┐
│  🚪 Entrance (400, 50)              │
│                                     │
│  📦 Storage     🔪 Prep Station     │
│  (100, 150)    (300, 150)          │
│                                     │
│     [Table 1]        [Table 2]      │
│     (200, 250)      (500, 250)     │
│                                     │
│     [Table 3]        [Table 4]      │
│     (200, 400)      (500, 400)     │
│                                     │
│  💰 Counter                          │
│  (100, 500)                         │
│                                     │
└─────────────────────────────────────┘

Player starts at: (400, 300) - center
Customers spawn at: (400, 50) - entrance
World size: 800x600 pixels
```

## Gameplay Flow

### 1. Game Start
- Camera fades in to player at center
- Player can move with joystick
- First customer spawns after 5 seconds

### 2. Customer Lifecycle
1. **Spawn** at entrance (400, 50)
2. **Pathfind** to available table
3. **Wait** at table (patience decreasing)
4. **Display order** in speech bubble
5. **Served** → eating animation → leave
6. **Timeout** → angry → leave immediately

### 3. Player Actions

#### At Storage (📦):
- Press A → collect 4 ingredients
- Sparkle effect ✨
- Inventory updates

#### At Preparation (🔪):
- Press A → start preparing
- 3-second timer
- Consumes ingredients
- Creates sushi
- Star burst effect when complete

#### At Counter (💰):
- Press A → serve customer
- Money float effect (+$50)
- Heart effect if customer happy
- Experience gained
- Customer eats and leaves

### 4. Visual Feedback
- ✨ Sparkles when collecting
- ⭐ Star burst when preparing
- 💰 Money floats up when serving
- 💗 Hearts when customer happy
- 💢 Anger puffs when frustrated
- Toast notifications for events

## Integration with Existing Code

### Controllers (Preserved)
- **GameController**: Main game logic and state
- **CustomerController**: Customer spawning and management
- **ResourceController**: Resource tracking

### Models (Preserved)
- **Player**: Position, inventory, speed, level
- **Customer**: State, patience, mood, order
- **Restaurant**: Money, reputation, stations, tables
- **WorkStation**: Type, position, state
- **RestaurantTable**: ID, position, occupancy
- **Sushi**: Type, quality, value
- **Ingredient**: Type, quantity

### State Management
- Uses **Provider** for reactive state updates
- GameController notifies listeners on state changes
- UI components consume state via Consumer widgets

## Performance Considerations

### Target: 60 FPS

#### Optimizations:
1. **Component Pooling**: Reuse particle components
2. **Culling**: Only render visible entities (handled by Flame)
3. **Collision**: Use spatial partitioning for large entity counts
4. **Updates**: Delta-time based for frame-rate independence

#### Current Performance:
- Floor tiles: One-time render, cached by Flame
- Particles: Short-lived, auto-removed
- Pathfinding: Calculated once per target change
- Collision: O(n) check, acceptable for ~10 entities

## Future Enhancements

### Phase 4 (Nice to Have):
- [ ] Screen shake on significant events
- [ ] More animation variety (idle, preparing)
- [ ] Advanced particle systems (trails, explosions)
- [ ] Sound effects (using flame_audio)
- [ ] Background music
- [ ] Mini-map in corner
- [ ] Day/night cycle
- [ ] Weather effects

### Technical Debt:
- [ ] Replace programmatic sprites with sprite sheets
- [ ] Add sprite animation state machine
- [ ] Optimize pathfinding with goal-oriented behavior
- [ ] Add spatial hash for collision detection
- [ ] Implement object pooling for particles

## Development Notes

### Testing
- Test on both web and mobile
- Verify touch controls on mobile devices
- Check performance on lower-end devices
- Validate collision boundaries

### Asset Pipeline
Current: Programmatic rendering with emojis
Future: Replace with proper sprite sheets
- Player: 40x40 sprites, 4-direction walk cycle
- Customers: 35x35 sprites, walk animations
- Stations: 60x60 sprites with hover effects
- Food: 30x30 sprite atlas

### Code Organization
```
lib/
├── game/
│   ├── sushiland_game.dart        # Main game
│   ├── components/                 # Game entities
│   ├── world/                      # World systems
│   └── sprites/                    # Sprite loading (future)
├── controllers/                    # Game logic
├── models/                         # Data models
├── screens/                        # UI screens
└── widgets/                        # UI components
```

## Conclusion

The Flame engine implementation provides a solid foundation for the Sushiland game with:
- Professional game architecture
- Smooth animations and effects
- Responsive controls
- Scalable component system
- Easy to extend and maintain

The game is ready for playtesting and asset replacement with final artwork!

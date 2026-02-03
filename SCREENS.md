# Screen Flow Documentation

## 1. Welcome Screen (WelcomeScreen)

### Visual Elements
- **Background**: Light green gradient from top to bottom
- **Animated Elements**: Three overlapping icons (eco icons) that sway gently
  - Large semi-transparent green leaf in background
  - Dark green leaf with different animation timing
  - Central spa icon in solid green
- **Text**: 
  - "Zadbaj o swoje" in medium size
  - "rośliny 🌱" in large, bold green text
  - Subtitle: "Twoje rośliny to żywe istoty, które potrzebują Twojej uwagi"
- **Button**: Large rounded green button with "Zaczynamy" text

### Animations
- Fade-in animation on screen load (800ms)
- Continuous swaying animation using sine wave (3 seconds per cycle)
- Smooth fade + slide transition to next screen (600ms)

### Navigation
- Tapping "Zaczynamy" → Name Screen

---

## 2. Name Input Screen (NameScreen)

### Visual Elements
- **Background**: Light green gradient (reversed from welcome)
- **Icon**: Large flower icon (local_florist) in green
- **Text**:
  - Main question: "Jak masz na imię?"
  - Subtitle: "Chcemy wiedzieć, jak się do Ciebie zwracać 😊"
- **Input Field**: 
  - White rounded text field
  - Centered text
  - Green person icon on left
  - Placeholder: "Wpisz swoje imię"
- **Button**: "Dalej" button (disabled when empty, enabled when text entered)

### Animations
- Slide from bottom (30% offset) on entry (600ms)
- Fade-in simultaneously
- Button scales and changes opacity when enabled/disabled (300ms)
- Auto-advance transition on submission

### Functionality
- Saves name to SharedPreferences
- Validates input (requires non-empty text)
- Supports Enter key to submit

### Navigation
- After entering name → Permissions Screen

---

## 3. Permissions Screen (PermissionsScreen)

### Visual Elements
- **Background**: Light green gradient
- **Icon**: Large checkmark circle in green
- **Title**: "Uprawnienia"
- **Subtitle**: "Aby lepiej zadbać o Twoje rośliny, potrzebujemy kilku uprawnień"

### Permission Cards (2)
Each card shows:
- Icon in colored circle background
- Title and description
- Status (checkmark if granted) or "Zezwól" button

**Card 1 - Location**
- Icon: location_on
- Title: "Lokalizacja"
- Description: "Dzięki temu wiemy, kiedy roślinka marznie 🪴"

**Card 2 - Notifications**
- Icon: notifications
- Title: "Powiadomienia"
- Description: "Przypomnimy Ci o podlewaniu 💧"

### Animations
- Slide + fade on entry (600ms)
- Cards change background color when permission granted
- Smooth elevation changes

### Navigation
- "Dalej" button → Plant Selection Screen

---

## 4. Plant Selection Screen (PlantSelectionScreen)

### Visual Elements
- **Background**: Light green gradient
- **Header**:
  - Title: "Wybierz swoje rośliny"
  - Subtitle: "Wybierz rośliny, o które chcesz dbać"
  - Search bar with magnifying glass icon
- **Plant Cards**: Scrollable list of 8 plants
  - Each card shows: emoji, name, description, watering frequency
  - Selected cards have green border and checkmark
- **Counter**: "Wybrano: X roślin" (shown when plants selected)
- **Button**: "Dalej" (enabled only when at least one plant selected)

### Available Plants
1. Monstera 🌿 - Łatwa w pielęgnacji (7 dni)
2. Aloes 🪴 - Nie wymaga dużo wody (14 dni)
3. Paproć 🌱 - Lubi wilgotne środowisko (5 dni)
4. Kaktus 🌵 - Bardzo wytrzymały (21 dni)
5. Storczyk 🌺 - Piękne kwiaty (10 dni)
6. Filodendron 🍃 - Duże zielone liście (7 dni)
7. Sansewieria 🌿 - Bardzo odporna (14 dni)
8. Pothos 🌱 - Oczyszcza powietrze (7 dni)

### Animations
- Staggered entrance (each card 300ms + 50ms delay)
- Cards slide up and fade in
- Scale animation on selection (300ms)
- Border color change on selection
- Checkmark appears/disappears with scale animation

### Functionality
- Multi-select capability
- Live search filtering
- Selection state management

### Navigation
- "Dalej" button → Dashboard Screen (with selected plants)

---

## 5. Dashboard Screen (DashboardScreen)

### Visual Elements
- **Background**: Light green gradient from top
- **Header**:
  - Spa icon + "Twoje Rośliny" title
  - Personalized greeting: "[Time-based greeting], [Name]! 🌱"
    - Morning: "Dzień dobry"
    - Afternoon: "Witaj"
    - Evening: "Dobry wieczór"

### Plant Cards
Each card displays:
- **Large emoji icon** in colored rounded container
- **Plant name** (bold, large)
- **Description** (small, gray)
- **Status container** with icon and message:
  - Needs water: "Twoja [plant] chce się napić 💧" (green background)
  - OK: "Wszystko w porządku 😊"
  - Soon: "Jutro podlej swoją [plant] 🌱"
- **Timer**: "Podlewanie za X dni" (if not urgent)
- **Water button**: "Podlej teraz" (only shown when needs water)

### Empty State
When no plants:
- Large flower icon
- "Nie masz jeszcze roślin"
- Subtitle about adding first plant

### Bottom Actions
- Large "Dodaj roślinę" button with plus icon

### Animations
- Fade + slide on header (800ms)
- Staggered plant cards (400ms + 100ms delay each)
- Cards slide up and fade in

### Functionality
- Calculates days until watering based on last watered date
- Water button updates timestamp
- Shows snackbar confirmation on watering
- Empty state when no plants

### Navigation
- "Dodaj roślinę" → Plant Selection Screen (modal)

---

## Color Palette

- **Primary Green**: `#4CAF50`
- **Light Green**: `#81C784`
- **Dark Green**: `#2E7D32`
- **Background Green**: `#E8F5E9`
- **White**: `#FFFFFF`
- **Text Dark**: `#1B5E20`
- **Text Light**: `#66BB6A`

## Animation Curves

All animations use `Curves.easeInOut` for smooth, natural motion.

## Typography

- **Display Large**: 32px, bold
- **Display Medium**: 28px, bold
- **Title Large**: 24px, semi-bold
- **Body Large**: 16px
- **Body Medium**: 14px

## Button Style

- Rounded corners: 30px radius
- Padding: 32px horizontal, 16px vertical
- Minimum height: 56px
- Elevation: 4
- Full width on most screens

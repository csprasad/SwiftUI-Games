# Contributing to SwiftUI Games

Thank you for your interest in contributing! This guide will help you add new games and follow our development practices.

## 🎨 Adding New Games

Follow these steps to add a new game to the collection:

### Step 1: Add Game Route Case

Add a new case to the `GameRoute` enum in `GameRoute.swift`:

```swift
enum GameRoute: Hashable, Identifiable {
    case commitSnake
    case yourNewGame  // Add your game here
    
    var id: Self { self }
    // ...
}
```

### Step 2: Provide Game Metadata

Add your game's information in the `info` computed property:

```swift
var info: GameInfo {
    switch self {
    case .commitSnake:
        GameInfo(
            title: "Commit Snake",
            note: "GitHub graph & Trackball controls",
            icon: "point.topleft.down.curvedto.point.bottomright.up",
            isAvailable: true
        )
    case .yourNewGame:
        GameInfo(
            title: "Your Game Title",
            note: "Brief description of your game",
            icon: "gamecontroller",  // SF Symbol name
            isAvailable: true
        )
    }
}
```

**GameInfo Properties:**
- `title`: Display name of your game
- `note`: Short description (1-2 lines)
- `icon`: SF Symbol name for the icon
- `isAvailable`: Set to `true` when ready, `false` for "Coming Soon"

### Step 3: Implement Game View

Add your game's view in the `destinationView()` method:

```swift
@ViewBuilder
private func destinationView() -> some View {
    switch self {
    case .commitSnake:
        CommitSnakeGame()
    case .yourNewGame:
        YourGameView()  // Your game view
    }
}
```

### Step 4: Register in Home View

Add your game to the games array in `ArcadeHomeView.swift`:

```swift
struct ArcadeHomeView: View {
    let games: [GameRoute] = [
        .commitSnake,
        .yourNewGame  // Add here
    ]
    // ...
}
```

### Step 5: Create Your Game View

Create a new SwiftUI view file for your game:

```swift
import SwiftUI

struct YourGameView: View {
    var body: some View {
        VStack {
            Text("Your Game!")
            // Your game implementation
        }
    }
}

#Preview {
    YourGameView()
}
```

## 📝 Code Style Guidelines

### Swift Style

- **Naming**: Use clear, descriptive names
  ```swift
  // Good
  var playerScore: Int
  func calculateMovement()
  
  // Avoid
  var ps: Int
  func calc()
  ```

- **Spacing**: Use consistent spacing
  ```swift
  // Good
  if isGameOver {
      resetGame()
  }
  
  // Avoid
  if isGameOver{
    resetGame()
  }
  ```

- **SwiftUI Views**: Keep views small and composable
  ```swift
  // Good - Small, focused views
  struct GameHeader: View {
      var body: some View {
          Text("Game Title")
      }
  }
  
  struct GameView: View {
      var body: some View {
          VStack {
              GameHeader()
              GameBoard()
              GameControls()
          }
      }
  }
  ```

### SwiftUI Best Practices

1. **State Management**
   ```swift
   @State private var score = 0
   @StateObject private var gameEngine = GameEngine()
   ```

2. **View Modifiers**
   ```swift
   Text("Score: \(score)")
       .font(.headline)
       .foregroundStyle(.primary)
   ```

3. **Previews** (Optional)
   ```swift
   #Preview {
       YourGameView()
   }
   ```

4. **Extract Subviews**
   - If a view gets longer than ~100 lines, consider breaking it into smaller components
   - Use `@ViewBuilder` for conditional views

### Architecture Guidelines

- **Keep views small**: Aim for views under 100 lines
- **Separate concerns**: Game logic should be in separate files/classes
- **Use meaningful names**: View names should end with `View`
- **Follow SwiftUI patterns**: Use `@State`, `@Binding`, `@StateObject` appropriately

## 🎮 Game Requirements

Your game should:
- ✅ Work in portrait and landscape (if applicable)
- ✅ Handle safe area insets properly
- ✅ Include clear instructions or intuitive controls
- ✅ Have a reset/restart mechanism
- ✅ Be performance-optimized (60 FPS target)
- ✅ Include a preview for development

## 🐛 Bug Reports

When reporting bugs, please include:
- iOS version
- Device model
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots/videos if applicable

## 💡 Feature Requests

For new game ideas or features:
- Describe the game concept
- Explain the controls
- Mention any technical considerations
- Reference similar games if applicable

## 🔄 Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-game`)
3. Commit your changes (`git commit -m 'Add amazing game'`)
4. Push to the branch (`git push origin feature/amazing-game`)
5. Open a Pull Request

### PR Guidelines

- Clear title and description
- Reference any related issues
- Include screenshots/GIFs of new games
- Ensure code follows style guidelines
- Test on multiple devices if possible

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [SF Symbols Browser](https://developer.apple.com/sf-symbols/)

## ❓ Questions?

Feel free to open an issue for:
- Clarification on contribution process
- Technical questions
- Suggestions for improvement

---

Thank you for contributing to SwiftUI Games! 🎮

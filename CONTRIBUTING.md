# Contributing to SwiftUI Games 🎮

Thanks for your interest in contributing! This guide covers everything you need to add a new game or improve the project.

---

## 🕹️ Adding a New Game

The routing system is enum-driven — adding a game touches **3 files only**.

### Step 1 — Add a route case

In `GameRoute.swift`, add your case to the enum:

```swift
enum GameRoute: Hashable, Identifiable, CaseIterable {
    case commitSnake
    case yourNewGame  // 👈 add here
}
```

That's it for the home screen — `ArcadeHomeView` uses `.allCases` so your game appears automatically.

---

### Step 2 — Add game metadata

Fill in the `info` property for your case:

```swift
var info: GameInfo {
    switch self {
    case .yourNewGame:
        GameInfo(
            title: "Your Game",
            note: "One line description of the game.",
            icon: "gamecontroller",  // SF Symbol
            isAvailable: true        // false = shows as Coming Soon
        )
    }
}
```

---

### Step 3 — Wire up the destination

Add your view to `destinationView()`:

```swift
@ViewBuilder
private func destinationView() -> some View {
    switch self {
    case .yourNewGame:
        YourGameView()
    }
}
```

---

### Step 4 — Build your game

Create a folder under `Games/YourGame/` with two files:

```
Games/
└── YourGame/
    ├── YourGameEngine.swift   // all logic, physics, state
    └── YourGameView.swift     // SwiftUI view only
```

Follow the engine/view pattern every game uses:

```swift
// YourGameEngine.swift
@Observable @MainActor
final class YourGameEngine {
    var state: GameState = .idle

    func handleButtonTap() {
        switch state {
        case .idle, .gameOver: restart()
        case .playing: /* game action */
        }
    }

    func update() {
        guard state == .playing else { return }
        // physics, collision, scoring
    }

    private func restart() {
        state = .playing
    }
}
```

```swift
// YourGameView.swift
struct YourGameView: View {
    @State private var engine = YourGameEngine()

    var body: some View {
        ZStack { ... }
        .onTapGesture { engine.handleButtonTap() }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 16_000_000) // 60 FPS
                engine.update()
            }
        }
        .overlay(alignment: engine.state == .idle ? .bottom : .top) {
            if engine.state == .idle || engine.state == .gameOver {
                GameOverView(state: engine.state)
                    .padding(engine.state == .idle ? .bottom : .top, 60)
            }
        }
    }
}

#Preview {
    YourGameView()
}
```

---

## ✅ Game Checklist

Before submitting, make sure your game:

- Has a working `idle -> playing -> gameOver` state machine
- Runs at 60 FPS with no dropped frames
- Has a restart mechanism
- Uses `GameOverView` for idle and game over overlays
- Handles safe area insets properly
- Includes a `#Preview`

---

## 📝 Code Style

- **Engine vs View** — keep all logic in the engine, views are display only
- **Naming** — `GameEngine`, `GameView`, not abbreviations
- **State** — use `@Observable` on engines, `@State` in views
- **Views** — aim to keep views under 100 lines, extract subviews where needed
- **No timers** — use `Task` + `async/await` for game loops, not `Timer` or `Combine`

---

## 🐛 Reporting Bugs

Please include:
- iOS version + device model
- Steps to reproduce
- Expected vs actual behaviour
- Screenshot or screen recording if possible

---

## 🔄 Pull Request Process

1. Fork the repo
2. Create a branch — `git checkout -b game/your-game-name`
3. Commit — `git commit -m 'Add YourGame'`
4. Push — `git push origin game/your-game-name`
5. Open a PR with a GIF of the game in action

---

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

---

Thank you for contributing! 🕹️
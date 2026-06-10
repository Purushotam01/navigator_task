# Navigator Task

A high-performance Flutter mobile application built with the **MVVM (Model-View-ViewModel)** architecture pattern. The application features local user authentication, persistent session management, and an interactive map experience showing real-time animated car movement along a polyline with bearing orientation.

---

## 🚀 Key Features

*   **⚡ Splash Screen**: Handles immediate session verification (`Hive` + `SharedPreferences`) and navigates automatically based on login status.
*   **🔑 Local Authentication**:
    *   **Login Screen**: Clean, centered UI requiring email & password credentials validation.
    *   **Signup Screen**: Registers users locally with fields for Name, Email, Mobile, Password, Confirm Password, and a Profile Image selection.
    *   **White Border Styling**: Elegant UI design utilizing sleek white borders instead of solid white rectangle boxes.
*   **🗺️ Animated Map Navigation**:
    *   Powered by `flutter_map` (OpenStreetMap).
    *   Renders a polyline connecting a predefined start and end route.
    *   Animate a car marker smoothly along the route with precise rotational bearing calculation.
*   **💾 Local Session & Storage**:
    *   Auto-logs users into the app on subsequent launches if the session is still active.
    *   Locally stores credentials and profile settings using `Hive` and `SharedPreferences`.
*   **🎨 Centralized Design System**:
    *   **Colors**: Configured uniformly in `app_theme.dart`.
    *   **Typography**: Centralized `app_text_styles.dart` used across the application.
*   **📈 Optimized Performance**:
    *   Localized `Consumer` widgets reduce rebuild scopes on marker changes to guarantee 60+ FPS animations.
    *   No memory leaks; controllers and streams are cleaned up properly in `dispose` lifecycles.

---

## 📁 Project Structure

The project follows a clean **MVVM Layered Architecture**:

```text
lib/
├── core/
│   ├── constants/       # App-wide constant values
│   ├── theme/           # AppTheme and design colors
│   └── utils/           # Shared helper functions
├── data/
│   ├── models/          # Data schemas (User, Route coordinates)
│   └── services/        # Hive Database & SharedPreferences services
├── features/
│   ├── auth/            # Auth screens & ViewModels (Login/Signup)
│   └── home/            # Home map interface & animation ViewModel
└── main.dart            # Application entrypoint

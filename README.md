# Hotel Client iOS App 🏨

A modern iOS hotel booking application built with SwiftUI and Clean Architecture principles. This app provides a seamless experience for users to search available rooms, create reservations, manage bookings, and view their profile.

## ✨ Features

- **🔐 User Authentication**: Secure login and registration with JWT token management
- **🔑 Password Visibility Toggle**: Show/hide password functionality in all authentication forms
- **🏠 Room Search**: Search available rooms by date range and guest count
- **📅 Reservation Management**: Create, view, and delete hotel reservations
- **📋 Booking History**: View upcoming and past reservations separately
- **👤 User Profile**: View user profile information with guest details
- **🔄 Persistent Sessions**: Automatic token refresh and secure Keychain storage
- **🎨 Modern UI**: Clean, intuitive interface built entirely with SwiftUI
- **📱 Native iOS**: 100% native Swift implementation with no third-party dependencies

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| **Language** | Swift 5.0 |
| **UI Framework** | SwiftUI |
| **Concurrency** | Swift Async/Await |
| **Networking** | URLSession (custom BaseNetworkManager) |
| **State Management** | Combine (@Published properties) |
| **Storage** | Keychain (secure token management) |
| **Architecture** | Clean Architecture + MVVM |
| **Dependency Injection** | Manual DI via DependencyContainer |
| **Image Loading** | AsyncImage |
| **Platforms** | iOS 17.4+ |

## 🏗 Architecture

The app follows **Clean Architecture** principles combined with **MVVM** pattern, organized into three distinct layers:

```
┌─────────────────────────────────────┐
│     Presentation Layer (features/)   │
│   • Views (SwiftUI)                  │
│   • ViewModels (@Published)          │
│   • Navigation logic                 │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│     Domain Layer (domain/)           │
│   • Business entities (models/)      │
│   • Use cases (usecases/)            │
│   • Repository protocols             │
│   • Data source protocols            │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│     Data Layer (data/)               │
│   • API models (DTOs)                │
│   • Repository implementations       │
│   • Data source implementations      │
│   • Network calls                    │
└─────────────────────────────────────┘
```

### Layer Responsibilities

#### 1. Presentation Layer (`features/`)
- **SwiftUI Views**: Declarative UI components
- **ViewModels**: Business logic and state management with Combine
- **Navigation**: SwiftUI NavigationStack and sheet presentations
- **UI State**: Loading, error, and success states

#### 2. Domain Layer (`domain/`)
- **Models**: Pure business entities
  - `User`, `Profile`, `Customer`
  - `RoomHotel`, `Reservation`
- **Use Cases**: Single-responsibility business operations
  - `LoginUseCase`, `RegisterUserUseCase`
  - `GetRoomsAvailables`, `MakeReservationUseCase`
  - `GetReservationsUseCase`, `DeleteReservationUseCase`
  - `GetProfileUsecase`
- **Repository Protocols**: Abstract data access
- **Data Source Protocols**: Network/storage abstractions

#### 3. Data Layer (`data/`)
- **API Models (DTOs)**: Network response structures
- **Repository Implementations**: Data access logic
- **Data Source Implementations**: URLSession network calls
- **Mappers**: Convert DTOs to domain models

## 📁 Project Structure

```
Hotel/
├── HotelApp.swift                      # App entry point with auth routing
├── features/                           # Presentation Layer
│   ├── auth/                           # Authentication
│   │   ├── LoginView.swift
│   │   ├── LoginViewModel.swift
│   │   ├── RegisterView.swift
│   │   └── RegisterViewModel.swift
│   ├── home/                           # Main navigation (TabView)
│   │   └── MainHomeView.swift
│   ├── rooms/                          # Room browsing
│   │   ├── RoomsAvailablesView.swift
│   │   └── RoomsAvailableViewModel.swift
│   ├── reservations/                   # Reservation management
│   │   ├── ReservationView.swift
│   │   ├── ReservationViewModel.swift
│   │   ├── ConfirmationReservationView.swift
│   │   ├── ConfirmationReservationViewModel.swift
│   │   ├── MyReservationsView.swift
│   │   └── MyReservationsViewModel.swift
│   └── profile/                        # User profile
│       ├── ProfileView.swift
│       └── ProfileViewModel.swift
├── domain/                             # Business Logic Layer
│   ├── model/                          # Domain entities
│   │   ├── User.swift
│   │   ├── Profile.swift
│   │   ├── Customer.swift
│   │   ├── RoomHotel.swift
│   │   └── Reservation.swift
│   ├── usecases/                       # Business operations
│   │   ├── LoginUseCase.swift
│   │   ├── RegisterUserUseCase.swift
│   │   ├── GetRoomsAvailables.swift
│   │   ├── MakeReservationsUseCase.swift
│   │   ├── GetReservationsUseCase.swift
│   │   ├── DeleteReservationUseCase.swift
│   │   └── GetProfileUsecase.swift
│   ├── repository/                     # Repository protocols
│   │   ├── AuthRepository.swift
│   │   ├── RoomRepository.swift
│   │   ├── ReservationsRepository.swift
│   │   └── ProfileRepository.swift
│   └── datasource/                     # Data source protocols
│       ├── AuthRemoteDataSource.swift
│       ├── RoomRemoteSource.swift
│       ├── ReservationRemoteDataSource.swift
│       └── ProfileRemoteSource.swift
├── data/                               # Data Layer
│   ├── models/                         # API DTOs
│   │   ├── LoginApi.swift              # Login/Register models
│   │   ├── UserApi.swift
│   │   ├── ProfileApi.swift
│   │   ├── CustomerApi.swift
│   │   ├── RoomApi.swift
│   │   └── ReservationApi.swift
│   ├── AuthRepositoryImpl.swift
│   ├── AuthRemoteDataSourceImpl.swift
│   ├── RoomRepositoryImpl.swift
│   ├── RoomRemoteSourceImpl.swift
│   ├── ProfileRepositoryImpl.swift
│   ├── ProfileRemoteSourceImpl.swift
│   ├── ReservationsRepositoryImp.swift
│   └── ReservationRemoteSourceImpl.swift
└── shared/                             # Infrastructure
    ├── DependencyContainer.swift       # Manual dependency injection
    ├── Network.swift                   # BaseNetworkManager
    ├── AuthenticationManager.swift     # Global auth state
    ├── TokenManager.swift              # Keychain token storage
    ├── ApiResponse.swift               # Generic API wrapper
    └── Failure.swift                   # Domain error types
```

**Total Lines of Code:** ~3,681 lines of Swift

## 📸 Screenshots

| Login | Registration | Room Search | Reservations | Profile |
|-------|--------------|-------------|--------------|---------|
| ![Login](docs/screenshots/login.png) | ![Register](docs/screenshots/register.png) | ![Search](docs/screenshots/search.png) | ![Reservations](docs/screenshots/reservations.png) | ![Profile](docs/screenshots/profile.png) |

*Screenshots coming soon*

## 🚀 Setup Instructions

### Prerequisites

- **macOS**: Sonoma (14.0) or later
- **Xcode**: 15.0 or later
- **Swift**: 5.0+
- **iOS Device/Simulator**: iOS 17.4+

### Installation Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/manuellugodev/HotelClientIos.git
```

#### 2. Open in Xcode

```bash
open Hotel.xcodeproj
```

Or open Xcode and select `File > Open > Hotel.xcodeproj`

#### 3. Configure Backend URL (Optional)

If you need to change the backend API URL, update it in `Hotel/shared/DependencyContainer.swift`:

```swift
private init() {
    self.networkManager = BaseNetworkManager(baseURL: "https://hotel.manuellugo.dev")
    // ... rest of initialization
}
```

#### 4. Select Target Device

1. In Xcode, select a target device from the scheme selector
   - Choose any iOS 17.4+ simulator (e.g., iPhone 15)
   - Or connect a physical iOS device with iOS 17.4+

#### 5. Build and Run

Press `⌘ + R` or click the "Run" button in Xcode toolbar.

The app will compile and launch on your selected device/simulator.

## 🌐 Backend Integration

This iOS app connects to a Spring Boot backend REST API.

**Backend Repository**: [HotelManagmentApi](https://github.com/manuellugodev/HotelManagmentApi)

### API Endpoints

| Endpoint | Method | Auth Required | Description |
|----------|--------|---------------|-------------|
| `/login` | POST | ❌ | Authenticate user and receive JWT token |
| `/user/register` | POST | ❌ | Register new user account |
| `/rooms` | GET | ✅ | Get available rooms by date/guests |
| `/user/{username}` | GET | ✅ | Get user profile data |
| `/appointment` | POST | ✅ | Create new reservation |
| `/appointment/{guestId}` | GET | ✅ | Get user's reservations (upcoming/past) |
| `/appointment/{reservationId}` | DELETE | ✅ | Delete a reservation |
| `/auth/refresh` | POST | ❌ | Refresh expired JWT token |

**Base URL**: `https://hotel.manuellugo.dev`

### Authentication Flow

1. User logs in with username/password
2. Backend returns JWT access token
3. Token stored securely in iOS Keychain
4. Token automatically injected in all authenticated requests
5. On 401 error, token refresh attempted automatically
6. Session persists across app launches

## 🎯 Key Features Implementation

### User Authentication & Registration

- **Login**: Username/password authentication with JWT
- **Registration**: Comprehensive form with validation
  - Username, first name, last name
  - Email (format validation)
  - Phone number (numeric validation)
  - Password (minimum 6 characters + confirmation match)
  - Field-specific error messages
- **Security**: JWT tokens stored in iOS Keychain
- **Session Management**: Automatic token refresh on expiry

### Room Search & Booking

- **Search Interface**: Date picker + guest count selector
- **Available Rooms**: Real-time API query based on criteria
- **Room Display**: AsyncImage for room photos, details, pricing
- **Booking Confirmation**: Review screen with:
  - Room details and pricing breakdown
  - Guest information pre-filled from profile
  - Booking purpose field
  - Tax and total price calculation

### Reservation Management

- **My Reservations**: Tabbed view for upcoming vs. past bookings
- **Upcoming Reservations**: Future check-in dates
- **Past Reservations**: Historical bookings
- **Delete Functionality**: Swipe-to-delete with confirmation dialog
- **Real-time Updates**: List refreshes after deletion

### Network Layer

- **Generic Fetch Method**: Type-safe Codable-based networking
- **Automatic JWT Injection**: Tokens added to headers automatically
- **Error Handling**: Centralized error mapping to domain failures
- **Token Refresh**: Automatic retry with refresh token on 401
- **Logging**: Request/response logging for debugging

## 🎨 Code Style & Conventions

- **Naming**: Swift standard (camelCase for vars/funcs, PascalCase for types)
- **Architecture**: Strict layer separation (no cross-layer dependencies)
- **Async/Await**: All network calls use modern Swift concurrency
- **Protocol-Oriented**: All repos/data sources defined as protocols
- **No Force Unwrapping**: Safe optional handling throughout
- **No Third-Party Libraries**: 100% native Swift/SwiftUI implementation

## 📝 Documentation

For detailed architecture and implementation context, see:
- [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) - Complete project documentation

## 🔮 Future Enhancements

- [ ] Room details screen with image gallery
- [ ] Edit profile functionality
- [ ] Payment integration (Stripe/Apple Pay)
- [ ] Advanced filters (price range, amenities, room type)
- [ ] Offline caching with Core Data
- [ ] Push notifications for reservation reminders
- [ ] Dark mode support
- [ ] Accessibility improvements (VoiceOver, Dynamic Type)
- [ ] Localization (English/Spanish)
- [ ] Unit and UI tests
- [ ] iPad optimization

## 📄 License

This project is for **personal and educational use only**.

**Restrictions:**
- ❌ Commercial use is prohibited
- ❌ Redistribution is not allowed
- ✅ Modification for learning purposes is permitted
- ✅ Use as portfolio/reference material is allowed

© 2025 Manuel Lugo. All rights reserved.

## 👨‍💻 Developer

**Manuel Lugo**

- 📧 Email: manuellugo2000ml@gmail.com
- 🐙 GitHub: [@manuellugodev](https://github.com/manuellugodev)
- 💼 Portfolio: [manuellugo.dev](https://manuellugo.dev)

## 🙏 Acknowledgments

- Built with ❤️ using SwiftUI and Clean Architecture
- Backend API powered by Spring Boot
- Inspired by modern hotel booking applications

---

**⭐ If you find this project helpful, please consider giving it a star!**

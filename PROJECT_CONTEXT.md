# Hotel iOS/macOS Project - Context Documentation

**Last Updated**: 2025-11-06
**Project Type**: Native iOS/macOS Hotel Booking Application
**API Backend**: https://hotel.manuellugo.dev
**Total LOC**: ~2,150 lines of Swift

---

## Quick Start Context

This is a **SwiftUI-based hotel booking app** using **Clean Architecture** principles. The app is functional with authentication (login & registration), room search, profile management, reservation creation with confirmation, viewing upcoming/past reservations, and reservation deletion fully implemented.

---

## Architecture Overview

### Clean Architecture (3-Layer Pattern)

```
┌─────────────────────────────────────┐
│     Presentation Layer (features/)   │
│   • Views (SwiftUI)                  │
│   • ViewModels (@MainActor)          │
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

---

## Tech Stack

- **UI Framework**: SwiftUI (declarative UI)
- **Concurrency**: Swift Async/Await
- **Networking**: URLSession (custom BaseNetworkManager)
- **Reactivity**: Combine (@Published properties)
- **Storage**: Keychain (token management)
- **Architecture**: Clean Architecture + MVVM
- **DI**: Manual dependency injection via DependencyContainer

---

## Project Structure

```
Hotel/
├── HotelApp.swift                      # App entry point
├── features/                           # Presentation Layer
│   ├── auth/                           # ✅ Login/Authentication/Registration
│   │   ├── LoginView.swift
│   │   ├── LoginViewModel.swift
│   │   ├── RegisterView.swift
│   │   └── RegisterViewModel.swift
│   ├── home/                           # ✅ Main navigation
│   │   └── MainHomeView.swift
│   ├── rooms/                          # ✅ Room browsing
│   │   ├── RoomsAvailablesView.swift
│   │   └── RoomsAvailableViewModel.swift
│   ├── reservations/                   # ✅ Reservation search, booking, and management
│   │   ├── ReservationView.swift
│   │   ├── ReservationViewModel.swift
│   │   ├── ConfirmationReservationView.swift
│   │   └── MyReservationsView.swift (upcoming/past)
│   └── profile/                        # ✅ User profile
│       ├── ProfileView.swift
│       └── ProfileViewModel.swift
├── domain/                             # Business Logic Layer
│   ├── model/                          # Domain entities
│   │   ├── User.swift
│   │   ├── Profile.swift
│   │   ├── RoomHotel.swift
│   │   ├── Reservation.swift
│   │   └── Customer.swift
│   ├── usecases/                       # Business operations
│   │   ├── LoginUseCase.swift
│   │   ├── RegisterUserUseCase.swift
│   │   ├── GetRoomsAvailables.swift
│   │   ├── GetProfileUsecase.swift
│   │   ├── MakeReservationsUseCase.swift
│   │   ├── GetReservationsUseCase.swift
│   │   └── DeleteReservationUseCase.swift
│   ├── repository/                     # Repository protocols
│   └── datasource/                     # Data source protocols
├── data/                               # Data Layer
│   ├── models/                         # API DTOs
│   │   ├── LoginApi.swift              # LoginRequest/Response, RegisterRequest/Response
│   │   ├── UserApi.swift
│   │   ├── ProfileApi.swift
│   │   └── RoomApi.swift
│   ├── AuthRepositoryImpl.swift
│   ├── RoomRepositoryImpl.swift
│   ├── ProfileRepositoryImpl.swift
│   └── ReservationsRepositoryImp.swift
└── shared/                             # Infrastructure
    ├── DependencyContainer.swift       # Manual DI container
    ├── Network.swift                   # BaseNetworkManager
    ├── AuthenticationManager.swift     # Global auth state
    ├── TokenManager.swift              # Keychain token storage
    ├── Failure.swift                   # Domain error types
    └── ApiResponse.swift               # Generic API wrapper
```

---

## Features Status

### ✅ Fully Implemented

1. **Authentication Flow** (`features/auth/`)
   - Login with username/password
   - JWT token management (Keychain storage)
   - Automatic token refresh on 401
   - Session persistence
   - Logout with confirmation

2. **User Registration** (`features/auth/`)
   - User registration with complete form validation
   - Field-specific error messages (username, firstName, lastName, email, phone, password)
   - Email format validation
   - Phone number validation
   - Password strength validation (minimum 6 characters)
   - Password confirmation matching
   - Success notification with automatic navigation to login
   - POST `/user/register` endpoint integration

3. **Room Search & Browsing** (`features/rooms/`)
   - Date range selection (check-in/check-out)
   - Guest count selection (adults + children)
   - Available rooms API integration
   - Room list with AsyncImage loading
   - Room details display (type, price, capacity, description)

4. **User Profile** (`features/profile/`)
   - Profile data fetching via username
   - Display: name, email, phone, guestId
   - Logout functionality

5. **Reservation Creation & Confirmation**
   - Booking confirmation screen after room selection
   - Guest details and payment summary display
   - Integration with `MakeReservationsUseCase`
   - POST `/appointment` endpoint integration
   - Confirmation UI with reservation details

6. **My Reservations** (`features/reservations/`)
   - View upcoming reservations (future check-in dates)
   - View past reservations (historical bookings)
   - Reservation list display with details
   - Filter/categorize by date (upcoming vs past)

7. **Reservation Management**
   - Delete reservation functionality
   - Confirmation dialog before deletion
   - Real-time list updates after deletion

8. **Network Infrastructure** (`shared/Network.swift`)
   - Generic fetch with Codable
   - Automatic JWT injection
   - Token refresh on 401
   - Error mapping
   - Request/response logging

### ❌ Not Implemented

- Room details screen (tapping room doesn't navigate)
- Edit profile functionality
- Payment integration
- Advanced filters (price range, amenities)
- Offline caching
- Comprehensive error handling UI

---

## Domain Models

### Core Entities

```swift
// User (authentication result)
User {
    username: String
    guestId: Int64
    token: String
}

// Profile (user details)
Profile {
    username: String
    firstName: String
    lastName: String
    email: String
    phone: String
    guestId: Int
}

// RoomHotel (room entity)
RoomHotel {
    id: Int64
    description: String
    roomType: String       // "Family", "Individual", "Double", "Suite"
    pathImage: String      // URL to room image
    peopleQuantity: Int
    price: Double
}

// Customer (guest info)
Customer {
    id: Int
    firstName: String
    lastName: String
    email: String
    phone: String
}

// Reservation (booking entity)
Reservation {
    id: Int
    guest: Customer
    roomHotel: RoomHotel
    checkIn: Int64         // Unix timestamp
    checkOut: Int64        // Unix timestamp
    purpose: String
    price: Double
    taxPrice: Double
    totalPrice: Double
}
```

---

## API Endpoints

| Endpoint | Method | Auth | Status | Purpose |
|----------|--------|------|--------|---------|
| `/login` | POST | No | ✅ | Authenticate user |
| `/user/register` | POST | No | ✅ | Register new user |
| `/rooms?dStartTime=&dEndTime=&guests=` | GET | Yes | ✅ | Get available rooms |
| `/user/{username}` | GET | Yes | ✅ | Get user profile |
| `/appointment` | POST | Yes | ✅ | Create reservation |
| `/appointment/{guestId}` | GET | Yes | ✅ | Get user reservations (upcoming/past) |
| `/appointment/{reservationId}` | DELETE | Yes | ✅ | Delete reservation |
| `/auth/refresh` | POST | No | ✅ | Refresh access token |

**Base URL**: `https://hotel.manuellugo.dev`

---

## Navigation Flow

```
App Launch
    ↓
AuthenticationManager.isAuthenticated?
    ├─ NO  → LoginView
    │           ├─ (tap "Register") → RegisterView
    │           │                         ↓ (registration success)
    │           │                      LoginView
    │           ↓ (login success)
    │        MainHomeView
    │
    └─ YES → MainHomeView (TabView)
                ├─ Tab 1: Home (ReservationView)
                │           ↓ (search submit)
                │        RoomsAvailableView
                │           ↓ (tap room)
                │        BookingConfirmationView
                │           ↓ (confirm reservation)
                │        [Reservation created]
                │
                ├─ Tab 2: My Reservations
                │        ReservationsView
                │           ├─ Upcoming Reservations List
                │           └─ Past Reservations List
                │               ↓ (delete reservation)
                │           [Confirmation dialog → Delete]
                │
                └─ Tab 3: Profile
                         ProfileView
                             ↓ (logout)
                         LoginView
```

---

## Key Design Patterns

1. **Clean Architecture**: Strict layer separation (Presentation → Domain → Data)
2. **MVVM**: All views have ViewModels with @Published properties
3. **Repository Pattern**: Protocol-based data abstraction
4. **Use Case Pattern**: Each business operation is a dedicated use case
5. **Dependency Injection**: Manual DI via `DependencyContainer.shared`
6. **Protocol-Oriented Design**: All repositories/data sources/use cases use protocols
7. **Mapper Pattern**: API models → Domain models (e.g., `UserApi.toGetProfileData()`)
8. **Result Type**: All async operations return `Result<Success, Failure>`
9. **Singleton**: DependencyContainer, TokenManager

---

## Network Layer Details

### BaseNetworkManager (`shared/Network.swift`)

**Key Features**:
- Generic fetch with Codable support
- Automatic JWT token injection from Keychain
- Automatic token refresh on 401 errors
- Query parameter support
- Comprehensive error mapping

**Signature**:
```swift
func fetch<T: Codable>(
    endpoint: String,
    queryItems: [URLQueryItem]? = nil,
    method: String = "GET",
    body: Data? = nil,
    headers: [String: String]? = nil,
    requiresAuth: Bool = true
) async throws -> T
```

### API Response Wrapper
```swift
APIResponse<T> {
    data: T
    status: Int
    message: String      // Note: API has typo "messsage" (3 s's)
    errorType: String?
    timeStamp: Int64
}
```

### Token Management (`shared/TokenManager.swift`)
- Stores tokens in iOS Keychain (secure)
- Manages: `authToken`, `refreshToken`, `authUsername`
- Singleton pattern
- Automatic cleanup on logout

---

## Recent Git History

```
35f0f75 - Added feature Delete Reservation
a4813fc - Fixed bug total Price when search Rooms Availables
f1d43b6 - Implemented ConfirmationReservation
4c0b04e - Implemented models of Api and feature upcoming and past Reservations
5f13dcb - Implemented GetData Profile data flow
```

---

## Next Steps / TODOs

### High Priority
1. Add room details screen with more info/images
2. Implement comprehensive error handling UI (network failures, validation errors)
3. Add loading states and skeleton views

### Medium Priority
4. Add profile editing functionality
5. Implement advanced search filters (price range, amenities)
6. Improve reservation details view with more information

### Low Priority
7. Add payment integration
8. Implement offline caching
9. Add reservation modification functionality
10. Implement push notifications for reservation reminders

---

## Important File Locations

### Entry Point
- `Hotel/HotelApp.swift:1` - App entry point with auth routing

### Core Infrastructure
- `Hotel/shared/Network.swift:1` - BaseNetworkManager
- `Hotel/shared/DependencyContainer.swift:1` - Dependency injection
- `Hotel/shared/TokenManager.swift:1` - Keychain token storage
- `Hotel/shared/AuthenticationManager.swift:1` - Global auth state

### ViewModels & Views
- `Hotel/features/auth/LoginViewModel.swift:1`
- `Hotel/features/auth/RegisterViewModel.swift:1` - Registration with validation
- `Hotel/features/auth/RegisterView.swift:1` - Registration form UI
- `Hotel/features/rooms/RoomsAvailableViewModel.swift:1`
- `Hotel/features/reservations/ReservationViewModel.swift:1`
- `Hotel/features/reservations/ConfirmationReservationView.swift:1` - Booking confirmation
- `Hotel/features/reservations/MyReservationsView.swift:1` - Upcoming/past reservations
- `Hotel/features/profile/ProfileViewModel.swift:1`

### Domain Models
- `Hotel/domain/model/User.swift:1`
- `Hotel/domain/model/Profile.swift:1`
- `Hotel/domain/model/RoomHotel.swift:1`
- `Hotel/domain/model/Reservation.swift:1`

---

## Code Style & Conventions

- **Naming**: Swift standard (camelCase for variables/functions, PascalCase for types)
- **Async/Await**: All network calls use modern Swift concurrency
- **Error Handling**: Domain-specific `Failure` enum
- **View Models**: All marked `@MainActor` for UI thread safety
- **Dependency Injection**: Protocol injection via initializers
- **Comments**: Minimal (code is self-documenting)

---

## How to Use This Document

When starting a new Claude Code session, share this document with:

> "Here's the context for my Hotel iOS project: [paste PROJECT_CONTEXT.md or reference file path]"

This will help Claude understand:
- What's already implemented
- The architecture and patterns used
- Where to find specific code
- What needs to be completed next

---

**Note**: This is a living document. Update it when significant changes are made to the project structure or features.

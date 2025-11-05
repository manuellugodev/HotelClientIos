# Hotel iOS/macOS Project - Context Documentation

**Last Updated**: 2025-11-05
**Project Type**: Native iOS/macOS Hotel Booking Application
**API Backend**: https://hotel.manuellugo.dev
**Total LOC**: ~2,150 lines of Swift

---

## Quick Start Context

This is a **SwiftUI-based hotel booking app** using **Clean Architecture** principles. The app is functional with authentication, room search, and profile management fully implemented. Reservation creation is partially complete and needs finishing.

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
│   ├── auth/                           # ✅ Login/Authentication
│   │   ├── LoginView.swift
│   │   └── LoginViewModel.swift
│   ├── home/                           # ✅ Main navigation
│   │   └── MainHomeView.swift
│   ├── rooms/                          # ✅ Room browsing
│   │   ├── RoomsAvailablesView.swift
│   │   └── RoomsAvailableViewModel.swift
│   ├── reservations/                   # ✅ Reservation search UI
│   │   ├── ReservationView.swift
│   │   └── ReservationViewModel.swift
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
│   │   ├── GetRoomsAvailables.swift
│   │   ├── GetProfileUsecase.swift
│   │   └── MakeReservationsUseCase.swift  # ⚠️ Not integrated in UI
│   ├── repository/                     # Repository protocols
│   └── datasource/                     # Data source protocols
├── data/                               # Data Layer
│   ├── models/                         # API DTOs
│   │   ├── LoginApi.swift
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

2. **Room Search & Browsing** (`features/rooms/`)
   - Date range selection (check-in/check-out)
   - Guest count selection (adults + children)
   - Available rooms API integration
   - Room list with AsyncImage loading
   - Room details display (type, price, capacity, description)

3. **User Profile** (`features/profile/`)
   - Profile data fetching via username
   - Display: name, email, phone, guestId
   - Logout functionality

4. **Network Infrastructure** (`shared/Network.swift`)
   - Generic fetch with Codable
   - Automatic JWT injection
   - Token refresh on 401
   - Error mapping
   - Request/response logging

### ⚠️ Partially Implemented

1. **Reservation Creation**
   - Backend integration exists (`MakeReservationsUseCase`)
   - POST `/appointment` endpoint implemented
   - **MISSING**: UI flow after room selection
   - **TODO**: Connect `RoomsAvailableViewModel.selectRoom()` to booking confirmation

2. **My Reservations Tab**
   - Placeholder UI exists
   - **MISSING**: API integration to fetch user reservations
   - **TODO**: Implement `GET /reservations/{guestId}` integration

### ❌ Not Implemented

- Room details screen (tapping room doesn't navigate)
- Edit profile functionality
- Payment integration
- Reservation cancellation
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
| `/rooms?dStartTime=&dEndTime=&guests=` | GET | Yes | ✅ | Get available rooms |
| `/user/{username}` | GET | Yes | ✅ | Get user profile |
| `/appointment` | POST | Yes | ⚠️ | Create reservation (not in UI) |
| `/auth/refresh` | POST | No | ✅ | Refresh access token |

**Base URL**: `https://hotel.manuellugo.dev`

---

## Navigation Flow

```
App Launch
    ↓
AuthenticationManager.isAuthenticated?
    ├─ NO  → LoginView
    │           ↓ (login success)
    │        MainHomeView
    │
    └─ YES → MainHomeView (TabView)
                ├─ Tab 1: Home (ReservationView)
                │           ↓ (search submit)
                │        RoomsAvailableView
                │           ↓ (tap room - NOT IMPLEMENTED)
                │        [BookingConfirmationView?]
                │
                ├─ Tab 2: My Reservations (PLACEHOLDER)
                │        ReservationsView
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
5f13dcb - Implemented GetData Profile data flow
50ec8a2 - Reorganize structure and modified model Reservation
5a4ccd1 - Fixed feature Room availables
476f446 - Implemented Auth Feature
57b3723 - Implemented RoomAvailables Feature (Testing)
```

---

## Next Steps / TODOs

### High Priority
1. **Complete Reservation Creation Flow**
   - Add booking confirmation screen after room selection
   - Implement `RoomsAvailableViewModel.selectRoom()` navigation
   - Create confirmation UI with guest details + payment summary
   - Connect to existing `MakeReservationsUseCase`

2. **Implement My Reservations Tab**
   - Create API endpoint integration for fetching user reservations
   - Build reservation list UI
   - Add reservation details view

### Medium Priority
3. Add room details screen with more info/images
4. Implement error handling UI (network failures, validation errors)
5. Add loading states and skeleton views
6. Implement reservation cancellation

### Low Priority
7. Add profile editing functionality
8. Implement advanced search filters
9. Add payment integration
10. Implement offline caching

---

## Important File Locations

### Entry Point
- `Hotel/HotelApp.swift:1` - App entry point with auth routing

### Core Infrastructure
- `Hotel/shared/Network.swift:1` - BaseNetworkManager
- `Hotel/shared/DependencyContainer.swift:1` - Dependency injection
- `Hotel/shared/TokenManager.swift:1` - Keychain token storage
- `Hotel/shared/AuthenticationManager.swift:1` - Global auth state

### ViewModels
- `Hotel/features/auth/LoginViewModel.swift:1`
- `Hotel/features/rooms/RoomsAvailableViewModel.swift:1`
- `Hotel/features/reservations/ReservationViewModel.swift:1`
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

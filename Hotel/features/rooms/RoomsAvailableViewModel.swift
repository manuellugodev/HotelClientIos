//
//  ReservationsAvailableViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

@MainActor
class RoomsAvailableViewModel: ObservableObject {
    @Published var rooms: [RoomHotel] = []
    @Published var isLoading: Bool = false
    @Published var showConfirmation: Bool = false
    @Published var selectedRoom: RoomHotel?

    nonisolated(unsafe) let getRoomsAvailables:GetRoomsAvailables
    let checkInDate: Date
    let checkOutDate: Date
    private let guests: Int

    nonisolated init(source:GetRoomsAvailables, checkIn: Date, checkOut: Date, guests: Int) {
        self.getRoomsAvailables = source
        self.checkInDate = checkIn
        self.checkOutDate = checkOut
        self.guests = guests
    }

    func loadRooms() {
        isLoading = true

        // Format dates to API format (yyyy-MM-dd)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let checkInString = dateFormatter.string(from: checkInDate)
        let checkOutString = dateFormatter.string(from: checkOutDate)

        Task {
            let result = await getRoomsAvailables.execute(checkInString, checkOutString, guests)

            switch result {
            case .success(let fetchedRooms):
                self.rooms = fetchedRooms
                self.isLoading = false

            case .failure(let error):
                self.isLoading = false
                print("Error loading rooms: \(error.message)")
                self.rooms = []
            }
        }
    }
    
    func selectRoom(_ room: RoomHotel) {
        selectedRoom = room
        showConfirmation = true
    }
    
    func getFakeData(){
        self.rooms = [
            RoomHotel(
                 id: 1,
                 description: "Spacious room with king-size bed, perfect for families. Includes mini-bar, smart TV, and private balcony with city view.",
                 roomType: "Family",
                 pathImage: "room_family_1",
                 peopleQuantity: 4,
                 price: 150.0
             ),
             RoomHotel(
                 id: 2,
                 description: "Cozy single room with queen bed, ideal for solo travelers. Features work desk and high-speed WiFi.",
                 roomType: "Individual",
                 pathImage: "room_individual_1",
                 peopleQuantity: 1,
                 price: 80.0
             ),
             RoomHotel(
                 id: 3,
                 description: "Comfortable double room with two single beds. Perfect for friends or colleagues traveling together.",
                 roomType: "Double",
                 pathImage: "room_double_1",
                 peopleQuantity: 2,
                 price: 100.0
             ),
             RoomHotel(
                 id: 4,
                 description: "Luxury suite with separate living area, king bed, and jacuzzi. Premium amenities and room service included.",
                 roomType: "Suite",
                 pathImage: "room_suite_1",
                 peopleQuantity: 3,
                 price: 200.0
             ),
             RoomHotel(
                 id: 5,
                 description: "Large family room with bunk beds and double bed. Entertainment system and kitchenette available.",
                 roomType: "Family",
                 pathImage: "room_family_2",
                 peopleQuantity: 5,
                 price: 180.0
             ),
             RoomHotel(
                 id: 6,
                 description: "Standard individual room with modern decor. Compact yet comfortable with all essential amenities.",
                 roomType: "Individual",
                 pathImage: "room_individual_2",
                 peopleQuantity: 1,
                 price: 75.0
             ),
             RoomHotel(
                 id: 7,
                 description: "Deluxe double room with garden view. Features separate seating area and upgraded bathroom.",
                 roomType: "Double",
                 pathImage: "room_double_2",
                 peopleQuantity: 2,
                 price: 120.0
             ),
             RoomHotel(
                 id: 8,
                 description: "Presidential suite with panoramic ocean view. Two bedrooms, dining room, and private terrace.",
                 roomType: "Suite",
                 pathImage: "room_suite_2",
                 peopleQuantity: 4,
                 price: 350.0
             )
         ]
    
    }
}


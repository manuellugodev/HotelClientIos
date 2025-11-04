//
//  ReservationsAvailableViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation
class RoomsAvailableViewModel: ObservableObject {
    @Published var rooms: [RoomHotel] = []
    @Published var isLoading: Bool = false

    let getRoomsAvailables:GetRoomsAvailables
    
    init(source:GetRoomsAvailables) {
        self.getRoomsAvailables = source
        loadRooms()
    }
    
    func loadRooms() {
        isLoading = true
        
        Task {
            let result = await getRoomsAvailables.execute("2025-09-03","2025-09-06",1)
            
            switch result {
            case .success(let fetchedRooms):
                self.rooms = fetchedRooms
                self.isLoading = false
                
            case .failure(let error):
                self.isLoading = false
                
                self.rooms = []
            }
        }
    }
    
    func selectRoom(_ room: RoomHotel) {
        print("Selected room: \(room.roomType)")
        // Handle room selection
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


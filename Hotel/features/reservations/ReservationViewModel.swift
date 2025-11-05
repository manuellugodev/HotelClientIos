//
//  ReservationViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 10/29/25.
//

import Foundation

@MainActor
final class ReservationViewModel: ObservableObject{
    @Published var adults = 1
    @Published var children = 0
    
    @Published var checkIn : Date
    @Published var checkOut : Date
    
    @Published var searchReservation = false
    
    var allowedRange :ClosedRange<Date>{minDate...maxDate}
    
    var totalGuests :Int {adults + children}
    
    let minDate:Date
    let maxDate:Date
    private let calendar =  Calendar.current
    
    init(
        now:Date = Date(),
        daysAhead:Int = 365
    ) {
        let start = calendar.startOfDay(for: now)
        self.minDate = start
        self.maxDate = calendar.date(byAdding: .day, value: daysAhead, to: start)!
        self.checkIn = start
        self.checkOut = calendar.date(byAdding: .day, value: 3, to: start)!
    }
    
    var guestsSummary: String {
            let adultLabel = adults == 1 ? "Adult" : "Adults"
            let childLabel = children == 1 ? "Child" : "Children"
            return "\(adults) \(adultLabel) and \(children) \(childLabel)"
        }
    
    var checkInSummary:String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: checkIn)
    }
    
    var checkOutSummary:String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: checkOut)
    }
    
    func navigateToSearch(){
        searchReservation=true
    }
    
    func setCheckIn(_ date:Date){
        checkIn = clamped(date)
        if checkOut<checkIn {checkOut=checkIn}
        
    }
    
    func setCheckOut(_ date:Date){
        checkOut = max(clamped(date),checkIn)
    }
    
    
    func incAdults(){adults+=1}
    func descAdults(){adults-=1}
    func incChildren(){children+=1}
    func descChildren(){children-=1}
    
    
    
    private func clamped(_ date:Date)-> Date {
        min(max(date,minDate),maxDate)
    }

}
    
    
    
    

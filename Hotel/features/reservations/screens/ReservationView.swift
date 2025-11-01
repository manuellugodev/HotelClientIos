//
//  ReservationView.swift
//  Hotel
//
//  Created by Manuel Lugo on 10/29/25.
//

import SwiftUI

struct ReservationView: View {
    @StateObject private var vm = ReservationViewModel()
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ReservationFieldView(vm:vm)
                
                Divider()
                Button(action: vm.navigateToSearch) {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .buttonStyle(.borderedProminent)
                .padding(.top,10)
                
                Spacer()
            }
            .padding(.top,30)
            .padding(.horizontal,20)
            .navigationTitle("Scheduled Reservation")
            
        }
        
    }
}

struct ReservationFieldView:View{
    @StateObject var vm:ReservationViewModel ;
    
    private enum ActiveSheet: Identifiable {
        case guests, checkInDate,checkOutDate
        var id: Int { hashValue }
    }
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        ReadOnlyField(title:"Check In",value:vm.checkInSummary,icon: "calendar.badge.plus",onTap:{activeSheet = .checkInDate})
        ReadOnlyField(title:"Check Out",value:vm.checkOutSummary,icon: "calendar.badge.minus",onTap:{activeSheet = .checkOutDate})
        ReadOnlyField(title:"Guests",value: vm.guestsSummary,icon:"person.fill",onTap:{activeSheet = .guests})
            .sheet(item: $activeSheet) { sheet in
                        switch sheet {
                        case .guests:
                            GuestNumbersView(adultsNumber: vm.adults, onPlusAdults: vm.incAdults, onMinusAdults: vm.descAdults, childrenNumbers: vm.children, onPlusChildren: vm.incChildren, onMinusChildren: vm.descChildren)
                                .presentationDetents([.height(150), .large])
                        case .checkInDate:
                            CalendarView(value: vm.checkIn, setSelectedDate: vm.setCheckIn, allowedScope: vm.allowedRange)
                                .presentationDetents([.medium, .large])
                        case .checkOutDate:
                            CalendarView(value: vm.checkOut, setSelectedDate: vm.setCheckOut, allowedScope: vm.allowedRange)
                                .presentationDetents([.medium, .large])
                        }
                    }    }
    
}

struct ReadOnlyField:View {
    let title:String
    let value:String
    let icon:String
    let onTap:()->Void
    var body: some View {
    
        
        Label(title,systemImage: icon)
            .font(.caption)
            .foregroundColor(.secondary)
        Button(action:onTap){
            HStack{
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24,height: 24)
                TextField("",text: .constant(value))
                    .disabled(true)
                    .textFieldStyle(.roundedBorder)
            }
            
        }
    
    }
}

struct CalendarView:View {
    
    let value:Date
    let setSelectedDate:(Date)->Void
    let allowedScope:ClosedRange<Date>

    var body: some View {
        
        DatePicker(
            "Select a date",
            selection: Binding(get: {value}, set: setSelectedDate),
            in: allowedScope,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        
            
    }
}


struct GuestNumbersView:View {
    let adultsNumber:Int
    let onPlusAdults:()->Void
    let onMinusAdults:()->Void
    
    let childrenNumbers:Int
    let onPlusChildren:()->Void
    let onMinusChildren:()->Void
    



    var body: some View {
        RowGuest(title: "Adults", value: adultsNumber, onPlus:onPlusAdults, onMinus: onMinusAdults)
        RowGuest(title: "Children", value: childrenNumbers, onPlus: onPlusChildren, onMinus: onMinusChildren).padding(.top,20)
    }
}

private struct RowGuest:View {
    
    let title:String
    let value:Int
    let onPlus:()->Void
    let onMinus:()->Void

    var body: some View {
    
        HStack{
            Text(title)
                .font(.title3)
                .frame(width: 100,alignment: .leading)
        Spacer()
            
            Button(action:onMinus){Image(systemName: "minus.circle.fill").font(.title2)}
            Text("\(value)").frame(width: 44).font(.title3).fontWeight(.semibold)
            Button(action:onPlus){Image(systemName: "plus.circle.fill").font(.title2)}
        }
        .padding(.horizontal)
    }
}
#Preview {
    ReservationView()
}

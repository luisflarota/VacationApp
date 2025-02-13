import SwiftUI

struct TripListView: View {
    let tripType: TripType
    @StateObject private var viewModel = TripViewModel()
    @State private var selectedTimeFrame: TimeFrame = .near
    
    var body: some View {
        VStack {
            // Time frame picker
            Picker("Time Frame", selection: $selectedTimeFrame) {
                Text("Near Future").tag(TimeFrame.near)
                Text("Medium Future").tag(TimeFrame.medium)
                Text("Long Future").tag(TimeFrame.long)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(viewModel.filterTrips(byTimeFrame: selectedTimeFrame)) { trip in
                    TripCard(trip: trip)
                }
            }
        }
    }
}

struct TripCard: View {
    let trip: TripSuggestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(trip.destination)
                .font(.title2)
                .bold()
            
            HStack {
                Image(systemName: "clock")
                Text("Duration: \(trip.duration) days")
            }
            
            HStack {
                Image(systemName: "airplane")
                Text(trip.airline)
            }
            
            HStack {
                Image(systemName: "dollarsign.circle")
                Text(trip.formattedPrice)
                    .foregroundColor(.green)
            }
            
            Link(destination: URL(string: trip.bookingUrl)!) {
                Text("Book Now")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView(tripType: .short)
    }
} 
import Foundation

// Trip duration categories
enum TripType {
    case short   // 1-3 days
    case medium  // 4-7 days
    case long    // 8+ days
    
    var description: String {
        switch self {
        case .short: return "1-3 days"
        case .medium: return "4-7 days"
        case .long: return "8+ days"
        }
    }
}

// Time frame categories
enum TimeFrame {
    case near    // 1-2 months
    case medium  // 3-7 months
    case long    // 8-12 months
    
    var description: String {
        switch self {
        case .near: return "Next 1-2 months"
        case .medium: return "3-7 months ahead"
        case .long: return "8-12 months ahead"
        }
    }
}

// Main trip suggestion model
struct TripSuggestion: Identifiable {
    let id = UUID()
    let destination: String
    let tripType: TripType
    let timeFrame: TimeFrame
    let price: Double
    let airline: String
    let departureDate: Date
    let returnDate: Date
    let bookingUrl: String
    
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
    
    var duration: Int {
        Calendar.current.dateComponents([.day], from: departureDate, to: returnDate).day ?? 0
    }
}

// View Model for managing trip data
class TripViewModel: ObservableObject {
    @Published var trips: [TripSuggestion] = []
    @Published var isLoading = false
    @Published var error: String?
    
    func fetchTrips(from departureCity: String, tripType: TripType) {
        isLoading = true
        // TODO: Implement API call to fetch trips
        // This will be implemented when we add the API integration
    }
    
    func filterTrips(byTimeFrame timeFrame: TimeFrame) -> [TripSuggestion] {
        return trips.filter { $0.timeFrame == timeFrame }
    }
} 
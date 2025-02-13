import Foundation

@MainActor
class TripViewModel: ObservableObject {
    @Published var trips: [TripSuggestion] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let flightService: FlightService
    private let popularDestinations = [
        "NYC", "LAX", "MIA", "LAS", "SFO", "ORD", "HNL", "CUN", "CDG", "LHR"
    ]
    
    init() {
        // Initialize with your Amadeus API credentials
        self.flightService = FlightService(
            apiKey: "YOUR_API_KEY",
            apiSecret: "YOUR_API_SECRET"
        )
    }
    
    func fetchTrips(from departureCity: String, tripType: TripType) async {
        isLoading = true
        error = nil
        trips = []
        
        do {
            var allTrips: [TripSuggestion] = []
            
            // Get current date for calculations
            let currentDate = Date()
            let calendar = Calendar.current
            
            // Create date ranges for each time frame
            let timeFrames: [(TimeFrame, DateInterval)] = [
                (.near, DateInterval(
                    start: calendar.date(byAdding: .month, value: 1, to: currentDate)!,
                    end: calendar.date(byAdding: .month, value: 2, to: currentDate)!
                )),
                (.medium, DateInterval(
                    start: calendar.date(byAdding: .month, value: 3, to: currentDate)!,
                    end: calendar.date(byAdding: .month, value: 7, to: currentDate)!
                )),
                (.long, DateInterval(
                    start: calendar.date(byAdding: .month, value: 8, to: currentDate)!,
                    end: calendar.date(byAdding: .month, value: 12, to: currentDate)!
                ))
            ]
            
            // Search flights for each destination and time frame
            for destination in popularDestinations {
                for (timeFrame, dateInterval) in timeFrames {
                    // Sample a few dates within the interval
                    let sampleDates = sampleDates(in: dateInterval, count: 2)
                    
                    for departureDate in sampleDates {
                        let flights = try await flightService.searchFlights(
                            from: departureCity,
                            to: destination,
                            departureDate: departureDate
                        )
                        
                        // Convert flights to trip suggestions
                        let suggestions = flights.map { flight in
                            TripSuggestion(
                                destination: destination,
                                tripType: tripType,
                                timeFrame: timeFrame,
                                price: flight.price,
                                airline: flight.airline,
                                departureDate: flight.departureDate,
                                returnDate: flight.returnDate,
                                bookingUrl: flight.bookingUrl
                            )
                        }
                        
                        allTrips.append(contentsOf: suggestions)
                    }
                }
            }
            
            // Sort trips by price
            trips = allTrips.sorted { $0.price < $1.price }
            
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func filterTrips(byTimeFrame timeFrame: TimeFrame) -> [TripSuggestion] {
        return trips.filter { $0.timeFrame == timeFrame }
    }
    
    private func sampleDates(in interval: DateInterval, count: Int) -> [Date] {
        var dates: [Date] = []
        let duration = interval.duration
        
        for _ in 0..<count {
            let randomOffset = TimeInterval.random(in: 0..<duration)
            let date = interval.start.addingTimeInterval(randomOffset)
            dates.append(date)
        }
        
        return dates.sorted()
    }
} 
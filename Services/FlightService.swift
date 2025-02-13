import Foundation

class FlightService {
    private let apiKey: String
    private let apiSecret: String
    private var accessToken: String?
    private var tokenExpirationDate: Date?
    
    init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    private func getAccessToken() async throws -> String {
        // Check if we have a valid token
        if let token = accessToken,
           let expirationDate = tokenExpirationDate,
           expirationDate > Date() {
            return token
        }
        
        // Create token request
        let tokenURL = URL(string: "https://test.api.amadeus.com/v1/security/oauth2/token")!
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "grant_type=client_credentials&client_id=\(apiKey)&client_secret=\(apiSecret)"
        request.httpBody = body.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        
        accessToken = tokenResponse.access_token
        tokenExpirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expires_in))
        
        return tokenResponse.access_token
    }
    
    func searchFlights(from origin: String, to destination: String, departureDate: Date) async throws -> [Flight] {
        let token = try await getAccessToken()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: departureDate)
        
        let urlString = "https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=\(origin)&destinationLocationCode=\(destination)&departureDate=\(formattedDate)&adults=1&max=5"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let flightResponse = try JSONDecoder().decode(FlightResponse.self, from: data)
        
        return flightResponse.data.map { flightOffer in
            Flight(
                price: Double(flightOffer.price.total) ?? 0.0,
                airline: flightOffer.validatingAirlineCodes.first ?? "Unknown",
                departureDate: departureDate,
                returnDate: departureDate.addingTimeInterval(86400 * Double(Int.random(in: 1...14))), // Sample return date
                bookingUrl: "https://www.amadeus.com" // Replace with actual booking URL
            )
        }
    }
}

// Response models
struct TokenResponse: Codable {
    let access_token: String
    let expires_in: Int
}

struct FlightResponse: Codable {
    let data: [FlightOffer]
}

struct FlightOffer: Codable {
    let price: Price
    let validatingAirlineCodes: [String]
}

struct Price: Codable {
    let total: String
}

struct Flight {
    let price: Double
    let airline: String
    let departureDate: Date
    let returnDate: Date
    let bookingUrl: String
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
} 
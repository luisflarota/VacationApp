import Foundation

enum Config {
    // MARK: - API Credentials
    static let amadeusApiKey = "YOUR_AMADEUS_API_KEY"
    static let amadeusApiSecret = "YOUR_AMADEUS_API_SECRET"
    
    // MARK: - App Settings
    static let maxResultsPerTimeFrame = 5
    static let maxDestinationsToSearch = 10
    static let cacheDuration: TimeInterval = 3600 // 1 hour
    
    // MARK: - UI Settings
    static let cardCornerRadius: CGFloat = 12
    static let cardShadowRadius: CGFloat = 2
    static let primaryColor = "007AFF" // iOS blue
    
    // MARK: - Trip Duration Settings
    static let shortTripRange = 1...3
    static let mediumTripRange = 4...7
    static let longTripRange = 8...14
    
    // MARK: - Time Frame Settings
    static let nearFutureRange = 1...2 // months
    static let mediumFutureRange = 3...7 // months
    static let longFutureRange = 8...12 // months
} 
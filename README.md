# VacationApp - iOS Travel Suggestion App

An iOS application that suggests travel destinations based on user input, categorizing trips by duration and future time frames. The app provides real-time flight pricing using the Amadeus API.

## Features

- Single input field for departure city
- Trip categorization:
  - Short Trips (1-3 days)
  - Medium Trips (4-7 days)
  - Long Trips (8+ days)
- Time frame options:
  - Near Future (1-2 months)
  - Medium Future (3-7 months)
  - Long Future (8-12 months)
- Real-time flight pricing
- Beautiful, intuitive UI
- Direct booking links

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- Amadeus API credentials

## Setup

1. Clone the repository
2. Open `VacationApp.xcodeproj` in Xcode
3. Update the API credentials in `Config.swift`:
   ```swift
   static let amadeusApiKey = "YOUR_AMADEUS_API_KEY"
   static let amadeusApiSecret = "YOUR_AMADEUS_API_SECRET"
   ```
4. Build and run the project

## Getting Amadeus API Credentials

1. Visit the [Amadeus for Developers](https://developers.amadeus.com/) website
2. Create an account and log in
3. Create a new application
4. Copy your API key and secret
5. Update the credentials in `Config.swift`

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures for trips and flight information
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and data management
- **Services**: API integration and network calls

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 
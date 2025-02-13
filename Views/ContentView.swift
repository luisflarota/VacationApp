import SwiftUI

struct ContentView: View {
    @State private var departureCity: String = ""
    @State private var selectedTab: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Input
                SearchBar(text: $departureCity)
                    .padding()
                
                // Tab View for trip durations
                TabView(selection: $selectedTab) {
                    TripListView(tripType: .short)
                        .tabItem {
                            Label("Short Trips", systemImage: "clock")
                        }
                        .tag(0)
                    
                    TripListView(tripType: .medium)
                        .tabItem {
                            Label("Medium Trips", systemImage: "calendar")
                        }
                        .tag(1)
                    
                    TripListView(tripType: .long)
                        .tabItem {
                            Label("Long Trips", systemImage: "airplane")
                        }
                        .tag(2)
                }
            }
            .navigationTitle("Travel Suggestions")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Custom SearchBar View
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Enter departure city", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
} 
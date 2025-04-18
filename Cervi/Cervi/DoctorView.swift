import SwiftUI
import MapKit

struct DoctorLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct DoctorView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.7617, longitude: -80.1918), // You can set user's location if needed
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State private var places: [DoctorLocation] = []

    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: places) { place in
                MapMarker(coordinate: place.coordinate, tint: .red)
            }
            .onAppear(perform: searchNearbyDoctors)
            .navigationTitle("Nearby Gynecologists")
        }
    }

    func searchNearbyDoctors() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "gynecologist"
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else { return }
            places = response.mapItems.map {
                DoctorLocation(
                    name: $0.name ?? "Unknown",
                    coordinate: $0.placemark.coordinate
                )
            }
        }
    }
}

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            ReportView() // renamed ContentView
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Reports")
                }
            DoctorView()
                .tabItem {
                    Label("Doctor", systemImage: "cross.case")
                }
        }
    }
}

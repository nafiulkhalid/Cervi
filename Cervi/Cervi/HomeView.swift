import SwiftUI

struct HomeView: View {
    @State private var navigateToReport = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)

                Text("Cervi")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Check cervix health with one click.")
                    .foregroundColor(.gray)

                NavigationLink(destination: ReportView(), isActive: $navigateToReport) {
                    EmptyView()
                }

                Button(action: {
                    navigateToReport = true
                }) {
                    Text("Start Diagnosis")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
    }
}


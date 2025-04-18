import SwiftUI
import UIKit
import CoreImage
import ConfettiSwiftUI
import CoreImage.CIFilterBuiltins

struct ReportView: View {
    @State private var selectedImage: UIImage?
    @State private var hsvMaskImage: UIImage?
    @State private var predictionResult: String = "Take a photo to classify"
    @State private var confidence: Double = 0.0
    @State private var showPicker = false
    @State private var confettiTrigger = 0

    var confidenceDisplay: String {
        String(format: "%.2f%%", confidence * 100)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Logo & App Name
                    VStack(spacing: 4) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                        Text("Cervi")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }

                    // MARK: - Classification Report
                    VStack(alignment: .center, spacing: 12) {
                        Text("Classification Report")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Result")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(predictionResult)
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("Confidence")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(confidenceDisplay)
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                        }

                        // Green Button if cancerous
                        if predictionResult == "Cancerous" {
                            Button(action: {
                                print("Doctor contacted.")
                            }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("Contact Doctor")
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
                    .padding(.horizontal)

                    // MARK: - Uploaded Image
                    if let selectedImage = selectedImage {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Uploaded Sample")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Mask Output
                    if let hsvMaskImage = hsvMaskImage {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Detected White Spot Mask")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Image(uiImage: hsvMaskImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Upload Button
                    Button(action: {
                        showPicker = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Upload New Sample")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }

            // Confetti
            ConfettiCannon(trigger: $confettiTrigger, num: 40, repetitions: 3, repetitionInterval: 0.5)
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $selectedImage, onImagePicked: { image in
                selectedImage = image
                classifyWithHSV(image: image)
            })
        }
    }

    // MARK: - Classification Logic
    func classifyWithHSV(image: UIImage) {
        guard let (score, mask) = calculateWhiteSpotRatioHSV(image) else {
            predictionResult = "Could not process image."
            confidence = 0.0
            hsvMaskImage = nil
            return
        }

        hsvMaskImage = mask
        print("White Spot Ratio: \(score)")

        if score > 0.05 {
            predictionResult = "Cancerous"
            confidence = 1.0 - score
        } else {
            predictionResult = "Non-cancerous"
            confidence = 1.0 - score
            confettiTrigger += 1  // 🎉 Trigger confetti
        }
    }

    // MARK: - HSV Detection
    func calculateWhiteSpotRatioHSV(_ image: UIImage) -> (Double, UIImage)? {
        guard let cgImage = image.cgImage else { return nil }

        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        let width = Int(ciImage.extent.width)
        let height = Int(ciImage.extent.height)

        guard let cgRaw = context.createCGImage(ciImage, from: ciImage.extent),
              let data = cgRaw.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data) else {
            return nil
        }

        var whitePixelCount = 0
        let pixelCount = width * height

        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        guard let contextMask = UIGraphicsGetCurrentContext() else { return nil }

        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = ((width * y) + x) * 4
                let r = CGFloat(ptr[pixelIndex]) / 255.0
                let g = CGFloat(ptr[pixelIndex + 1]) / 255.0
                let b = CGFloat(ptr[pixelIndex + 2]) / 255.0

                var h: CGFloat = 0, s: CGFloat = 0, v: CGFloat = 0
                UIColor(red: r, green: g, blue: b, alpha: 1).getHue(&h, saturation: &s, brightness: &v, alpha: nil)

                if s < 0.2 && v > 0.8 {
                    whitePixelCount += 1
                    contextMask.setFillColor(UIColor.white.cgColor)
                } else {
                    contextMask.setFillColor(UIColor.black.cgColor)
                }

                contextMask.fill(CGRect(x: x, y: height - y - 1, width: 1, height: 1))
            }
        }

        let whiteRatio = Double(whitePixelCount) / Double(pixelCount)
        let hsvImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return (whiteRatio, hsvImage ?? image)
    }
}




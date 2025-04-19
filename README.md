# Cervi – Cervical Cancer Spot Detection App

Cervi is an iOS app designed to assist with preliminary visual analysis of cervical health using images from endoscopic cameras. It compares uploaded cervix images to pre-labeled datasets and reports the likelihood of being cancerous or non-cancerous based on visible white spot detection using HSV image processing.

---

## Features

- Upload cervix image via gallery
- Classifies based on white spot presence using HSV detection
- Clean report view with result & confidence score
- Locate nearby gynecologists using integrated Apple Maps
- Confetti celebration on non-cancerous result
- Smooth SwiftUI interface with tab-based navigation

---

## Image Processing Logic

- **Color Space:** HSV (Hue, Saturation, Value)
- **White Spot Detection:** Based on high brightness and low saturation pixels
- **Confidence Score:** Ratio of white spots to total image pixels
- **Classification Threshold:**
  - `> 5%` white spot ratio → **Cancerous**
  - `≤ 5%` white spot ratio → **Non-cancerous**

---

## Built With

- `SwiftUI`
- `CoreImage` for pixel manipulation
- `MapKit` for location and directions
- `ConfettiSwiftUI` for celebration animations

---

## Disclaimer
This app is not a diagnostic tool and should not replace medical advice. It is meant for educational and research purposes only. Consult a healthcare professional for clinical evaluations.

---

![wireframe](https://github.com/user-attachments/assets/16b3ebff-3ef2-4362-aa35-a63d93634581)

Made with 💙 using SwiftUI, CoreImage & MapKit


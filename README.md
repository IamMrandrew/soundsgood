<img src="https://user-images.githubusercontent.com/62586450/164196616-a10a9117-e6f9-4774-8c78-5bb3ff70161f.png" width="82" height="82">

# SoundsGood

Sounds are hard to understand and explain. SoundsGood allows musicians to understand their music scientifically. Also to strike the balance between analytical representation of sound and musician’s understandability. 🎵

Frequency, time, and timbre are the three main aspects of acoustics analysis in our application. With such division, we further developed more features under these aspects.

![soundsgood-ui-screenshots](https://user-images.githubusercontent.com/62586450/164189790-5ddf7047-675a-41cc-bba5-46796a111551.png)

## Highlights

- Various visualization of sound including frequency-domain, time-domain, and harmonics. ✨
- Describe your sound with a simple and intuitive interface. 📝
- Intergrated with Watch app and adaption for iPad. 📱

## Requirement

### Development Environment:

- Xcode 13
- Swift 5

### Deployment Target:

- Any model of iPhone with iOS 14+
- Any model of iPad with iPadOS 15+
- Any model of Apple Watch with watchOS 14+

## Getting Started

Clone the repository on command line or on Xcode.

### AudioKit

We originally used Apple’s official framework `AVFoundation` for audio data capturing and manipulation, but we found that this package requires verbose code to implement simple functions.

Therefore, we need to seek a reliable alternative to solve this problem. That is why the [AudioKit](https://github.com/AudioKit/AudioKit) collection is introduced in SoundsGood.

### Design Pattern

SwiftUI with MVVM. With the property wrapper provided by SwiftUI and Combine, we can easily build relations between View and ViewModel with less code.

We keep our logic in `ViewModel`, and UI related in `View`. The concepts of parent View Model and child View Model is also implemented.

We keep a clean file structure by features. Core functions are in the `Core` folder.

```
.
├── README.md
├── visualizer
│   ├── AudioData
│   ├── Core
│   │   ├── Audio
│   │   │   ├── ViewModels
│   │   │   │   └── AudioViewModel.swift
│   │   │   └── Views
│   │   │       ├── PitchView.swift
│   │   │       ├── SoundView.swift
│   │   │       └── TimbreView.swift
│   │   ├── Components
│   │   │   ├── Buttons
│   │   │   │   └── SettingButton.swift
│   │   │   └── Components here ...
│   │   ├── ContentView.swift
│   │   └── Features here with ViewModels and Views ...
│   ├── Extensions
│   ├── Helpers
│   ├── Models
│   │   ├── Audio.swift
│   │   ├── Models here ...
│   ├── WatchConnectivityViewModel.swift
│   └── visualizerApp.swift

```

## Contributing

Feel free to open a new issue or pull request. Conventional commits are encouraged.

Read the [CONTRIBUTING.md](CONTRIBUTING.md) file for more information.

If you are interesting in beta testing, you may take a look of the [TestFlight beta](https://testflight.apple.com/join/lAWvlIUB).

For extracting frequency data from sound samples, read [SCRIPTS.md](SCRIPTS.md).

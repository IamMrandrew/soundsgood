# Contributing to the Project

Thanks for your interest in contributing to the project. We treat issues as tasks, and we use the GitHub Project for managing our development workflow.

## Getting started

We stated some background of our project in the [README.md](README.md) file, and we hope that you understand the purpose and features from my report and my [Medium article](https://medium.com/computer-music-research-notes/你了解你演奏的聲音嗎-電腦如何輔助音樂人進步-7a88f9f5fb79).

We used SwiftUI and we followed the MVVM design pattern a lot. You need to understand how the views, view models, and model interact before coding anything.

You may also follow the official [SwiftUI Tutorial](https://developer.apple.com/tutorials/swiftui) from Apple to get started with SwiftUI. They did not followed MVVM strictly but they did use the Combine framework which is quite similar to us.

To learn more about MVVM, we recommend you to read the following articles and videos which I find useful:

> - https://www.youtube.com/c/SwiftfulThinking/featured
> - https://github.com/csefyp-cjc/cjc2101-visualizer/issues/12
> - https://www.swiftyplace.com/blog/swiftui-and-mvvm

## Learn the Codebase

The iOS and iPadOS part is inside `visualizer` folder, while other folders is for watchOS and tests. Everthing start from the `visualizerApp.swift` file.

**`Core`** folder is the core of the project. Each feature is in its own folder except `Components`. And each folder contains a `ViewModel` and a `View`. `AudioViewModel.swift` inside `Audio` is where the main business logic is stored. And everything screen starts from the `ContentView.swift` file.

**`Models`** folder contains all the models, which is the model in MVVM. `Audio` is the important one, and we apologized for the messy variables of it.

**`Core/Components`** folder contains all the components used in the project. For reusable components, we will pass in value instead of using the `@EnvironmentObject` property wrapper and retreive the value from the `ViewModel`.

**`Extensions`** folder are some constants for Colors and Typography used in the app. They are derived from the Design System in Figma. You may find them useful while using the modifier to style your UI.

**`AudioData`** folder contains the FFT results of the audio samples. They are extracted using `extract_fft_array.py` and `batch_process.sh`. You may find the details in the [SCRIPTS.md](SCRIPTS.md) file.

### AudioViewModel

AudioViewModwl is the core of handling the audio data, but it is hard to understand at the same time. We used the `AudioKit` framework to handle the audio data. You may find the details in the [AudioKit documentation](https://audiokit.io/documentation/audiokit/getting-started) and [SoundpipeAudioKit wiki](https://github.com/AudioKit/SoundpipeAudioKit/wiki).

We used the FFTTap and PitchTap, where you can see in the `setupAudioEngine` function. And `updateAmplitudes` and `updatePitch` are the two main functions in the DispatchQueue which you can think of these two functions are keep running.

## Commit Convention and Branching Strategy

### Commit

The codebase of this project is maintained in this
GitHub repository. To keep it clean for tracking changes, we adopted some ideas from AngularJS and applied them in our collaboration.

For example, `doc: add contributing guide in README.md`

You can find the [Commit Message Format](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#-commit-message-format) in their repository.

### Branching

For branching, we followed [GitHub Flow](https://www.youtube.com/watch?v=aJnFGMclhU8&t=301s). Best practice for small team collaboration. The notion of the GitHub flow is to branch by features.

Master/main branch is only for ready production ✨.

#### When to create a new branch:

- By issues, and try to focus only one work on one branch. For example, `feat/add-instrument-drawer` is a feature branch for adding the instrument drawer.

#### Once a feature on branch is completed:

1. Create a pull request on GitHub
2. Link the PR to issue (if suitable) to automatically close the issue when PR is merged
3. Request for reviews
4. If approved, Merge the pull request
5. Delete the feature branch

## Design File

We use Figma to design the project. The UI design is located in the `Prototype` tab inside Figma, which built from the small components inside the `Design System` tab.

Follow the [Figma file](https://www.figma.com/file/sNwfudIziEkHxhBjmbUyQp/SoundsGood?node-id=238%3A1406) and start building the user interface. You may often find the design frame linked in the issues.

## Issues

Leave an issue if you have any questions or suggestions. Remember to label the issue properly 😆.

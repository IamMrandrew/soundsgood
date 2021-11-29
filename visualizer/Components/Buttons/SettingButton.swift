//
//  SettingButton.swift
//  visualizer
//
//  Created by Andrew Li on 25/11/2021.
//

import SwiftUI

struct SettingButton: View {
//    @EnvironmentObject var settingViewModel: SettingViewModel
    @EnvironmentObject var audioViewModel: AudioViewModel
    let label: String
    let type: String
//    let selected: Bool
        
    var body: some View {
        Button {
//            settingViewModel.changeNoteRepresentationSetting(value: label)
            switch type {
            case "noteRepresentation":
                audioViewModel.changeNoteRepresentationSetting(value: Setting.NoteRepresentation(rawValue: label) ?? Setting.NoteRepresentation.sharp)
            case "noiseLevel":
                audioViewModel.changeNoiseLevelSetting(value: Setting.NoiseLevel(rawValue: label) ?? Setting.NoiseLevel.low)
            case "accuracyLevel":
                audioViewModel.changeAccuracyLevelSetting(value: Setting.AccuracyLevel(rawValue: label) ?? Setting.AccuracyLevel.practice)
            default:
                print("error")
            }
          
        } label: {
            Text(label)
                .font(type == "noteRepresentation" ? .label.medium : .label.xsmall)
                .foregroundColor(audioViewModel.settings.noteRepresentation == Setting.NoteRepresentation(rawValue: label) || audioViewModel.settings.noiseLevel == Setting.NoiseLevel(rawValue: label) || audioViewModel.settings.accuracyLevel == Setting.AccuracyLevel(rawValue: label) ? .foundation.onPrimary : .foundation.primary)
        }
        .padding(type == "noteRepresentation" ? EdgeInsets(top: 8, leading: 36, bottom: 8, trailing: 36) : EdgeInsets(top: 12, leading: 28, bottom: 12, trailing: 28))
        .background(audioViewModel.settings.noteRepresentation == Setting.NoteRepresentation(rawValue: label) || audioViewModel.settings.noiseLevel == Setting.NoiseLevel(rawValue: label) || audioViewModel.settings.accuracyLevel == Setting.AccuracyLevel(rawValue: label)  ? Color.foundation.primary : Color.background.bgSecondary)
        .cornerRadius(8)
    }
}

struct SettingButton_swift_Previews: PreviewProvider {
    static var previews: some View {
        SettingButton(label: Setting.NoteRepresentation.sharp.rawValue, type: "noteRepresentation")
//            .environmentObject(SettingViewModel())
            .environmentObject(AudioViewModel())
        
        SettingButton(label: Setting.NoiseLevel.medium.rawValue, type: "noiseLevel")
            .environmentObject(AudioViewModel())
    }
        
}

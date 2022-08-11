//
//  AudioViewModel.swift
//  visualizer
//
//  Created by Mark Cheng on 19/11/2021.
//
// ref: https://github.com/Matt54/AudioVisualizerAK5

import Foundation
import Combine
import AudioKit
import SoundpipeAudioKit

enum UpdateMode {
    case scroll
    case average
}

class AudioViewModel: ObservableObject {
    
    @Published var audio: Audio = Audio.default
    @Published var referenceHarmonicAmplitudes: [Double]
    
    // Variables for Audio Recording
    var isRecording: Bool = false
    private var timeCap: Int = -1 // the maximum size for the recorded amplitude, -1 means unlimited
    
    // Subscribed from child ViewModels
    @Published var settings: Setting = Setting.default
    
    @Published var timbreDrawer: TimbreDrawer = TimbreDrawer.default
    @Published var displayDrawer: DisplayDrawer = DisplayDrawer.default
    @Published var recordingAnalyticsDrawer: RecordingAnalyticsDrawer = RecordingAnalyticsDrawer.default
    
    // Child ViewModels
    private var cancellables = Set<AnyCancellable>()
    @Published var settingVM = SettingViewModel()
    
    @Published var timbreDrawerVM = TimbreDrawerViewModel()
    
    @Published var DisplayDrawerVM = DisplayDrawerViewModel()
    
    @Published var RecordingAnalyticsVM = RecordingAnalyticsDrawerViewModel()
    
    @Published var isStarted: Bool = false
    
    // AudioKit
    private let engine = AudioEngine()
    private var mic: AudioEngine.InputNode
    private let fftMixer: Mixer
    private let pitchMixer: Mixer
    private let silentMixer: Mixer
    private var taps: [BaseTap] = []
    private let FFT_SIZE = 2048
    private let SAMPLE_RATE: double_t = 44100
    private let outputLimiter: PeakLimiter
    
    
    init() {
        // TODO: test no microphone priviledge
        guard let input = engine.input else{
            fatalError()
        }
        
        self.mic = input
        self.fftMixer = Mixer(mic)
        self.pitchMixer = Mixer(fftMixer)
        self.silentMixer = Mixer(pitchMixer)
        self.outputLimiter = PeakLimiter(silentMixer)
        self.engine.output = outputLimiter
        
        self.referenceHarmonicAmplitudes = Array(repeating: 0.5, count: Audio.default.totalHarmonics)
        
        self.setupAudioEngine()
        self.addSubscribers()
        
        self.updateReferenceTimbre()
        
    }
    
    private func setupAudioEngine() {
        taps.append(FFTTap(fftMixer) { fftData in
            DispatchQueue.main.async {
                self.updateAmplitudes(fftData, mode: .scroll)
            }
        })
        taps.append(PitchTap(pitchMixer) { pitchFrequency, amplitude in
            DispatchQueue.main.async {
                self.updatePitch(pitchFrequency: pitchFrequency, amplitude: amplitude)
            }
        })
        
        self.toggle()
        silentMixer.volume = 0.0
    }
    
    // Add subscriptions from child ViewModels
    private func addSubscribers() {
        settingVM.$settings.sink { [weak self] (returnedSettings) in
            self?.settings = returnedSettings
        }
        .store(in: &cancellables)
        
        timbreDrawerVM.$timbreDrawer.sink { [weak self] (returnedTimbreDrawer) in
            self?.timbreDrawer = returnedTimbreDrawer
        }
        .store(in: &cancellables)
    }
    
    // Audio Engine functions
    func start() {
        do {
            try engine.start()
            taps.forEach { tap in
                tap.start()
            }
        } catch {
            assert(false, error.localizedDescription)
        }
        self.isStarted = true
    }
    
    func stop() {
        engine.stop()
        taps.forEach { tap in
            tap.stop()
        }
        self.isStarted = false
    }
    
    func toggle() {
        if (self.isStarted) {
            self.stop()
        } else {
            self.start()
        }
    }
    
    func getPitchIndicatorPosition() -> Int {
        switch audio.pitchDetune {
        case let cent where cent < 0:
            return 4 - Int(abs(audio.pitchDetune) / 12.5)
        case let cent where cent > 0:
            return Int(audio.pitchDetune / 12.5) + 4
        case let cent where cent == 0:
            return 4
        default:
            return 4
        }
    }
    
    private func updateIsPitchAccurate() {
        let position = getPitchIndicatorPosition()
        var accuracyPoint: [Int] {
            switch self.settings.accuracyLevel {
            case .tuning:
                return [4]
            case .practice:
                return [3, 4, 5]
            }
        }
        
        audio.isPitchAccurate = accuracyPoint.contains(position)
    }
    
    // PitchTap functions
    private func updatePitch( pitchFrequency: [Float], amplitude: [Float]) {
        var noiseThreshold: Float = 0.05
        
        switch self.settings.noiseLevel {
        case .low:
            noiseThreshold = 0.05
        case .medium:
            noiseThreshold = 0.1
        case .high:
            noiseThreshold = 0.5
        }
        
        // TODO: May consider for headphone input (L/R channel)
        if (amplitude[0] > noiseThreshold) {
            // amplitude is larger than threshold, update pitch
            self.audio.pitchFrequency = pitchFrequency[0]
            self.audio.pitchNotation = pitchFromFrequency(pitchFrequency[0], self.settings.noteRepresentation)
            self.audio.pitchDetune = pitchDetuneFromFrequency(pitchFrequency[0])
            self.audio.peakBarIndex = Int(pitchFrequency[0] * Float(self.FFT_SIZE) / Float(self.SAMPLE_RATE))
            //            print("🔖 Pitch Detune (Cent)   \(audio.pitchDetune)")
            
            // TODO: maybe only compute these values when current view is timbre view
            // update harmonicAmplitudes
            let hamonics = getHarmonics(fundamental: pitchFrequency[0], n: self.audio.totalHarmonics) //TODO: adjustable n
            for (index, harmonic) in hamonics.enumerated() {
                let harmonicIndex = Int(harmonic * Float(self.FFT_SIZE) / Float(self.SAMPLE_RATE))
                if (harmonicIndex > 255) {
                    self.audio.harmonicAmplitudes[index] = 0
                }else{
                    self.audio.harmonicAmplitudes[index] = self.audio.amplitudes[Int(harmonic * Float(self.FFT_SIZE) / Float(self.SAMPLE_RATE))]
                }
            }
            
            // update amplitudesToDisplay
            self.audio.amplitudesToDisplay = self.audio.amplitudes
            
            // Get the amplitude of fundamental frequency (1st harmonic)
            let fundFreqAmp = self.audio.harmonicAmplitudes[0]
            
            // Keep only the Significant Harmonics
            let significantHarmonics = self.audio.harmonicAmplitudes.filter { freq in
                return freq > Double(noiseThreshold)
            }
        
            // Update audio features
            self.updateSpectralCentroid()
            self.updateQuality(fundFreq: fundFreqAmp, significantHarmonics: significantHarmonics)
        }
        // update the last captured amplitude
        self.audio.lastAmplitude = Double(amplitude[0])
            
        self.updateReferenceTimbre()
        self.updateIsPitchAccurate()
    }
    
    // FTTTap functions
    private func updateAmplitudes(_ fftData: [Float], mode: UpdateMode) {
        let binSize = 30
        var bin = Array(repeating: 0.0, count: self.audio.amplitudes.count) // stores amplitude sum
        
        for i in stride (from : 0, to: self.FFT_SIZE - 1, by: 2) {
            let real = fftData[i]
            let imaginary = fftData[i+1]
            
            let normalizedMagnitude = 2.0 * sqrt(pow(real, 2) + pow(imaginary, 2)) / Float(self.FFT_SIZE)
            let amplitude = Double(20.0 * log10(normalizedMagnitude))
            let scaledAmplitude = (amplitude + 250) / 229.80
            
            if (mode == .average) {
                // simple explaination
                // bin[0] = sum(fftData[0:n-1])/n
                if (i/binSize < self.audio.amplitudes.count) {
                    bin[i/binSize] = bin[i/binSize] + restrict(value: scaledAmplitude)
                }
                
                DispatchQueue.main.async {
                    if (i%binSize == 0 && i/binSize < self.audio.amplitudes.count) {
                        self.audio.amplitudes[i/binSize] = bin[i/binSize] / Double(binSize)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if (i/2 < self.audio.amplitudes.count) {
                        let mappedAmplitude = self.map(n: scaledAmplitude, start1: 0.3, stop1: 0.9, start2: 0.0, stop2: 1.0)
                        self.audio.amplitudes[i/2] = self.restrict(value: mappedAmplitude)
                    }
                }
            }
        }
    }
    
    private func getSoundSample() -> [Double] {
        switch self.timbreDrawer.selected {
        case .cello:
            return cello[pitchFromFrequency(self.audio.pitchFrequency, Setting.NoteRepresentation.sharp)] ?? []
        case .flute:
            return flute[pitchFromFrequency(self.audio.pitchFrequency, Setting.NoteRepresentation.sharp)] ?? []
        case .violin:
            return violin[pitchFromFrequency(self.audio.pitchFrequency, Setting.NoteRepresentation.sharp)] ?? []
        default:
            return cello[pitchFromFrequency(self.audio.pitchFrequency, Setting.NoteRepresentation.sharp)] ?? []
        }
    }
    
    func updateReferenceTimbre() {
        var soundSampleFFTData: [Double] = getSoundSample()
        
        if (!soundSampleFFTData.isEmpty) {
            
            //          Normalize by dividing the max so that it will cap to 1
            //          Re-scaling by multiplying constant
            let maxAmplitude: Double = soundSampleFFTData.max()!
            
            guard maxAmplitude > 0 else {
                return
            }
            
            for (i, amplitude) in soundSampleFFTData.enumerated() {
                let normalizedAmplitude = amplitude / maxAmplitude
                let amplitudeIndB = Double(20.0 * log10(normalizedAmplitude))
                soundSampleFFTData[i] = (amplitudeIndB * 4 + 250) / 229.80
            }
            
            let hamonics = getHarmonics(fundamental: mapNearestFrequency(self.audio.pitchFrequency), n: self.audio.totalHarmonics) //TODO: adjustable n
            for (index, harmonic) in hamonics.enumerated() {
                let harmonicIndex = Int(harmonic*2048/44100)
                if(harmonicIndex > 255){
                    self.referenceHarmonicAmplitudes[index] = 0
                }else{
                    self.referenceHarmonicAmplitudes[index] = soundSampleFFTData[Int(harmonic*2048/44100)]
                    
                }
            }
//            print("Ref\(self.referenceHarmonicAmplitudes)")
//            print("User\(self.audio.harmonicAmplitudes)")
        }
    }
    
    // TODO: modify this mapping for our visualization
    private func map(n: Double, start1: Double, stop1: Double, start2: Double, stop2: Double) -> Double {
        return ((n-start1)/(stop1-start1)) * (stop2-start2) + start2
    }
    
    private func restrict(value: Double) -> Double {
        if (value < 0.0) {
            return 0
        }
        if (value > 1.0) {
            return 1.0
        }
        return value
    }
    
    private func getHarmonics(fundamental: Float, n: Int) -> [Float] {
        var harmonics: [Float] = Array(repeating: 0.0, count:n)
        for i in (1...n) {
            harmonics[i-1] = fundamental * Float(i)
        }
        return harmonics
    }
    
    //
    // Audio Features
    //
    
    private func updateSpectralCentroid() {
        let weightedFrequenciesSum: Double = self.audio.amplitudes.enumerated().reduce(0, { acc, cur in
            return acc + Double(cur.0) * self.SAMPLE_RATE / Double(self.FFT_SIZE) * cur.1  // cur.0: index, cur.1: amplitude
        })
        
        let amplitudeSum: Double = self.audio.amplitudes.reduce(0, { acc, cur in
            return acc + cur
        })
        
        guard amplitudeSum > 0 else {
            return
        }
        
        let spectralCentroid = weightedFrequenciesSum / amplitudeSum
        
        // Lavengood considers spectral centroids above 1100Hz bright and anything below dark.
        // Some studies shows that we can calculate the unitless Adjusted Centroid as measurement, regarless of pitch
        // Map to [0, 1]
        
        let threshold: Double = 1100
        
        let scaling: Double = 100
        let moderator: Double = 70
        let denominator: Double = 115
        
        let result = ((spectralCentroid / threshold) * scaling - moderator) / denominator
        self.audio.audioFeatures.spectralCentroid = result > 1 ? 1 : result
        self.audio.audioFeatures.spectralCentroid = result < 0 ? 0 : self.audio.audioFeatures.spectralCentroid
    }
    
    private func updateQuality(fundFreq: Double, significantHarmonics: [Double]) {
        let totalNum = significantHarmonics.dropFirst().count
        
        // Count the number of harmonics which amplitude is larger than the fundamental one
        // Consider as hollow if other partials is louder than fundamental frequency
        let louderNum = significantHarmonics.dropFirst().reduce(0, { acc, cur in
            return cur > fundFreq ? acc + 1 : acc
        })
        
        guard totalNum > 0 else {
            return
        }
        // Calculate the quality by mapping it to [0, 1]
        self.audio.audioFeatures.quality = Double(totalNum - louderNum) / Double(totalNum)
    }
    
    func switchCaptureTime(){
//        let options:Array<Int> = [1, 3, 5, 10]
//        let i = options.firstIndex(of:self.audio.captureTime)!
//        if(i == options.count-1){
//            self.audio.captureTime = options[0]
//        }else{
//            self.audio.captureTime = options[i+1]
//        }
        
        self.audio.captureTime = 10 // fix the captured time as 10s
    }

    //
    // Audio Recording
    //
    
    func addRecordingData() {
        if (self.isRecording) {
            if ((self.timeCap == -1) || (self.audio.audioRecording.recording.count < self.timeCap)) { // Stop the recording if recording reached its max size
                self.audio.audioRecording.recording.append(RecordingData(amplitude: self.audio.lastAmplitude,
                                                                         pitchFrequency: Double(self.audio.pitchFrequency),
                                                                         pitchDetune: Double(self.audio.pitchDetune))
                )
            } else {
                self.endRecording()
            }
        }
    }
    
    func toggleRecording() {
        if (self.isRecording){
            self.endRecording()
        } else {
            self.startRecording()
        }
    }
    
    private func startRecording() {
        self.isRecording = true
        
        // Reset the stored recording
        self.audio.audioRecording.recording = []
        
        // Reset splitted note indices array
        self.audio.audioRecording.splittedNoteIndices = []
    }
    
    private func endRecording() {
        self.isRecording = false
    }
    
    // Created by John Yeung 20/07/2022
    
    func splitRecording() {
        let data: [RecordingData] = self.audio.audioRecording.recording
        let percentage: Double = 0.1
        let durationInSec: Double = 10.0
        let maxAmp: Double = data.map { $0.amplitude } .max() ?? 0.0 // data.max returns optional, set 0.0 as default value
        let ampThreshold: Double = maxAmp * percentage
        
        self.audio.audioRecording.splittedRecording = splitAudioBySilenceWithAmplitude(data: data,
                                                                                 ampThreshold: ampThreshold,
                                                                                 durationInSec: durationInSec)
    }
    
    // Created by John Yeung 20/07/2022
    // Refactored by Andrew LiC
    
    func splitAudioBySilenceWithAmplitude(data: Array<RecordingData>, ampThreshold: Double, durationInSec: Double) -> [[RecordingData]] {
        let durationInSamp: Int = Int(durationInSec * SAMPLE_RATE)  // length of the audio
        
        var continSilentSamp: Int = 0
        var splitPtFound: Bool = false                      // is a silent amplitude found?
        
        let ignoreTimeThreshold: Int = 0                    // min bin length for non-silence data to be added into the return array
        var splittedAudio = [[RecordingData]]()             // the returned audio, contain slices of input data, cut according to slience data in between
        
        var remainingData: Array<RecordingData> = data             // data is immutable, need to make a copy
        
        // Starting position of a note
        var index: Int = 0
        
        // SPLITTING ALGORITHM (Consider silent point with amplitude threshold only)
        // i is the position of the first silent point of the remaining recording array
        // The head of RemainingData should be the start of a note after first split
        // We look for a silent point first, and look for another non-continuous silent point (A note is in between)
        // We stored each note array into a array, making an array of array for the whole melody with each note as an array element
        
        // reference to https://developer.apple.com/documentation/swift/arrayslice
        while let i = remainingData.firstIndex(where: { abs($0.amplitude) < ampThreshold }) { // while there is a silent point in the remaining data
            splitPtFound = true                                 // mark that a Silent data was found ( do we need this?
            continSilentSamp += 1                               // count of amplitude data less then the threshold
            
            if (i > ignoreTimeThreshold) {    // if 2 silent pts are seperated at least ignoreTimeThreshold indices away
                // Append the head till i (first silent point in remaining)
                splittedAudio.append(Array(remainingData[..<i]))   // That's the note we want!
                
                // To be able to scroll on Note, we should mark down the indices
                self.audio.audioRecording.splittedNoteIndices.append(index + 1)
                index += i // Keep track of the index of recording (1D array)
            } else {
                index += 1 // Keep track of the index of srecordedAmplitude (1D array)
            }
            
            remainingData = Array(remainingData[(i + 1)...])  // keep only with the remaining ampitude data
        }
        
        return splittedAudio
        
    }
    
// reference to this https://github.com/CUHK-CMD/cmd-splitter/blob/master/Source/Splitter.h
//    // MARK: DSP related
//
//        // 1. Split audio by silence
//        // splitAudioBySilenceWithAmplitude: ampThreshold as parameter directly
//        // splitAudioBySilence: ampThreshold will be calculated from the percentage parameter
//
//        // ampThreshold: consider amplitude within this value to be silence
//        // durationInSec: split if silence persist equal to or longer than this value
//
//        void splitAudioBySilenceWithAmplitude(std::unique_ptr<float[]> &data, float ampThreshold, float durationInSec)
//        {
//            int durationInSamp = static_cast<int>(durationInSec * sampRate);
//
//            int continSilentSamp = 0;
//            bool splitPtFound = false;
//
//            for (int pos = 0; pos < nSamples; pos++)
//            {
//                if (fabs(data[pos]) < ampThreshold)
//                    continSilentSamp++;
//                else
//                {
//                    continSilentSamp = 0;
//                    if (splitPtFound == true)
//                        splitPtFound = false;
//                }
//                if (continSilentSamp == durationInSamp && splitPtFound == false)
//                {
//                    printf("Split point: %.6f at %.2f\n", data[pos], static_cast<float>(pos) / sampRate);
//                    splitPtFound = true;
//                }
//            }
//        }

    
//        void splitAudioBySilence(std::unique_ptr<float[]> &data, float percentage, float durationInSec)
//        {
//            int durationInSamp = static_cast<int>(durationInSec * sampRate);
//            float maxAmp = getMaxAmplitude(data);
//            float ampThreshold = maxAmp * percentage;
//
//            int continSilentSamp = 0;
//            bool splitPtFound = false;
//
//            for (int pos = 0; pos < nSamples; pos++)
//            {
//                if (fabs(data[pos]) < ampThreshold)
//                    continSilentSamp++;
//                else
//                {
//                    continSilentSamp = 0;
//                    if (splitPtFound == true)
//                        splitPtFound = false;
//                }
//                if (continSilentSamp == durationInSamp && splitPtFound == false)
//                {
//                    printf("Split point: %.6f at %.2f\n", data[pos], static_cast<float>(pos) / sampRate);
//                    splitPtFound = true;
//                }
//            }
//        }

    
//
//        // Return the absolute value of the maximum amplitude
//        float getMaxAmplitude(std::unique_ptr<float[]> &data)
//        {
//            float maxAmp = data[0];
//            for (int pos = 1; pos < nSamples; pos++)
//            {
//                float ampAtPos = fabs(data[pos]);
//                if (ampAtPos > maxAmp)
//                {
//                    maxAmp = ampAtPos;
//                }
//            }
//            return maxAmp;
//        }
//
//        // 2. Split audio by pitch difference
//
//        void splitAudioByFreq(std::unique_ptr<float[]> &data)
//        {
//            int fftResolution = 12;
//            std::string prevNote = "NULL";
//            std::string currNote;
//            for (int leftPosition = 0;; leftPosition += 1 << (fftResolution-1))
//            {
//                if (leftPosition + (1 << fftResolution) > nSamples)
//                {
//                    break;
//                }
//
//                // Apply cepstrum
//                std::unique_ptr<FFTCalc> fftItem = std::make_unique<FFTCalc>(data.get() + leftPosition, fftResolution);
//                fftItem->initHammingWindow();
//                fftItem->applyHammingWindow();
//                fftItem->transformToCepstrum();
//
//                // Compare note change
//                int invFrequency = fftItem->findMaxBinInCepstrum();
//                currNote = convertFreqToNote(invFrequency);
//                printf("%s\n", currNote.c_str());
//    //                DBOUT(std::to_string(invFrequency) + " " + noteName + "\n");
//
//                if (currNote.compare(prevNote) != 0)
//                {
//                    printf("Split point: %.6f at %.2f\n", data[leftPosition], static_cast<float>(leftPosition) / sampRate);
//                    prevNote.assign(currNote);
//                }
//
//            }
//        }
    // TODO: NOT FINISHED
    // requires raw audio data as input
    func splitAudioByFreq(data: Array<Float>, nSamples: Int)->Void{
        let fftResolution: Int = 12
        var preNote: String = "NULL"
        var currNote: String
        var leftPosition: Int = 0
        while (!((leftPosition + (1 << fftResolution)) > nSamples)){ // while not out of bound
            
            
            
            leftPosition = leftPosition + (1 << (fftResolution-1))
        }
    }
//
//        // the noteID of A4 is 69
//        std::string convertFreqToNote(int invFrequency)
//        {
//            std::string notes[] = {"A", "Bb", "B", "C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab"};
//            float frequency = (float) sampRate / (float) invFrequency;
//
//            int noteID = 69 + (int)round(12.0f * std::log2(frequency / 440.0f));
//            int octave = noteID / 12 - 1;
//
//            return notes[(noteID + 3) % 12] + std::to_string(octave);
//        }
    

    
    
}

//
//  MockDelegate.swift
//  BcadSimpleMusicAppTests
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import Foundation
@testable import BcadSimpleMusicApp

final class MockDelegate: MusicViewModelDelegate {
    var updateSongsCalled = false
    var updatePlayingStateCalled = false
    var updateLoadingStateCalled = false
    var encounterErrorCalled = false
    var startPlayingMusicCalled = false
    var updateCurrentSongCalled = false
    var sliderControllerCalled = false
    var currentTime: Double?
    var duration: Double?
    
    func viewModelDidUpdateSongs(_ viewModel: MusicViewModel) {
        updateSongsCalled = true
    }
    
    func viewModelDidUpdatePlayingState(_ viewModel: MusicViewModel) {
        updatePlayingStateCalled = true
    }
    
    func viewModelDidUpdateLoadingState(_ viewModel: MusicViewModel) {
        updateLoadingStateCalled = true
    }
    
    func viewModelDidEncounterError(_ viewModel: MusicViewModel, error: Error) {
        encounterErrorCalled = true
    }
    
    func viewModelDidStartPlayingMusic(_ viewModel: MusicViewModel) {
        startPlayingMusicCalled = true
    }
    
    func viewModelDidUpdateCurrentSong(_ viewModel: MusicViewModel) {
        updateCurrentSongCalled = true
    }
    
    func viewModelDidUpdatePlayerProgress(_ viewModel: MusicViewModel, currentTime: Double, duration: Double) {
        sliderControllerCalled = true
        self.currentTime = currentTime
        self.duration = duration
    }
}

//
//  MusicViewModelTests.swift
//  BcadSimpleMusicAppTests
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import XCTest
@testable import BcadSimpleMusicApp

final class MusicViewModelTests: XCTestCase {
    var viewModel: MusicViewModel!
    var mockAPIService: MockAPIService!
    var mockDelegate: MockDelegate!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = MusicViewModel(networkService: mockAPIService)
        mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
    }
    
    func testSearchSongsSuccess() {
        let expectation = self.expectation(description: "Search songs")
        
        let testSongs = [Song(id: 123, title: "Test Song", artist: "Test Artist", previewUrl: "https://example.com/preview", artworkUrl: "https://example.com/artwork", collectionName: "Test Collection")]
        mockAPIService.searchSongsResult = .success(testSongs)
        
        viewModel.searchSongs(query: "test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(self.mockDelegate.updateLoadingStateCalled)
            XCTAssertTrue(self.mockDelegate.updateSongsCalled)
            XCTAssertEqual(self.viewModel.songs, testSongs)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSelectSong() {
        let testSongs = [
            Song(id: 1, title: "Song 1", artist: "Artist 1", previewUrl: "https://example.com/1", artworkUrl: "https://example.com/art1", collectionName: "Collection Name 1"),
            Song(id: 2, title: "Song 2", artist: "Artist 2", previewUrl: "https://example.com/2", artworkUrl: "https://example.com/art2", collectionName: "Collection Name 2")
        ]
        viewModel.setSongs(testSongs)
        
        viewModel.selectSong(at: 1)
        
        XCTAssertEqual(viewModel.currentSongIndex, 1)
        XCTAssertTrue(viewModel.isPlaying)
        XCTAssertTrue(mockDelegate.startPlayingMusicCalled)
        XCTAssertTrue(mockDelegate.updateCurrentSongCalled)
    }
    
    func testNextSong() {
        let testSongs = [
            Song(id: 1, title: "Song 1", artist: "Artist 1", previewUrl: "https://example.com/1", artworkUrl: "https://example.com/art1", collectionName: "Collection Name 1"),
            Song(id: 2, title: "Song 2", artist: "Artist 2", previewUrl: "https://example.com/2", artworkUrl: "https://example.com/art2", collectionName: "Collection Name 2")
        ]
        viewModel.setSongs(testSongs)
        viewModel.selectSong(at: 0)
        
        viewModel.nextSong()
        
        XCTAssertEqual(viewModel.currentSongIndex, 1)
        XCTAssertTrue(mockDelegate.startPlayingMusicCalled)
        XCTAssertTrue(mockDelegate.updateCurrentSongCalled)
    }
    
    func testPreviousSong() {
        let testSongs = [
            Song(id: 1, title: "Song 1", artist: "Artist 1", previewUrl: "https://example.com/1", artworkUrl: "https://example.com/art1", collectionName: "Collection Name 1"),
            Song(id: 2, title: "Song 2", artist: "Artist 2", previewUrl: "https://example.com/2", artworkUrl: "https://example.com/art2", collectionName: "Collection Name 2")
        ]
        viewModel.setSongs(testSongs)
        viewModel.selectSong(at: 1)
        
        viewModel.previousSong()
        
        XCTAssertEqual(viewModel.currentSongIndex, 0)
        XCTAssertTrue(mockDelegate.startPlayingMusicCalled)
        XCTAssertTrue(mockDelegate.updateCurrentSongCalled)
    }

}

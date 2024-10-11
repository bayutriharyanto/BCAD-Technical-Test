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

}

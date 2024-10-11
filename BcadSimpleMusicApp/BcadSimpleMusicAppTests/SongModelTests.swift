//
//  SongModelTests.swift
//  BcadSimpleMusicAppTests
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import XCTest
@testable import BcadSimpleMusicApp

final class SongModelTests: XCTestCase {

    func testSongInitialization() {
        let song = Song(id: 123, title: "Test Song", artist: "Test Artist", previewUrl: "https://example.com/preview", artworkUrl: "https://example.com/artwork", collectionName: "Test Collection")
        
        XCTAssertEqual(song.id, 123)
        XCTAssertEqual(song.title, "Test Song")
        XCTAssertEqual(song.artist, "Test Artist")
        XCTAssertEqual(song.previewUrl, "https://example.com/preview")
        XCTAssertEqual(song.artworkUrl, "https://example.com/artwork")
    }

}

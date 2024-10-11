//
//  SongModel.swift
//  BcadSimpleMusicApp
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import Foundation

struct ITunesSearchResponse: Codable {
    let results: [ITunesTrack]
}

struct ITunesTrack: Codable {
    let trackId: Int64
    let trackName: String
    let artistName: String
    let previewUrl: String
    let artworkUrl100: String
    let collectionName: String
}

struct Song: Identifiable, Equatable {
    let id: Int64
    let title: String
    let artist: String
    let previewUrl: String
    let artworkUrl: String
    let collectionName: String
}

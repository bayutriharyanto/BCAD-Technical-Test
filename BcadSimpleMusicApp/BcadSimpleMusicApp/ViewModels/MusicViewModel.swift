//
//  MusicViewModel.swift
//  BcadSimpleMusicApp
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import Foundation
import AVFoundation
import UIKit

protocol MusicViewModelDelegate: AnyObject {
    func viewModelDidUpdateSongs(_ viewModel: MusicViewModel)
}

class MusicViewModel {
    weak var delegate: MusicViewModelDelegate?
    
    private(set) var songs: [Song] = [] {
        didSet {
            delegate?.viewModelDidUpdateSongs(self)
        }
    }
    
    private var searchWorkItem: DispatchWorkItem?
    var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    deinit {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    private func performSearch(query: String) {
        
        
        networkService.request(term: query) { [weak self] result in
            guard let self = self else { return }
            
            
            
            switch result {
            case .success(let songs):
                self.songs = songs
            case .failure(let error):
                self.songs = []
            }
        }
    }
    
    
    
    func searchSongs(query: String) {
        // Cancel the previous work item if it hasn't started yet
        searchWorkItem?.cancel()
        
        // If the query is empty, clear the results immediately
        if query.isEmpty {
            songs = []
            return
        }
        
        // Create a new work item
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: query)
        }
        
        // Save the new work item and dispatch it after a delay
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }
    
    
}

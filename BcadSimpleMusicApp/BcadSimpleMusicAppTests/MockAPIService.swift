//
//  MockAPIService.swift
//  BcadSimpleMusicAppTests
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import Foundation
@testable import BcadSimpleMusicApp

final class MockAPIService: NetworkService {
    var searchSongsResult: Result<[Song], APIError>?
    
    override func request(term: String, completion: @escaping (Result<[Song], APIError>) -> Void) {
        if let result = searchSongsResult {
            completion(result)
        }
    }
}

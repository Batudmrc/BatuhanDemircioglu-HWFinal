//
//  SearchResult.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import Foundation

// MARK: - SearchResult
public struct SearchResult: Codable {
    public let resultCount: Int?
    public let results: [Track]?

    public init(resultCount: Int?, results: [Track]?) {
        self.resultCount = resultCount
        self.results = results
    }
}

// MARK: - Result
public struct Track: Codable {
    public let trackId: Int?
    public let kind: String?
    public let artistName: String?
    public let collectionName: String?
    public let trackName: String?
    public let collectionCensoredName: String?
    public let artworkUrl100: String?
    public let collectionPrice: Double?
    public let trackPrice: Double?
    public let primaryGenreName: String?
    public let previewUrl: String?
    public let wrapperType: String?
    public let trackViewUrl: String?
    
    

    enum CodingKeys: String, CodingKey {
        case artistName, collectionName, trackName, collectionCensoredName, artworkUrl100, collectionPrice, trackPrice, primaryGenreName, previewUrl, wrapperType, trackId, kind, trackViewUrl
    }

    public init(artistName: String?, collectionName: String?, trackName: String?, collectionCensoredName: String?, artworkUrl100: String?, collectionPrice: Double?, trackPrice: Double?, primaryGenreName: String?, previewUrl: String?, wrapperType: String?, trackId: Int?, kind: String?, trackViewUrl: String?) {
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackName = trackName
        self.collectionCensoredName = collectionCensoredName
        self.artworkUrl100 = artworkUrl100
        self.collectionPrice = collectionPrice
        self.trackPrice = trackPrice
        self.primaryGenreName = primaryGenreName
        self.previewUrl = previewUrl
        self.wrapperType = wrapperType
        self.trackId = trackId
        self.kind = kind
        self.trackViewUrl = trackViewUrl
    }
}

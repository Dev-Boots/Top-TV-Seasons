//
//  Series.swift
//  Best Seasons List
//
//  Created by Andy Almanza on 9/18/18.
//  Copyright © 2018 Andy Almanza. All rights reserved.
//

import Foundation

struct Genre: Decodable {
    let name: String
}

struct Series: Decodable {
    let artistName: String
    let name: String
    let releaseDate: String
    let kind: String
    let artworkUrl100: String
    //let genres: [Genre] //comment out for now
}

struct FeedData: Decodable {
    let results: [Series]
}
struct Feed: Decodable {
    let feed: FeedData
}

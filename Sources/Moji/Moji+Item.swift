//
//  File.swift
//  
//
//  Created by Ethan Lipnik on 6/9/21.
//

import Foundation

extension Moji {
    public struct Item: Codable, Hashable {
        public var guid, link, title, description, pubDate, encoded: String?
    }
}

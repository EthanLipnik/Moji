//
//  File.swift
//  
//
//  Created by Ethan Lipnik on 6/9/21.
//

import Foundation

extension Moji {
    public struct Item: Codable, Hashable, Equatable {
        public var guid, title, description, pubDate, content: String?
        public var link: URL?
        
        public init(guid: String? = nil, title: String? = nil, description: String? = nil, pubDate: String? = nil, content: String? = nil, link: URL? = nil) {
            self.guid = guid
            self.title = title
            self.description = description
            self.pubDate = pubDate
            self.content = content
            self.link = link
        }
        
        private enum CodingKeys: String, CodingKey {
            case guid
            case link
            case title
            case description
            case pubDate
            case content
            case encoded
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.guid = try? container.decode(String.self, forKey: .guid)
            self.link = try? container.decode(URL.self, forKey: .link)
            self.title = try? container.decode(String.self, forKey: .title)
            self.description = try? container.decode(String.self, forKey: .description)
            self.pubDate = try? container.decode(String.self, forKey: .pubDate)
            self.content = (try? container.decode(String.self, forKey: .content)) ?? (try? container.decode(String.self, forKey: .encoded))
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try? container.encode(guid, forKey: .guid)
            try? container.encode(link, forKey: .link)
            try? container.encode(title, forKey: .title)
            try? container.encode(description, forKey: .description)
            try? container.encode(pubDate, forKey: .pubDate)
            try? container.encode(content, forKey: .content)
        }
    }
}

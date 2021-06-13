//
//  Moji+Item.swift
//  
//
//  Created by Ethan Lipnik on 6/9/21.
//

import Foundation

extension Moji {
    open class Item: Codable, Hashable, Equatable {
        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }
        public static func == (lhs: Moji.Item, rhs: Moji.Item) -> Bool {
            return lhs.guid == rhs.guid && lhs.title == rhs.title && lhs.description == rhs.description && lhs.content == rhs.content && lhs.pubDate == rhs.pubDate && lhs.link == rhs.link
        }
        
        public var guid, title, description, content: String?
        public var pubDate: Date?
        public var link: URL?
        
        public init(guid: String? = nil, title: String? = nil, description: String? = nil, pubDate: Date? = nil, content: String? = nil, link: URL? = nil) {
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
        
        required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.guid = try? container.decode(String.self, forKey: .guid)
            self.link = (try? container.decode(URL.self, forKey: .link)) ?? (try? container.decode(Link.self, forKey: .link).href)
            self.title = try? container.decode(String.self, forKey: .title)
            self.description = try? container.decode(String.self, forKey: .description)
            self.content = (try? container.decode(String.self, forKey: .content)) ?? (try? container.decode(String.self, forKey: .encoded))
            
            if let pubDateStr = try? container.decode(String.self, forKey: .pubDate) {
                self.pubDate = RFC822DateFormatter().date(from: pubDateStr) ??
                (RFC3339DateFormatter().date(from: pubDateStr) ??
                ISO8601DateFormatter().date(from: pubDateStr))
            }
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

//
//  File.swift
//  
//
//  Created by Ethan Lipnik on 6/9/21.
//

import Foundation

extension Moji {
    public struct RSS: Codable, Hashable {
        public var title, description, language, managingEditor, webMaster, pubDate, lastBuildDate, generator, docs, rating: String?
        public var link: URL?
        public var ttl: Int?
        public var items: [Item]?
        
        private enum CodingKeys: String, CodingKey {
            case title
            case link
            case description
            case language
            case managingEditor
            case webMaster
            case pubDate
            case lastBuildDate
            case generator
            case docs
            case rating
            case ttl
            case items = "item"
            case entries = "entry"
            
            case channel
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let channel = try? container.decode(RSS.self, forKey: .channel)

            self.title = channel?.title ?? (try? container.decode(String.self, forKey: .title))
            self.link = channel?.link ?? (try? container.decode(URL.self, forKey: .link)) ?? (try? container.decode(Link.self, forKey: .link).href)
            self.description = channel?.description ?? (try? container.decode(String.self, forKey: .description))
            self.language = channel?.language ?? (try? container.decode(String.self, forKey: .language))
            self.managingEditor = channel?.managingEditor ?? (try? container.decode(String.self, forKey: .managingEditor))
            self.webMaster = channel?.webMaster ?? (try? container.decode(String.self, forKey: .webMaster))
            self.pubDate = channel?.pubDate ?? (try? container.decode(String.self, forKey: .pubDate))
            self.lastBuildDate = channel?.lastBuildDate ?? (try? container.decode(String.self, forKey: .lastBuildDate))
            self.generator = channel?.generator ?? (try? container.decode(String.self, forKey: .generator))
            self.docs = channel?.docs ?? (try? container.decode(String.self, forKey: .docs))
            self.rating = channel?.rating ?? (try? container.decode(String.self, forKey: .rating))
            
            self.ttl = channel?.ttl ?? (try? container.decode(Int.self, forKey: .ttl))
            
            if let entries = try? container.decode([Item].self, forKey: .entries), !entries.isEmpty {
                self.items = entries
            } else {
                self.items = channel?.items ?? (try? container.decode([Item].self, forKey: .items))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try? container.encode(title, forKey: .title)
            try? container.encode(link, forKey: .link)
            try? container.encode(description, forKey: .description)
            try? container.encode(language, forKey: .language)
            try? container.encode(managingEditor, forKey: .managingEditor)
            try? container.encode(pubDate, forKey: .pubDate)
            try? container.encode(lastBuildDate, forKey: .lastBuildDate)
            try? container.encode(generator, forKey: .generator)
            try? container.encode(docs, forKey: .docs)
            try? container.encode(rating, forKey: .rating)
            try? container.encode(ttl, forKey: .ttl)
            try? container.encode(items, forKey: .items)
        }
        
        @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
        public func getFavicon() async throws -> URL {
            guard let link = link?.rootDomain else { throw URLError(.badURL) }
            guard let url = URL(string: "https://favicongrabber.com/api/grab/\(link)") else { throw URLError(.badURL) }
            
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let icons = json["icons"] as? [[String: String]], let iconStr = icons.first?["src"], let icon = URL(string: iconStr) else { throw URLError(.badServerResponse) }
            return icon
        }
    }
}

fileprivate extension URL {
    var rootDomain: String? {
        guard let hostName = self.host else { return nil }
        let components = hostName.components(separatedBy: ".")
        if components.count > 2 {
            return components.suffix(2).joined(separator: ".")
        } else {
            return hostName
        }
    }
}

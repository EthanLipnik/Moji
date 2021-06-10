import XMLCoder
import Foundation

public class Moji {
    
    public class func decode(from xmlData: Data) throws -> RSS {
        let decoder = XMLDecoder()
        decoder.shouldProcessNamespaces = true

        return try decoder.decode(RSS.self, from: xmlData)
    }
    
    public class func encode(_ rss: RSS) throws -> Data {
        let encoder = XMLEncoder()
        
        return try encoder.encode(rss)
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public class func decode(from urlRequest: URLRequest) async throws -> RSS {
        
        let data = try await URLSession.shared.data(for: urlRequest).0
        
        let decoder = XMLDecoder()
        decoder.shouldProcessNamespaces = true

        return try decoder.decode(RSS.self, from: data)
    }
}

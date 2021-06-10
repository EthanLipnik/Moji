import XMLCoder
import Foundation

public class Moji {
    
    public class func decode(from xmlData: Data) throws -> RSS {
        let decoder = XMLDecoder()
        decoder.shouldProcessNamespaces = true

        return try decoder.decode(RSS.self, from: xmlData)
    }
}

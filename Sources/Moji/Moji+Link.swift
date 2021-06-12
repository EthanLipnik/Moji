//
//  Moji+Link.swift
//  
//
//  Created by Ethan Lipnik on 6/11/21.
//

import Foundation
import XMLCoder

extension Moji {
    struct Link: Codable, Hashable, DynamicNodeDecoding {
        let href: URL
        
        enum CodingKeys: String, CodingKey {
            case href
        }
        
        static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
            switch key {
            case CodingKeys.href:
                return XMLDecoder.NodeDecoding.attribute
            default:
                return .element
            }
        }
    }
}

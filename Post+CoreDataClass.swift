//
//  Post+CoreDataClass.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/5/22.
//
//

import CoreData
import Foundation

public class Post: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "userId"
        case title = "title"
        case body = "body"
        case isLiked = "isLiked"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context else {
            fatalError("decode failure")
        }
        
        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("decode failure")
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Post", in: managedObjectContext) else {
            fatalError("decode failure")
        }
        
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(Int.self, forKey: .id)
            userId = try values.decode(Int.self, forKey: .userId)
            title = try values.decode(String.self, forKey: .title)
            body = try values.decode(String.self, forKey: .body)
            isLiked = try values.decode(Bool.self, forKey: .isLiked)
        } catch (let error) {
            log.error("Post model decoding error: \(error)")
            print("error")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
            try container.encode(userId, forKey: .userId)
            try container.encode(title, forKey: .title)
            try container.encode(body, forKey: .body)
            try container.encode(isLiked, forKey: .isLiked)
        } catch (let error) {
            log.error("Post model encoding error: \(error)")
        }
    }
}

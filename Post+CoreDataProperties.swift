//
//  Post+CoreDataProperties.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/5/22.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int
    @NSManaged public var userId: Int
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var isLiked: Bool

}

extension Post : Identifiable {

}

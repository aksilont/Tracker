//
//  User+CoreDataProperties.swift
//  Tracker
//
//  Created by Aksilont on 02.04.2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var login: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}

//
//  Users+CoreDataProperties.swift
//  Tracker
//
//  Created by Aksilont on 02.04.2022.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var login: String?
    @NSManaged public var password: String?

}

extension Users : Identifiable {

}

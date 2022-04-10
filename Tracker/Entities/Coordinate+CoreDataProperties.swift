//
//  Coordinate+CoreDataProperties.swift
//  Tracker
//
//  Created by Aksilont on 26.03.2022.
//
//

import Foundation
import CoreData


extension Coordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coordinate> {
        return NSFetchRequest<Coordinate>(entityName: "Coordinate")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var route: Route?

}

extension Coordinate : Identifiable {

}

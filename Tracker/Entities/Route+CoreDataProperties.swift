//
//  Route+CoreDataProperties.swift
//  Tracker
//
//  Created by Aksilont on 26.03.2022.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var coordinates: NSMutableOrderedSet?

}

// MARK: Generated accessors for coordinates
extension Route {

    @objc(insertObject:inCoordinatesAtIndex:)
    @NSManaged public func insertIntoCoordinates(_ value: Coordinate, at idx: Int)

    @objc(removeObjectFromCoordinatesAtIndex:)
    @NSManaged public func removeFromCoordinates(at idx: Int)

    @objc(insertCoordinates:atIndexes:)
    @NSManaged public func insertIntoCoordinates(_ values: [Coordinate], at indexes: NSIndexSet)

    @objc(removeCoordinatesAtIndexes:)
    @NSManaged public func removeFromCoordinates(at indexes: NSIndexSet)

    @objc(replaceObjectInCoordinatesAtIndex:withObject:)
    @NSManaged public func replaceCoordinates(at idx: Int, with value: Coordinate)

    @objc(replaceCoordinatesAtIndexes:withCoordinates:)
    @NSManaged public func replaceCoordinates(at indexes: NSIndexSet, with values: [Coordinate])

    @objc(addCoordinatesObject:)
    @NSManaged public func addToCoordinates(_ value: Coordinate)

    @objc(removeCoordinatesObject:)
    @NSManaged public func removeFromCoordinates(_ value: Coordinate)

    @objc(addCoordinates:)
    @NSManaged public func addToCoordinates(_ values: NSOrderedSet)

    @objc(removeCoordinates:)
    @NSManaged public func removeFromCoordinates(_ values: NSOrderedSet)

}

extension Route : Identifiable {

}

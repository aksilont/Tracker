//
//  DataRepository.swift
//  Tracker
//
//  Created by Aksilont on 26.03.2022.
//

import CoreData
import CoreLocation

final class DataRepository {
    
    private let coreDataStack = CoreDataStack()
    private let context: NSManagedObjectContext
    
    init() {
        context = coreDataStack.persistentContainer.viewContext
    }
    
    func fetchRoutes(completion: @escaping ([Route]) -> Void) {
        
        let fetchRequest: NSFetchRequest<Route> = Route.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            completion(results)
        } catch let error as NSError {
            print(error.userInfo)
            completion([])
        }
    }
    
    func createNewRoute() -> Route {
        let newRoute = Route(context: context)
        newRoute.id = UUID()
        
        do {
            try context.save()
            return newRoute
        } catch let error as NSError {
            fatalError("Error: \(error.localizedDescription); userInfo: \(error.userInfo)")
        }
    }
    
    func add(coordinate: CLLocationCoordinate2D, to route: Route?) {
        guard let route = route else { return }
        
        let newCoordinate = Coordinate(context: context)
        newCoordinate.latitude = coordinate.latitude
        newCoordinate.longitude = coordinate.longitude
        newCoordinate.route = route
        
        let coordinates = route.coordinates?.mutableCopy() as? NSMutableOrderedSet
        coordinates?.add(newCoordinate)
        route.coordinates = coordinates
//        route.coordinates?.add(newCoordinate)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription); userInfo: \(error.userInfo)")
        }
    }
}

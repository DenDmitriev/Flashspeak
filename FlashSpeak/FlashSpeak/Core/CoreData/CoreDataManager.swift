//
//  CoreDataManager.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 16.04.2023.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    private init() {
        let container = NSPersistentContainer(name: "FlashSpeak")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer = container
        context = persistentContainer.newBackgroundContext()
    }
    
    var studies: [StudyCD]? {
        let fetchRequest = getStudiesFetchRequest()
        var result: [StudyCD]?
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return result
    }
}

// MARK: - Extension CoreDataManager on the methods
extension CoreDataManager {
    
    func initStudyFetchedResultsController() -> NSFetchedResultsController<StudyCD> {
        let fetchRequest = getStudiesFetchRequest()
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchedResultsController
    }
    
    @discardableResult
    func createStudy(_ study: Study) -> Error? {
        let studyCD = StudyCD(context: context)
        studyCD.id = study.id
        studyCD.sourceLanguage = Int16(study.sourceLanguage.rawValue)
        studyCD.targetLanguage = Int16(study.targetLanguage.rawValue)
        studyCD.startDate = study.started
        studyCD.listsCD = nil
        return saveContext()
    }
}

// MARK: - Private
private extension CoreDataManager {
    
    private func getStudiesFetchRequest() -> NSFetchRequest<StudyCD> {
        let fetchRequest: NSFetchRequest<StudyCD> = StudyCD.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(value: true)
        fetchRequest.relationshipKeyPathsForPrefetching = ["listsCD"]
        return fetchRequest
    }
    
    @discardableResult
    private func saveContext() -> Error? {
        if context.hasChanges {
            var saveError: Error?
            context.performAndWait {
                do {
                    try context.save()
                } catch let error {
                    print(error.localizedDescription)
                    context.rollback()
                    saveError = error
                }
            }
            if saveError != nil {
                return saveError
            }
        }
        return nil
    }
    
    func deleteItem(_ object: NSManagedObject) {
        context.delete(object)
    }
}
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
    
    func initListFetchedResultsController() -> NSFetchedResultsController<ListCD> {
        let fetchRequest = getListsFetchRequest()
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
    
    @discardableResult
    func createList(_ list: List, for studyCD: StudyCD) -> Error? {
        let listCD = ListCD(context: context)
        listCD.id = list.id
        listCD.addImageFlag = list.addImageFlag
        listCD.creationDate = list.created
        listCD.style = Int16(list.style.rawValue)
        listCD.title = list.title
        listCD.wordsCD = nil
        studyCD.addToListsCD(listCD)
        return saveContext()
    }
    
    @discardableResult
    func createWords(_ words: [Word], for listCD: ListCD) -> Error? {
        words.forEach { word in
            let wordCD = WordCD(context: context)
            wordCD.id = word.id
            wordCD.title = word.source
            wordCD.translation = word.translation
            wordCD.imageURL = word.imageURL
            wordCD.numberOfRightAnswers = Int16(word.rightAnswers)
            wordCD.numberOfWrongAnsewrs = Int16(word.wrongAnswers)
            listCD.addToWordsCD(wordCD)
        }
        return saveContext()
    }
    
    func getListObject(by id: UUID) -> ListCD? {
        let fetchRequest: NSFetchRequest<ListCD> = ListCD.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        fetchRequest.predicate = predicate
        var listResult: ListCD?
        context.performAndWait {
            do {
                let fetchResult = try context.fetch(fetchRequest)
                listResult = fetchResult.first
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return listResult
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
    
    private func getListsFetchRequest() -> NSFetchRequest<ListCD> {
        let fetchRequest: NSFetchRequest<ListCD> = ListCD.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(value: true)
        fetchRequest.relationshipKeyPathsForPrefetching = ["wordsCD"]
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

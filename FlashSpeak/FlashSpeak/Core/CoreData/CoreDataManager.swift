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
        container.loadPersistentStores(completionHandler: { _, error in
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
    
    var learnings: [LearnCD]? {
        let fetchRequest = getLearningsFetchRequest()
        var result: [LearnCD]?
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
    
    func initLearnFetchedResultsController() -> NSFetchedResultsController<LearnCD> {
        let fetchRequest = getLearningsFetchRequest()
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
        listCD.learnsCD = nil
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
    
    @discardableResult
    func updateWord(_ word: Word, by id: UUID) -> Error? {
        guard
            let wordCD = getWordObject(by: id)
        else { return CoreDataError.wordNotFounded(id: id) }
        wordCD.title = word.source
        wordCD.translation = word.translation
        wordCD.imageURL = word.imageURL
        wordCD.numberOfRightAnswers = Int16(word.rightAnswers)
        wordCD.numberOfWrongAnsewrs = Int16(word.wrongAnswers)
        return saveContext()
    }
    
    @discardableResult
    func createLearn(_ learn: Learn, for listID: UUID) -> Error? {
        let learnCD = LearnCD(context: context)
        learnCD.id = learn.id
        learnCD.startTime = learn.startTime
        learnCD.finishTime = learn.finishTime
        learnCD.count = Int16(learn.count)
        learnCD.result = Int16(learn.result)
        guard
            let listCD = getListObject(by: listID)
        else { return CoreDataError.listNotFounded(id: listID) }
        listCD.addToLearnsCD(learnCD)
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
    
    func getLearnObject(by id: UUID) -> LearnCD? {
        let fetchRequest: NSFetchRequest<LearnCD> = LearnCD.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        fetchRequest.predicate = predicate
        var learnResult: LearnCD?
        context.performAndWait {
            do {
                let fetchResult = try context.fetch(fetchRequest)
                learnResult = fetchResult.first
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return learnResult
    }
    
    func getStudyObject(source: Language, target: Language) -> StudyCD? {
        guard
            let studies = self.studies,
            !studies.isEmpty,
            let study = studies.first(where: { studyCD in
                guard
                    studyCD.sourceLanguage == source.rawValue,
                    studyCD.targetLanguage == target.rawValue
                else { return false }
                return true
            })
        else { return nil }
        return study
    }
    
    func getWordObject(by id: UUID) -> WordCD? {
        let fetchRequest: NSFetchRequest<WordCD> = WordCD.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        fetchRequest.predicate = predicate
        var wordResult: WordCD?
        context.performAndWait {
            do {
                let fetchResult = try context.fetch(fetchRequest)
                wordResult = fetchResult.first
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return wordResult
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
    
    private func getLearningsFetchRequest() -> NSFetchRequest<LearnCD> {
        let fetchRequest: NSFetchRequest<LearnCD> = LearnCD.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(value: true)
        fetchRequest.relationshipKeyPathsForPrefetching = ["wrongWordsCD"]
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
                    saveError = CoreDataError.save(description: error.localizedDescription)
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

//
//  ListCD+CoreDataProperties.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 16.04.2023.
//
//

import Foundation
import CoreData


extension ListCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListCD> {
        return NSFetchRequest<ListCD>(entityName: "ListCD")
    }

    @NSManaged public var addImageFlag: Bool
    @NSManaged public var creationDate: Date
    @NSManaged public var id: UUID?
    @NSManaged public var style: Int16
    @NSManaged public var title: String
    @NSManaged public var studyCD: StudyCD?
    @NSManaged public var wordsCD: NSSet?

}

// MARK: Generated accessors for wordsCD
extension ListCD {

    @objc(addWordsCDObject:)
    @NSManaged public func addToWordsCD(_ value: WordCD)

    @objc(removeWordsCDObject:)
    @NSManaged public func removeFromWordsCD(_ value: WordCD)

    @objc(addWordsCD:)
    @NSManaged public func addToWordsCD(_ values: NSSet)

    @objc(removeWordsCD:)
    @NSManaged public func removeFromWordsCD(_ values: NSSet)

}

extension ListCD : Identifiable {

}

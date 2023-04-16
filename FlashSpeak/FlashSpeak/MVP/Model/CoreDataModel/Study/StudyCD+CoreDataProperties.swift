//
//  StudyCD+CoreDataProperties.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 16.04.2023.
//
//

import Foundation
import CoreData


extension StudyCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyCD> {
        return NSFetchRequest<StudyCD>(entityName: "StudyCD")
    }

    @NSManaged public var id: UUID
    @NSManaged public var sourceLanguage: Int16
    @NSManaged public var startDate: Date
    @NSManaged public var targetLanguage: Int16
    @NSManaged public var listsCD: NSSet?

}

// MARK: Generated accessors for listsCD
extension StudyCD {

    @objc(addListsCDObject:)
    @NSManaged public func addToListsCD(_ value: ListCD)

    @objc(removeListsCDObject:)
    @NSManaged public func removeFromListsCD(_ value: ListCD)

    @objc(addListsCD:)
    @NSManaged public func addToListsCD(_ values: NSSet)

    @objc(removeListsCD:)
    @NSManaged public func removeFromListsCD(_ values: NSSet)

}

extension StudyCD : Identifiable {

}

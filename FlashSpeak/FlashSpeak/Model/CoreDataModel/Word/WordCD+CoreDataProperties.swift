//
//  WordCD+CoreDataProperties.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 16.04.2023.
//
//

import Foundation
import CoreData


extension WordCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordCD> {
        return NSFetchRequest<WordCD>(entityName: "WordCD")
    }

    @NSManaged public var id: UUID
    @NSManaged public var imageURL: URL?
    @NSManaged public var numberOfRightAnswers: Int16
    @NSManaged public var numberOfWrongAnsewrs: Int16
    @NSManaged public var title: String
    @NSManaged public var translation: String?
    @NSManaged public var listCD: ListCD?

}

extension WordCD: Identifiable {

}

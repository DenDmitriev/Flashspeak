//
//  LearnCD+CoreDataProperties.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 08.05.2023.
//
//

import Foundation
import CoreData


extension LearnCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LearnCD> {
        return NSFetchRequest<LearnCD>(entityName: "LearnCD")
    }

    @NSManaged public var id: UUID
    @NSManaged public var startTime: Date
    @NSManaged public var finishTime: Date
    @NSManaged public var result: Int16
    @NSManaged public var count: Int16
    @NSManaged public var listCD: ListCD?

}

extension LearnCD: Identifiable {

}

//
//  Person+CoreDataProperties.swift
//  ToDoListTable
//
//  Created by Dastan Zhapay on 24.05.2021.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?

}

extension Person : Identifiable {

}

//
//  CountryCore+CoreDataProperties.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 12/10/25.
//
//

import Foundation
import CoreData


extension CountryCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryCore> {
        return NSFetchRequest<CountryCore>(entityName: "CountryCore")
    }

    @NSManaged public var capital: String?
    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var region: String?

}

extension CountryCore : Identifiable {

}

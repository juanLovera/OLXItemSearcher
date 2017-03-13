//
//  Item+CoreDataClass.swift
//  
//
//  Created by Juan José Lovera Brito on 3/7/17.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
    return NSFetchRequest<Item>(entityName: "Item");
  }
  
  @NSManaged public var descriptionText: String
  @NSManaged public var title: String
  @NSManaged public var condition: String
  @NSManaged public var id: Int64
  @NSManaged public var date: NSDate
  @NSManaged public var thumbnailURL: String
  @NSManaged public var fullImageURL: String
  @NSManaged public var displayPrice: String
  @NSManaged public var location: String
  @NSManaged public var imagesData: ItemImagesData
  @NSManaged public var optionals: NSSet
  
  @objc(addOptionalsObject:)
  @NSManaged public func addToOptionals(_ value: ItemOptionals)
  
  @objc(removeOptionalsObject:)
  @NSManaged public func removeFromOptionals(_ value: ItemOptionals)
  
  @objc(addOptionals:)
  @NSManaged public func addToOptionals(_ values: NSSet)
  
  @objc(removeOptionals:)
  @NSManaged public func removeFromOptionals(_ values: NSSet)
  
}

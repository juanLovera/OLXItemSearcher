//
//  Item+CoreDataClass.swift
//  
//
//  Created by Juan José Lovera Brito on 3/7/17.
//
//

import Foundation
import CoreData


public class ItemPersistent: NSManagedObject {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemPersistent> {
    return NSFetchRequest<ItemPersistent>(entityName: "ItemPersistent");
  }
  
  @NSManaged public var descriptionText: String
  @NSManaged public var title: String
  @NSManaged public var condition: String
  @NSManaged public var id: Int64
  @NSManaged public var date: NSDate
  @NSManaged public var likedDate: NSDate
  @NSManaged public var fullImageURL: String
  @NSManaged public var displayPrice: String
  @NSManaged public var location: String
  @NSManaged public var fullImageData: NSData?
  @NSManaged public var optionals: NSSet
  
  @objc(addOptionals:)
  @NSManaged public func addToOptionals(_ values: NSSet)
  
  @objc(removeOptionals:)
  @NSManaged public func removeFromOptionals(_ values: NSSet)
  
  func convertToNonPersistent() -> Item {
    var itemOptionals: [Item.Optional] = []
    for optional in optionals {
      if let optionalPersistent = optional as? ItemOptionalsPersistent {
        itemOptionals.append((label: optionalPersistent.label, value: optionalPersistent.value))
      }
    }
    return Item(descriptionText: descriptionText, title: title, condition: condition, id: id, date: date as Date,
                thumbnailURL: "", fullImageURL: fullImageURL, displayPrice: displayPrice, location: location,
                optionals: itemOptionals)
  }
  
}

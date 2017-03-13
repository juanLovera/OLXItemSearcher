//
//  ItemOptionals+CoreDataClass.swift
//  
//
//  Created by Juan José Lovera Brito on 3/7/17.
//
//

import Foundation
import CoreData


public class ItemOptionalsPersistent: NSManagedObject {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemOptionalsPersistent> {
    return NSFetchRequest<ItemOptionalsPersistent>(entityName: "ItemOptionalsPersistent");
  }
  
  @NSManaged public var label: String
  @NSManaged public var value: String
  
}

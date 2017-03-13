//
//  ItemOptionals+CoreDataClass.swift
//  
//
//  Created by Juan José Lovera Brito on 3/7/17.
//
//

import Foundation
import CoreData


public class ItemOptionals: NSManagedObject {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemOptionals> {
    return NSFetchRequest<ItemOptionals>(entityName: "ItemOptionals");
  }
  
  @NSManaged public var label: String
  @NSManaged public var value: String
  
}

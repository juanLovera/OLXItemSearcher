//
//  FavoriteManager.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/9/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class FavoriteManager {
  
  static let delegate = UIApplication.shared.delegate as! AppDelegate
  static let managedObjectContext = delegate.managedObjectContext
  
  static func addItemToFavorites(item: Item) -> Bool {
    if isItemOnFavorites(item: item) {
      return false
    }
    let entity = NSEntityDescription.entity(forEntityName: Entity.ItemPersistent.name, in: managedObjectContext)
    let itemPersistent = ItemPersistent(entity: entity!, insertInto: managedObjectContext)
    let optionals = NSSet(array: createAndGetOptionals(item: item))
    itemPersistent.id = item.id
    itemPersistent.title = item.title
    itemPersistent.condition = item.condition
    itemPersistent.date = item.date as NSDate
    itemPersistent.descriptionText = item.descriptionText
    itemPersistent.displayPrice = item.displayPrice
    itemPersistent.fullImageURL = item.fullImageURL
    itemPersistent.location = item.location
    itemPersistent.likedDate = NSDate()
    itemPersistent.addToOptionals(optionals)
    downloadAndSaveImage(item: itemPersistent)
    NotificationCenter.default.post(name: Literals.Observers.itemDidChange, object: item.id)
    return saveContext()
  }
  
  static func saveContext() -> Bool {
    do {
      try managedObjectContext.save()
    } catch let error {
      print(error)
      return false
    }
    return true
  }
  
  static func downloadAndSaveImage(item: ItemPersistent) {
    Alamofire.request(item.fullImageURL, method: .get).response { response in
      if let data = response.data {
        if let fecthedImage = UIImage(data: data, scale:1) {
          _ = saveImage(itemPersistent: item, fullImage: fecthedImage)
        }
      } else {
        // TODO: think what to do when image download fails (maybe use cached thumbnail?)
      }
    }
  }
  
  
  static func saveImage(itemPersistent: ItemPersistent, fullImage: UIImage) -> Bool {
    if let imageData = UIImageJPEGRepresentation(fullImage, 1) {
      itemPersistent.fullImageData = imageData as NSData
    }
    return saveContext()
  }
  
  static func createAndGetOptionals(item: Item) -> [ItemOptionalsPersistent] {
    var optionals: [ItemOptionalsPersistent] = []
    for optional in item.optionals {
      let entity = NSEntityDescription.entity(forEntityName: Entity.ItemOptionalsPersistent.name, in: managedObjectContext)
      let optionalPersistent = ItemOptionalsPersistent(entity: entity!, insertInto: managedObjectContext)
      optionalPersistent.label = optional.label
      optionalPersistent.value = optional.value
      optionals.append(optionalPersistent)
    }
    return optionals
  }
  
  static func isItemOnFavorites(item: Item) -> Bool {
    let fetchRequest: NSFetchRequest<ItemPersistent> = ItemPersistent.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == \(item.id)")
    do {
      let result = try managedObjectContext.fetch(fetchRequest)
      return result.count != 0
    } catch _ {
      return false
    }
  }
  
  static func deleteItemFromFavorites(item: Item) -> Bool {
    let fetchRequest: NSFetchRequest<ItemPersistent> = ItemPersistent.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == \(item.id)")
    do {
      let result = try managedObjectContext.fetch(fetchRequest)
      for object in result {
        managedObjectContext.delete(object)
        NotificationCenter.default.post(name: Literals.Observers.itemDidChange, object: item.id)
      }
      return saveContext()
    } catch _ {
      return false
    }
  }
  
  static func deleteItemFromFavorites(item: ItemPersistent) -> Bool {
    managedObjectContext.delete(item)
    NotificationCenter.default.post(name: Literals.Observers.itemDidChange, object: item.id)
    return saveContext()
  }
}

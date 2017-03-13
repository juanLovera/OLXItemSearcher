//
//  FetchPublicItemsService.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/7/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FetchPublicItemsService : Service {
  
  let URL = Config.ServicesURLs.publicFetchItems
  let requestType = HTTPMethod.get
  
  var searchTerm: String
  var offset: Int
  var responseCallback: ([Item])->()
  
  init(searchTerm: String, offset: Int, responseCallback: @escaping ([Item])->()) {
    self.searchTerm = searchTerm
    self.offset = offset
    self.responseCallback = responseCallback
    super.init(URL: URL, requestType: requestType)
  }
  
  override func URLParameters() -> [String : String]? {
    return ["location" : Config.ItemsFetch.defaultLocationForAllSearchs,
            "searchTerm" : searchTerm,
            "offset" : String(offset),
            "pageSize" : String(Config.ItemsFetch.pageSizeForFetching)]
  }
  
  override func successCallback(response: JSON?) {
    var items = [Item]()
    if let itemsJSON = response?["data"] {
      for itemJSON in itemsJSON.arrayValue {
        let item = parseItem(data: itemJSON)
        items.append(item)
      }
    }
    responseCallback(items)
  }
  
  private func parseItem(data: JSON) -> Item {
    let descriptionText = data["description"].stringValue
    let title = data["title"].stringValue
    let condition = data["condition"].stringValue
    let id = data["id"].int64Value
    let dateString = data["date"]["timestamp"].stringValue
    let date = DateFormatterManager.sharedInstance.iso8601Formatter.date(from: dateString)!
    let thumbnailURL = data["mediumImage"].stringValue
    let fullImageURL = data["fullImage"].stringValue
    let displayPrice = data["price"]["displayPrice"].stringValue
    let location = data["displayLocation"].stringValue
    let optionals = parseOptionals(data: data["optionals"].arrayValue)
    let item = Item(descriptionText: descriptionText, title: title, condition: condition, id: id, date: date, thumbnailURL: thumbnailURL, fullImageURL: fullImageURL, displayPrice: displayPrice, location: location, optionals: optionals)
    
    return item
  }
  
  private func parseOptionals(data: [JSON]) -> [Item.Optional] {
    var optionals: [Item.Optional] = []
    for optionalJSON in data {
      let label = optionalJSON["label"].stringValue
      let value = optionalJSON["value"].stringValue
      optionals.append((label: label, value: value))
    }
    return optionals
  }
}

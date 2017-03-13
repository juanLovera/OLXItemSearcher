//
//  Service.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 2/18/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class Service {
  
  private var URL: String
  private var requestType: HTTPMethod
  
  init(URL: String, requestType: HTTPMethod) {
    self.URL = URL
    self.requestType = requestType
  }
  
  func headerParameters() -> [String : String]?  {
    return nil
  }
  
  func bodyParameters() -> [String : AnyObject]? {
    return nil
  }
  
  func URLParameters() -> [String : String]? {
    return nil
  }
  
  func successCallback(response: JSON?) {
    return
  }
  
  func failureCallback(error: Error, response: DataResponse<Any>?) {
    SVProgressHUD.showError(withStatus: Literals.connectionError)
  }
  
  func startLoadingFeedback() {
    SVProgressHUD.showProgress(-1)
  }
  
  func stopLoadingFeedback() {
    SVProgressHUD.dismiss()
  }
  
  private func constructURL() -> String {
    var completeURL = "\(URL)?"
    if let parameters = URLParameters() {
      for (key, value) in parameters {
        let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        completeURL = completeURL.appending("\(key)=\(encodedValue)&")
      }
    }
    return completeURL
  }
  
  func makeRequest() {
    startLoadingFeedback()
    Alamofire.request(constructURL(), method: requestType, parameters: bodyParameters(), encoding: JSONEncoding.default, headers: headerParameters()).responseJSON { response in
      self.stopLoadingFeedback()
      switch response.result {
      case .success(let responseData):
        self.successCallback(response: JSON(responseData))
      case .failure(let error):
        self.failureCallback(error: error, response: response)
      }
    }
  }
}

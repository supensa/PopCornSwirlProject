//
//  NetworkController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire

class NetworkController {
  
  private init() {}
  
  private static func process<T>(data: Data,
                                 type: T.Type,
                                 completion: @escaping (Bool, Decodable) -> Void) where T : Decodable {
      Parser().decode(T.self, from: data) {
        (success, decodable) in
        if success {
          let oject = decodable as! T
          completion(success, oject)
        } else {
          let error = decodable as! Response
          completion(success, error)
        }
      }
  }
  
  /// Process response. Return in closure decodable object of type T or of type Error.
  ///
  /// - Parameters:
  ///   - response: Alamofire response
  ///   - type: Decodable type object to parse from JSON
  ///   - completion: return Decodable object of type T or error
  ///   - success: true if received an answer from server
  ///   - decodable: object decoded from JSON
  static func process<T>(response: DataResponse<Any>,
                         type: T.Type,
                         completion: @escaping (_ success: Bool, _ decodable: Decodable) -> Void) where T : Decodable {
    if response.result.isSuccess, let data = response.data {
      // success
      NetworkController.process(data: data, type: T.self, completion: completion)
    } else {
      // Server Failed to answer
      completion(false, Response(id: nil, statusMessage: "Server failed to answer"))
    }
  }
  
  static var alamofire: SessionManager = {
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 10
    return manager
  }()
}

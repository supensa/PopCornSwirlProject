//
//  NetworkController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

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
  ///   - data: Data can be null
  ///   - type: Decodable type object to parse from JSON
  ///   - completion: Pass as parameter decodable object of type T or error
  ///   - success: true if received an answer from server
  ///   - decodable: object decoded from JSON
  static func process<T>(data: Data?,
                         type: T.Type,
                         completion: @escaping (_ success: Bool, _ decodable: Decodable) -> Void) where T : Decodable {
    if let data = data {
      // success
      NetworkController.process(data: data, type: T.self, completion: completion)
    } else {
      // Server Failed to answer
      completion(false, createError())
    }
  }
  
  static func postRequest<T>(url: String,
                             encodable: T,
                             errorHandler: ((Bool, Decodable)->())? = nil,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) where T: Encodable {
    var request = URLRequest.init(url: URL.init(string: url)!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let data: Data
    
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      data = try encoder.encode(encodable)
      request.httpBody = data
    } catch {
      if let handler = errorHandler {
        handler(false, createError("Failed to encode to JSON"))
      }
    }
    
    URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
  }
  
  static func getRequest(url: String,
                         errorHandler: ((Bool, Decodable)->())? = nil,
                         completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    if let request = URL.init(string: url) {
      URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    } else {
      if let errorHandler = errorHandler {
        errorHandler(false, createError())
      }
    }
  }
  
  private static func createError(_ message: String = "Server failed to answer") -> Response {
    return Response(id: nil, statusMessage: message)
  }
  
//  static var alamofire: SessionManager = {
//    let manager = Alamofire.SessionManager.default
//    manager.session.configuration.timeoutIntervalForRequest = 10
//    return manager
//  }()
}

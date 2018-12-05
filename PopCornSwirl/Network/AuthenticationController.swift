//
//  AuthenticationController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire

class AuthenticationController {
  var token: String?
  
  func requestNewToken(username: String, password: String, completion: @escaping (Bool, String) -> Void) {
    let url = API.newToken
    Alamofire.request(url, method: .get).responseJSON {
      (response) in
      if response.result.isSuccess, let data = response.data {
        // Success
        self.processToken(username: username, password: password, data: data, completion: completion)
      } else {
        // Server Failed to answer
        completion(false, "Server failed to answer")
      }
    }
  }
  
  func processToken(username:String, password: String, data: Data, completion: @escaping (Bool, String) -> Void) {
    TokenParser().parse(from: data) {
      (success, message) in
      if success {
        // Token Received
        let token = message
        self.validateToken(username: username, password: password, token: token, completion: completion)
      } else {
        // Error Message
        completion(false, message)
      }
    }
  }
  
  func validateToken(username: String, password: String, token: String, completion: @escaping (Bool, String) -> Void) {
    let url = API.login
    
    let parameters = [
      "username": username,
      "password": password,
      "request_token": token
    ]
    
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
      (response) in
      if response.result.isSuccess, let data = response.data {
        // Success
        self.processTokenValidation(data: data, completion: completion)
      } else {
        // Server Failed to answer
        completion(false, "Server failed to answer")
      }
    }
  }
  
  func processTokenValidation(data: Data, completion: @escaping (Bool, String) -> Void) {
    TokenParser().parse(from: data) {
      (success, message) in
      if success {
        // Token
        let token = message
        self.requestSessionId(token: token, completion: completion)
      } else {
        // Error Message
        completion(false, message)
      }
    }
  }
  
  func requestSessionId(token: String, completion: @escaping (Bool, String) -> Void) {
    let url = API.newSession
    let parameters = ["request_token": token]
    Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
      (response) in
      if response.result.isSuccess, let data = response.data {
        // success
        self.processSessionId(data: data, completion: completion)
      } else {
        // Server Failed to answer
        completion(false, "Server failed to answer")
      }
    }
  }
  
  func processSessionId(data: Data, completion: @escaping (Bool, String) -> Void) {
    SessionIdParser().parse(from: data) {
      (success, message) in
      if success {
        // SessionId
        let sessionId = message
        completion(true, sessionId)
      } else {
        // Error Message
        completion(false, message)
      }
    }
  }
}

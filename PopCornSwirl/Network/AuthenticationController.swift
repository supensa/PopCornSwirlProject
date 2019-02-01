//
//  AuthenticationController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire


/// Class used to authenticate the user by sending a request to Web Service
class AuthenticationController {
  
  func sendRequest(username: String, password: String, completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.newToken
    
    NetworkController.alamofire.request(url, method: .get).responseJSON {
      (response) in
      if response.result.isSuccess, let data = response.data {
        // Success
        self.processToken(username: username, password: password, data: data, completion: completion)
      } else {
        // Server Failed to answer
        completion(false, self.createError())
      }
    }
  }
  
  func processToken(username:String, password: String, data: Data, completion: @escaping (Bool, Decodable) -> Void) {
    Parser().decode(Token.self, from: data) {
      (success: Bool, decodable: Decodable) in
      if success {
        // Token Received
        let token = decodable as! Token
        self.validateToken(username: username, password: password, token: token.requestToken, completion: completion)
      } else {
        // Error Message
        let error = decodable as! Response
        completion(false, error)
      }
    }
  }
  
  func validateToken(username: String, password: String, token: String, completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.login
    
    let parameters = [
      "username": username,
      "password": password,
      "request_token": token
    ]
    
    NetworkController.alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
      (response) in
      if response.result.isSuccess, let data = response.data {
        // Success
        self.processTokenValidation(data: data, completion: completion)
      } else {
        // Server Failed to answer
        completion(false, self.createError())
      }
    }
  }
  
  func processTokenValidation(data: Data, completion: @escaping (Bool, Decodable) -> Void) {
    Parser().decode(Token.self, from: data) {
      (success: Bool, decodable: Decodable) in
      if success {
        // Token
        let token = decodable as! Token
        self.requestSessionId(token: token.requestToken, completion: completion)
      } else {
        // Error Message
        let error = decodable as! Response
        completion(false, error)
      }
    }
  }
  
  func requestSessionId(token: String, completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.newSession
    let parameters = ["request_token": token]
    NetworkController.alamofire.request(url, method: .post, parameters: parameters).responseJSON {
      (response: DataResponse<Any>) in
      NetworkController.process(response: response, type: Session.self, completion: completion)
    }
  }
  
  func createError() -> Response {
    return Response(id: nil, statusMessage: "Server failed to answer")
  }
}

//
//  AuthenticationController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

/// Class used to authenticate the user by sending a request to Web Service
class AuthenticationController {
  
  func sendRequest(username: String, password: String, errorHandler: @escaping (Bool, Decodable) -> Void) {
    let url = API.newToken
    
    NetworkController.getRequest(url: url, errorHandler: errorHandler) {
      (data, response, error) in
      if let data = data {
        // Success
        self.processToken(username: username, password: password, data: data, errorHandler: errorHandler)
      } else {
        // Server Failed to answer
        errorHandler(false, self.createError())
      }
    }
  }
  
  private func processToken(username:String, password: String, data: Data, errorHandler: @escaping (Bool, Decodable) -> Void) {
    Parser().decode(Token.self, from: data) {
      (success: Bool, decodable: Decodable) in
      if success {
        // Token Received
        let token = decodable as! Token
        self.validateToken(username: username, password: password, token: token.requestToken, errorHandler: errorHandler)
      } else {
        // Error Message
        let error = decodable as! Response
        errorHandler(false, error)
      }
    }
  }
  
  private func validateToken(username: String, password: String, token: String, errorHandler: @escaping (Bool, Decodable) -> Void) {
    let url = API.login
    
    let authentication = Authentication.init(username: username, password: password, requestToken: token)
    
    NetworkController.postRequest(url: url, encodable: authentication, errorHandler: errorHandler) {
      (data, response, error) in
      if let data = data {
        // Success
        self.processTokenValidation(data: data, errorHandler: errorHandler)
      } else {
        // Server Failed to answer
        errorHandler(false, self.createError())
      }
    }
  }
  
  private func processTokenValidation(data: Data, errorHandler: @escaping (Bool, Decodable) -> Void) {
  Parser().decode(Token.self, from: data) {
    (success: Bool, decodable: Decodable) in
    if success {
      // Token
      let token = decodable as! Token
      self.requestSessionId(token: token.requestToken, errorHandler: errorHandler)
    } else {
      // Error Message
      let error = decodable as! Response
      errorHandler(false, error)
    }
  }
}
  
  private func requestSessionId(token: String, errorHandler: @escaping (Bool, Decodable) -> Void) {
    let url = API.newSession
    
    let authentication = Authentication.init(username: nil, password: nil, requestToken: token)
    
    NetworkController.postRequest(url: url, encodable: authentication, errorHandler: errorHandler) {
      (data, response, error) in
      if let data = data {
        NetworkController.process(data: data, type: Session.self, completion: errorHandler)
      }
    }
  }
  
  private func createError() -> Response {
    return Response(id: nil, statusMessage: "Server failed to answer")
  }
}

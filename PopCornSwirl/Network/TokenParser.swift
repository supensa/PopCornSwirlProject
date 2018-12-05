//
//  AuthenticationParser.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

class TokenParser {
  private struct Token: Decodable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
  }
  
  private struct Error: Decodable {
    let statusCode: Int
    let statusMessage: String
  }
  
  /// Parse message from server
  ///
  /// - Parameters:
  ///   - data: data to parse JSON format
  ///   - completion: closure
  func parse(from data: Data, completion: @escaping (Bool, String) -> Void) {
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let token = try decoder.decode(Token.self, from: data)
      completion(true, token.requestToken)
    } catch {
      self.parseError(from: data, completion: completion)
    }
  }
  
  /// Parse error message coming from server
  ///
  /// - Parameters:
  ///   - data: data to parse JSON format
  ///   - completion: Closure
  private func parseError(from data: Data, completion: @escaping (Bool, String) -> Void) {
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let error = try decoder.decode(Error.self, from: data)
      completion(false, error.statusMessage)
    } catch {
      print(error.localizedDescription)
    }
  }
}

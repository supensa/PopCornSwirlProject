//
//  Parser.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 05/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

class Parser {
  /// Decode JSON into an Object
  ///
  /// - Parameters:
  ///   - type: Type that conform to Decodable protocol
  ///   - data: Data from network request in JSON
  ///   - completion: return Decodable object (T.Type or Error.Type)
  func decode<T>(_ type: T.Type, from data: Data, completion: @escaping (Bool, Decodable) -> Void) where T : Decodable {
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let result = try decoder.decode(type, from: data)
      completion(true, result)
    } catch {
      self.decodeError(from: data, completion: completion)
    }
  }
  
  /// Decode JSON into Error object
  ///
  /// - Parameters:
  ///   - data: data to parse JSON format
  ///   - completion: return Error.Type object
  func decodeError(from data: Data, completion: @escaping (Bool, Decodable) -> Void) {
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let error = try decoder.decode(Error.self, from: data)
      completion(false, error)
    } catch {
      let error = Error(id: nil, statusMessage: "Server failed to answer")
      completion(false, error)
    }
  }
}

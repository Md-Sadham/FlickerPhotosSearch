//
//  ErrorMessage.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 10/08/2021.
//

import Foundation

enum ErrorMessage: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

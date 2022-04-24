//
//  GeneralError.swift
//  MyFindOrLoss001
//
//  Created by Mustafa Taşdemir on 22.01.2022.
//

import Foundation

enum GeneralError: Error {
    case invalidURL
    case statusCodeError
    case unsupportedFormat
    case setupError
    case other(Error)
    
    static func map(_ error: Error) -> GeneralError {
        (error as? GeneralError) ?? .other(error)
    }
    
    func error() -> Error {
        switch self {
        case .other(let error):
            return error
        default:
            return self
        }
    }
    
}

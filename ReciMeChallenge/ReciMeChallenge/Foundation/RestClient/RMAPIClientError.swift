//
//  RMAPIClientError.swift
//  
//
//
//

import Foundation

enum RMAPIClientError: Error {
    case connectionError(Data)
    case apiError
}

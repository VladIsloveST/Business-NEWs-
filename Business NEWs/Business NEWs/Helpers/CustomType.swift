//
//  CustomType.swift
//  Business NEWs
//
//  Created by Mac on 24.09.2023.
//

import Foundation

typealias UndefinedAction = () -> ()
typealias UploadArticles = (Int, Bool) -> ()
typealias CompletionHandler = (Result<Data, Error>) -> Void

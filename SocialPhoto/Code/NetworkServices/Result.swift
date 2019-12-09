//
//  Result.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 22/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case fail(String)
}

//
//  String+AddText.swift
//  MyPlaces
//
//  Created by LALIT JAGTAP on 5/4/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import Foundation

extension String {
    mutating func add(text: String?, separatedBy separator: String = "")
    {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}

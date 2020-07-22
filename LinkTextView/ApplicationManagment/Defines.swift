//
//  Defines.swift
//  LinkTextView
//
//  Created by Adar Tzeiri on 21/07/2020.
//  Copyright © 2020 Adar Tzeiri. All rights reserved.
//

import Foundation

let kEmptyString = String()

//  MARK: - GLOBAL functions - localized string
func localized(key: String) -> String
{
    return NSLocalizedString(key, comment: kEmptyString)
}

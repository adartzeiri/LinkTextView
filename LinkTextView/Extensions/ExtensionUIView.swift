//
//  ExtensionUIView.swift
//  LinkTextView
//
//  Created by Adar Tzeiri on 21/07/2020.
//  Copyright © 2020 Adar Tzeiri. All rights reserved.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

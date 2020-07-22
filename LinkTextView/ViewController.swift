//
//  ViewController.swift
//  LinkTextView
//
//  Created by Adar Tzeiri on 21/07/2020.
//  Copyright © 2020 Adar Tzeiri. All rights reserved.
//

import UIKit

//Constant Demo
let text = "DescriptionRTL"
let link = "ReadMoreRTL"

class ViewController: UIViewController {
    @IBOutlet weak var linkTextView: LinkTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextView.configureWith(text: localized(key: text), links: (title: localized(key: link), link: UrlConstants.google.rawValue), linkColor: UIColor.blue, supportRTL: true)
        
        //Optional
        linkTextView.linkTextViewDelegate = self
    }
}

extension ViewController : LinkTextViewDelegate {
    func linkPressedWith(_ linkURL: URL) {
        print(linkURL)
    }
}


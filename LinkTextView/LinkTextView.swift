//
//  LinkTextView.swift
//  LinkTextView
//
//  Created by Adar Tzeiri on 21/07/2020.
//  Copyright © 2020 Adar Tzeiri. All rights reserved.
//

import UIKit
import SafariServices

protocol LinkTextViewDelegate: class {
    func linkPressedWith(_ linkURL: URL)
}

extension LinkTextViewDelegate {
    func linkPressed(with linkURL: URL){}
}

class LinkTextView: UITextView {
    
    weak var linkTextViewDelegate: LinkTextViewDelegate?
    private var supportRTL = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
}

// MARK: PUBLIC
extension LinkTextView {
    // MARK: - Configuration
    func configureWith(text: String,links:(title: String, link: String)..., font: UIFont = .systemFont(ofSize: 16.0), textColor: UIColor = .black, linkColor: UIColor = .black, supportRTL: Bool?) {
        
        self.supportRTL = supportRTL ?? false
        
        let htmlStr = String(format:localized(key: text), arguments: hrefFrom(linkTuple: links))
        
        let htmlData = NSString(string:htmlStr).data(using: String.Encoding.unicode.rawValue)
        
        if let attributedString = try? NSMutableAttributedString(data: htmlData!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil){
            
            //Text - Customization
            attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attributedString.string.count))
            attributedString.addAttribute(.font, value:font, range: NSRange(location: 0, length: attributedString.string.count))
            
            //Link - Customization
            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor : linkColor,
                NSAttributedString.Key.underlineColor  : linkColor,
                NSAttributedString.Key.underlineStyle  : NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.font            : font
            ]
            
            // Making sure our text keeps Language direction
            let directionalSupport = self.supportRTL ? "\u{200F}" : "\u{200E}"
            let directionalAttributedString = NSMutableAttributedString(string: directionalSupport)
            directionalAttributedString.append(attributedString)
            
            DispatchQueue.main.async { [weak self] in
                self?.linkTextAttributes = linkAttributes
                self?.attributedText = directionalAttributedString
                self?.customizeView()
            }
        }
    }
}

private extension LinkTextView {
    func hrefFrom(linkTuple: [(title: String, link: String)]) -> [String] {
        var links = [String]()
        for link in linkTuple {
            if(!link.link.isEmpty){
                let href = "<a href=\"\(link.link)\">\(link.title)</a>"
                links.append(href)
            } else {
                links.append(link.title)
            }
        }
        return links
    }
    
    //Having this func as private -> customizeView perfomed in mainQueue guaranteed
    func customizeView() {
        self.isEditable        = false
        self.isSelectable      = true
        self.dataDetectorTypes = .link
        self.textAlignment     = supportRTL ? .right : .left
        self.semanticContentAttribute = supportRTL ? .forceRightToLeft : .forceLeftToRight
        self.layoutIfNeeded()
    }
}

extension LinkTextView: UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        //OPTIONAL - UIApplication.shared.open(URL, options: [:]) - //open in safari app

        let svc = SFSafariViewController(url: URL) //open in safari VC
        self.findViewController()?.present(svc, animated: true, completion: nil)
        
        linkTextViewDelegate?.linkPressed(with: URL)
        
        return false
    }
}

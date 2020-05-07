//
//  CustomCell.swift
//  Grocery
//
//  Created by nikita on 5/2/20.
//  Copyright © 2020 nikita. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell{
    var name: String?
    var amount: String?
    
    var nameView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var amountView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameView)
        self.addSubview(amountView)
        
        nameView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        amountView.leftAnchor.constraint(equalTo: self.nameView.rightAnchor).isActive = true
        amountView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        amountView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        amountView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if var name = name{
            nameView.text = name
        }
        if var amount = amount{
            amountView.text = amount
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

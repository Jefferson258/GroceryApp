//
//  OrderCell.swift
//  Grocery
//
//  Created by nikita on 5/2/20.
//  Copyright © 2020 nikita. All rights reserved.
//

import Foundation
import UIKit

class OrderCell: UITableViewCell{
    var name: String?
    var id : String?
    
    var nameView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var idView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameView)
        self.addSubview(idView)
        
        nameView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        idView.leftAnchor.constraint(equalTo: self.nameView.rightAnchor).isActive = true
        idView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        idView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        idView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if var name = name{
            nameView.text = name
        }
        if var id = id{
            idView.text = id
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

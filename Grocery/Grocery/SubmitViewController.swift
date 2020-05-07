//
//  SubmitViewController.swift
//  Grocery
//
//  Created by nikita on 5/4/20.
//  Copyright © 2020 nikita. All rights reserved.
//

import UIKit


struct Text {
    var items: [String]
    var amounts: [String]
}
class SubmitViewController: UIViewController {
    
    @IBOutlet weak var lblItems: UILabel!
    
    var listItems: [Item]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if listItems?.count == 0 {
            lblItems.text = "Every product is ready"
        }
        else{
            let text = parse(list: listItems!)
            var string = ""
            for e in 0...text.amounts.count-1{
                string += text.items[e] + " x" + text.amounts[e] + ", "
            }
        
        string.removeLast()
        string.removeLast()
        lblItems.text = """
        These items are not in the store:
                         \(string)
        """
        }
    }
    
    func parse(list: [Item]) -> Text{
        var items = [String]()
        var amounts = [String]()
        for e in list{
            items.append(e.name)
            amounts.append(e.amount)
        }
        return Text(items: items, amounts: amounts)
    }
    

    @IBAction func backButtonClick(_ sender: Any) {
        print("rabotai")
        performSegue(withIdentifier: "goback", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

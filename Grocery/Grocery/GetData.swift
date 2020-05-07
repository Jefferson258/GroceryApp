//
//  GetData.swift
//  Grocery
//
//  Created by TJ Kade on 5/3/20.
//  Copyright © 2020 nikita. All rights reserved.
//

import UIKit

class GetData : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var nameText = " "
    
    @IBOutlet weak var textField: UITextView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func done(_ sender: Any) {
        nameText = textField.text!
        
        var foodsSub = [String.SubSequence]()
        
        var foodsNums = [String]()
        
        var foodie = [String.SubSequence]()
        
        var items = [Item]()
        
        var str = " "
        
        var s = " "
        
        foodsSub = nameText.split { $0.isNewline }
        
        for food in foodsSub{
            foodsNums.append(String(food))
        }
        if(foodsNums.count == 2){
            for yeet in foodsNums{
                foodie = yeet.split(separator: " ")
                items.append(Item(name: String(foodie[0]), amount: String(foodie[1])))
            }
            
            for thing in items{
                str += thing.name
                str += ", "
            }
            str.removeLast()
            str.removeLast()
            
            for yodeling in items{
                s += yodeling.amount
                s += ", "
            }
            s.removeLast()
            s.removeLast()
        }
        
        let attributes = Attributes(ordertext: str, amount: s)
        var orderToSend = Data2(data: Order2(attributes: attributes))
        
        sendToServer(orderToSend, completion: { result in
        switch result {
        case .success(let message):
            print("Order added")
        case .failure(let error):
            print("Order was nor added \(error)")
            }
        })
        
    }
    
    func sendToServer(_ objectToSend: Data2, completion: @escaping(Result<Data, Error>) -> Void){
        guard let url = URL(string: "http://superkruto.pythonanywhere.com/orderssent/") else { return }
        do{
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(objectToSend)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, let jsonData = data else{
                    print("error1")
                    return
                }
                print(httpResponse.statusCode)
                
                do {
                    let messageData = try JSONDecoder().decode(Data.self, from: jsonData)
                    completion(.success(messageData))
                }
                catch{
                    print("fix later")
                }
            }
            dataTask.resume()
        }catch{
            print("error3")
        }
        
    }

    
}

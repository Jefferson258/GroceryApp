//
//  TableViewController.swift
//  Grocery
//
//  Created by nikita on 5/2/20.
//  Copyright © 2020 nikita. All rights reserved.
//

import UIKit
import Foundation

enum APIError:Error{
    case responseProblem
    case decodingProblem
    case encodingProblem
}


class TableViewController: UITableViewController {
    
    var data: [Item]?
    
    var toSend = [Item]()
    
    @IBOutlet weak var itemTable:
    UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //data = [CellData.init(name: "Coca-Cola", amount: "50"), CellData.init(name: "Bread", amount: "45")]
        
        //self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        //self.tableView.rowHeight = UITableView.automaticDimension
        //self.tableView.estimatedRowHeight = 200
        
        itemTable.dataSource = self
        itemTable.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "custom")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "custom")
        }
        
        cell?.textLabel?.text = "\(data![indexPath.row].name) x\(String(describing: data![indexPath.row].amount))"
        //tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        /*
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.name = data?[indexPath.row].name
        cell.amount = data?[indexPath.row].amount
        cell.layoutSubviews()
        */
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data!.count
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            toSend = toSend.filter({$0 != ((data?[(itemTable.indexPathForSelectedRow?.row)!])!)})
            for element in toSend{
                print(element.name, terminator: " ")
            }
            print()
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            toSend.append((data?[(itemTable.indexPathForSelectedRow?.row)!])!)
            for element in toSend{
                print(element.name, terminator: " ")
            }
            print()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    	
    @IBAction func clickSend(_ sender: Any) {
        var itemsLeft = [Item]()
        for i in data!{
            if !(toSend.contains(i)){
                itemsLeft.append(i)
            }
        }
        //var orderToSend = Order1(from: self)
        var orderText = ""
        var amountText = ""
        for e in itemsLeft{
            orderText += "\(e.name), "
            amountText += "\(e.amount), "
        }
        orderText.removeLast()
        orderText.removeLast()
        amountText.removeLast()
        amountText.removeLast()
        let attributes = Attributes(ordertext: orderText, amount: amountText)
        var orderToSend = Data3(data: Order3(attributes: attributes))
        
        sendToServer(orderToSend, completion: { result in
        switch result {
        case .success(let message):
            print("Order added")
        case .failure(let error):
            print("Order was nor added \(error)")
            }
        })
    }
    
    func sendToServer(_ objectToSend: Data3, completion: @escaping(Result<Data, Error>) -> Void){
        guard let url = URL(string: "http://superkruto.pythonanywhere.com/ordersincomplete/") else { return }
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
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  PassData.swift
//  Grocery
//
//  Created by TJ Kade on 5/3/20.
//  Copyright © 2020 nikita. All rights reserved.
//

import UIKit

class PassData : UIViewController, UITableViewDelegate,  UITableViewDataSource{
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.white
        return tv
    }()
    
    var f: String = ""
        
    var data = [Order]()
    var doneComplete = false
    var doneSent = false
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readJSONSent()
        readJSONComplete()
        while !doneSent{
            print("waiting1")
        }
        while !doneComplete{
            print("waiting2")
        }
        setupTableView()
        
        doneComplete = false
        doneSent = false
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refresher.addTarget(self, action: #selector(OrderTableViewController.refreshSwipe), for: UIControl.Event.valueChanged)
        tableview.addSubview(refresher)
    }
    
    
    @objc func refreshSwipe() {
        readJSONComplete()
        while !doneComplete {
            print("wait")
        }
        refresher.endRefreshing()
        tableview.reloadData()
        print("refreshed")
        doneSent = false
        doneComplete = false
    }
    
    
    
    
    func readJSONSent(){
        let url = URL(string: "http://superkruto.pythonanywhere.com/orderssent/")

        let session = URLSession.shared
        
        var orderList = [Order]()
        let dataTask = session.dataTask(with: url!) { (data1, response, error) in
            
            if error != nil || data1 == nil{
                print("error or no data")
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let orderListJSON = try decoder.decode(OrderList.self, from: data1!)
                
                for element in orderListJSON.data{
                    var listNames = element.attributes.ordertext.components(separatedBy: ", ")
                    var listAmounts = element.attributes.amount.components(separatedBy: ", ")
                    var listItems = [Item]()
                    for index in 0...listNames.count-1{
                        listItems.append(Item(name: listNames[index], amount: listAmounts[index]))
                    }
                    orderList.append(Order(list: listItems, id: element.id!))
                }
                print(orderList)
                self.doneSent = true
                print(self.data)
            }
            catch {
                print("error")
            }
            
        }
        dataTask.resume()
    }
    
    func readJSONComplete(){
        let url = URL(string: "http://superkruto.pythonanywhere.com/ordersincomplete/")

        let session = URLSession.shared
        
        var orderList = [Order]()
        let dataTask = session.dataTask(with: url!) { (data1, response, error) in
            
            if error != nil || data1 == nil{
                print("No info there")
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let orderListJSON = try decoder.decode(OrderList.self, from: data1!)
                
                for element in orderListJSON.data{
                    var listNames = element.attributes.ordertext.components(separatedBy: ", ")
                    var listAmounts = element.attributes.amount.components(separatedBy: ", ")
                    var listItems = [Item]()
                    for index in 0...listNames.count-1{
                        listItems.append(Item(name: listNames[index], amount: listAmounts[index]))
                    }
                    orderList.append(Order(list: listItems, id: element.id!))
                }
                print(orderList)
                self.data = orderList
                self.doneComplete = true
                print(self.data)
            }
            catch {
                print("error")
            }
            
        }
        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showdetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SubmitViewController{
            destination.listItems = data[(tableview.indexPathForSelectedRow?.row)!].list
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId") as? ThirtyDayCell
        cell?.backgroundColor = UIColor.white
        cell?.dayLabel.text = "Заказ №\(String(describing: data[indexPath.row].id))"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        tableview.register(ThirtyDayCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    class ThirtyDayCell: UITableViewCell {
        
        
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.red
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let dayLabel: UILabel = {
            let label = UILabel()
            label.text = "Day 1"
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            setupView()
        }
        
        func setupView() {
            addSubview(cellView)
            cellView.addSubview(dayLabel)
            self.selectionStyle = .none
            
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            dayLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
            dayLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            dayLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
            dayLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}

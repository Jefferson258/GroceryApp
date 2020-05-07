import UIKit

let tableview: UITableView = {
    let tv = UITableView()
    tv.backgroundColor = UIColor.white
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.separatorColor = UIColor.white
    return tv
}()

class Item : Comparable {
    var name: String
    var amount: String
    
    init(name:String, amount:String){
        self.name = name
        self.amount = amount
    }
    static func < (lhs: Item, rhs: Item) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
    }
}
class Order {
    var id: String
    var list: [Item]
    
    init(list:[Item], id:String){
        self.id = id
        self.list = list
    }
}

class OrderTableViewController: UITableViewController{

    @IBOutlet weak var orderTable:
    UITableView!
    
    var data = [Order]()
    var done = false
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //assign data to json
        readJSON()
        while !done{
            print("waiting")
        }
        //orderTable.dataSource = self
        //orderTable.delegate = self
        done = false
        setupTableView()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refresher.addTarget(self, action: #selector(OrderTableViewController.refreshSwipe), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    
    
    
    func readJSON(){
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
                self.data = orderList
                self.done = true
                print(self.data)
            }
            catch {
                print("error")
            }
            
        }
        dataTask.resume()
    }
    
    @objc func refreshSwipe() {
        data = []
        readJSON()
        while !done {
            print("wait")
        }
        refresher.endRefreshing()
        tableView.reloadData()
        print("refreshed")
        done = false
    }
    

    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId1") as? ThirtyDayCell
        cell?.backgroundColor = UIColor.white
        cell?.dayLabel.text = "Заказ №\(String(describing: data[indexPath.row].id))"
        return cell!
//        var cell = tableView.dequeueReusableCell(withIdentifier: "order")
//        if cell == nil{
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "order")
//        }
//
//        cell?.textLabel?.text = "Order \(String(describing: data[indexPath.row].id))"
//        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TableViewController{
            destination.data = data[(orderTable.indexPathForSelectedRow?.row)!].list
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId1")
        
        tableview.register(ThirtyDayCell.self, forCellReuseIdentifier: "cellId1")
        
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

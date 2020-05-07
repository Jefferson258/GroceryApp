import UIKit
import Foundation

//// MARK: - Order
//struct OrderList: Codable {
//    let data: [Order1]
//}
//
//// MARK: - Datum
//struct Order1: Codable {
//    let type: String
//    let id: String?
//    let attributes: Attributes
//}
//
//// MARK: - Attributes
//struct Attributes: Codable {
//    let ordertext, amount: String
//}

// MARK: - Order
class OrderList: Codable {
    let data: [Order1]

    init(data: [Order1]) {
        self.data = data
    }
}

// MARK: - Datum
class Order1: Codable {
    let type: String
    let id: String?
    let attributes: Attributes

    init(type: String, id: String, attributes: Attributes) {
        self.type = type
        self.id = id
        self.attributes = attributes
    }
}

// MARK: - Attributes
class Attributes: Codable {
    let ordertext, amount: String

    init(ordertext: String, amount: String) {
        self.ordertext = ordertext
        self.amount = amount
    }
}




//Sending OrdersSent
class OrderList2: Codable {
    let data: [Order2]

    init(data: [Order2]) {
        self.data = data
    }
}

// MARK: - Datum
class Data2: Codable {
    let data: Order2
    init(data: Order2) {
        self.data = data
    }
}
class Order2: Codable {
    let type = "OrderSent"
    let attributes: Attributes

    init(attributes: Attributes) {
        self.attributes = attributes
    }
}

//Sending Orders Incomplete
class OrderList3: Codable {
    let data: [Order3]

    init(data: [Order3]) {
        self.data = data
    }
}
class Data3: Codable {
    let data: Order3
    init(data: Order3) {
        self.data = data
    }
}
class Order3: Codable {
    let type = "OrderIncomplete"
    let attributes: Attributes

    init(attributes: Attributes) {
        self.attributes = attributes
    }
}

//Sendinf regular orders
class OrderList4: Codable {
    let data: [Order4]

    init(data: [Order4]) {
        self.data = data
    }
}
class Data4: Codable {
    let data: Order4
    init(data: Order4) {
        self.data = data
    }
}
class Order4: Codable {
    let type = "Order"
    let attributes: Attributes

    init(attributes: Attributes) {
        self.attributes = attributes
    }
}

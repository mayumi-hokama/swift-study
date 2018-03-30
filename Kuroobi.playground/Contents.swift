//: Playground - noun: a place where people can play

import UIKit

struct User: ProfileDataProtocol {
    var id: String
    let nickname: String
}

struct Room: ProfileDataProtocol {
    var id: String
    var roomName: String
    
    func getName() -> String {
        return roomName
    }
    
    mutating func getName(_ name: String) -> String {
        roomName = name
        return roomName
    }
}

protocol ProfileDataProtocol {
    var id: String { get set }
}
extension ProfileDataProtocol {
    var toUserId: String {
        set {
            self.id = newValue
        }
        get {
            return self.id
        }
    }
}

var roomA = Room(id: "1", roomName: "Aルーム")
var roomB = roomA

print(roomA.id)
print(roomA.roomName)
print(roomA.getName("不明"))

roomA.toUserId = "3"
print(roomA.id)
print(roomB.id)

for val in 0..<9 where val != 5 {
    print(val)
}

let value = "みかん"
switch value {
case let x where x.hasPrefix("み"):
    print("みかん")
case "りんご":
    print("りんご")
default:
    print("その他")
}

enum Fluit {
    case orange, apple
}

let fluits: [Fluit] = [.apple, .orange, .apple, .apple]

for case .apple in fluits {
    print("Appleだ")
}

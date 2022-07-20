import UIKit

enum Example {
    case chatMessage
    case photosCollection
    case barGraph
    
    static let count = 3
    
    func controller() -> ViewController {
        return ViewController()
    }
    
    var title: String {
        switch self {
        case .chatMessage: return "Chat Messages"
        case .photosCollection: return "Album da Copa"
        case .barGraph: return "Bar Graph"
        }
    }
}

import Foundation

protocol EndPointType {
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}

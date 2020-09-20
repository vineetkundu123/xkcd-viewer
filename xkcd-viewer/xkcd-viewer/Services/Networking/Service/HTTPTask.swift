import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    //More tasks can be added here such as if we want to add more headers for authentication etc.
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
}

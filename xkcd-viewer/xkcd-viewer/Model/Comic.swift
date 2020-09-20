import Foundation

struct Comic: Decodable {
    //Only mapping useful properties from the API object
    var num: Double?
    var day: String?
    var month: String?
    var year: String?
    var title: String?
    var alt: String?
    var img: String?
}

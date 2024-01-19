import Foundation

struct PictureBody: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadURL = "download_url"
    }
}

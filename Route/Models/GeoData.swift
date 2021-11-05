import Foundation

//MARK: Модель данных для декодирования json

struct GeoData: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let geometry: Geometry
}

struct Geometry: Codable {
    let coordinates: [[[[Double]]]]
}

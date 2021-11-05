import Foundation
import MapKit

class MultiPolyline {
    
    static var shared: MultiPolyline = {
        let instance = MultiPolyline()
        return instance
    }()
    
    func getMultiPolyline(coordinates: GeoData, complition: @escaping (_ polyline: MKMultiPolyline, _ distance: Double)-> ()) { // метод для создания MultiPolyline из модели данных и расчета дистанции
        
        var polylines = [MKPolyline]()
        var coordinates2D = [[CLLocationCoordinate2D]]()
        var multiPolyline = MKMultiPolyline()
        var distance = Double()
        
        guard let geometry = coordinates.features.first?.geometry else { return }
        
        let coordinatesArrays = geometry.coordinates.flatMap{$0}
        
        for (index, coordArray) in coordinatesArrays.enumerated() { //Double -> CLLocationCoordinate2D
            coordinates2D.append([])
            coordArray.forEach { location in
                coordinates2D[index].append(CLLocationCoordinate2D(latitude: location[1], longitude: location[0]))
            }
        }
        
        for (index, coordinates) in coordinates2D.enumerated() { //CLLocationCoordinate2D -> MKPolylines
            polylines.append(MKPolyline(coordinates: coordinates, count: coordinates2D[index].count))
        }
        
        for coordinates in coordinates2D { //Расчет дистанции
            if coordinates.count > 1 {
                for i in 0..<coordinates.count - 1 {
                    distance += CLLocation.distance(from: coordinates[i], to: coordinates[i + 1])
                }
            }
        }
        
        multiPolyline = MKMultiPolyline(polylines) //MKPolylines -> MKMultiPolyline
        complition(multiPolyline, distance / 1000)
    }
    
}


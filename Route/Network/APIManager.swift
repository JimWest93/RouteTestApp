import Foundation
import MapKit

class APIManager {
    
    static var shared: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    private let url = "https://waadsu.com/api/russia.geo.json"
    
    func fetchGeoData(complition: @escaping (GeoData) -> ()) { //метод для получения и декодирования данных json
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let data = try JSONDecoder().decode(GeoData.self, from: data)
                
                DispatchQueue.main.async {
                    complition(data)
                }
                
            } catch {
                fatalError("Unable to decode JSON")
            }
            
        }.resume()
    }
}

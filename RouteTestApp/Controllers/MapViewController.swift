import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    private let indicatorView = UIActivityIndicatorView()
    
    private let APImanager = APIManager.shared
    private let multiPolylineCreator = MultiPolyline.shared

    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewsSetup()
        getRoute()
    }
    
    private func viewsSetup() { //настройка аутлетов
        mapView.delegate = self
        distanceLabel.text = "Distance: "
        indicatorView.frame = mapView.bounds
        mapView.addSubview(indicatorView)
        indicatorView.startAnimating()
        mapView.mapType = MKMapType.hybrid
    }
    
    private func getRoute() { //получение маршрута
        APImanager.fetchGeoData { [weak self] coordinates in
            self?.multiPolylineCreator.getMultiPolyline(coordinates: coordinates) { polyline, distance in
                self?.indicatorView.removeFromSuperview()
                self?.indicatorView.stopAnimating()
                self?.mapView.addOverlay(polyline)
                self?.distanceLabel.text! += String(format: "%.2f", distance) + "km"
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = overlay as? MKMultiPolyline {
            let renderer = MKMultiPolylineRenderer(overlay: route)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
}


import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var tileRenderer: MKTileOverlayRenderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let overlay = CustomOverlay()
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay)
        tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
        mapView.delegate = self
        
        CLGeocoder().geocodeAddressString("Austin, TX") { (placemarks, errorse) in
            self.mapView.addAnnotation(MKPlacemark(placemark: placemarks!.first!))
        }
        CLGeocoder().geocodeAddressString("Houston, TX") { (placemarks, errorse) in
            self.mapView.addAnnotation(MKPlacemark(placemark: placemarks!.first!))
        }
        CLGeocoder().geocodeAddressString("Amarillo, TX") { (placemarks, errorse) in
            self.mapView.addAnnotation(MKPlacemark(placemark: placemarks!.first!))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }


}

extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return tileRenderer
    }
    
}

class CustomOverlay: MKTileOverlay {
    
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let resourceUrl = Bundle.main.url(forResource: "\(path.y)", withExtension: "png", subdirectory: "tiles/\(path.z)/\(path.x)")
        if let tileUrl = resourceUrl {
            return tileUrl
        }
        return URL(string: "https://tile.openstreetmap.org/\(path.z)/\(path.x)/\(path.y).png")!
    }
    
}

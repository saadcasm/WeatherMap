import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var place = ""
    var latitude = ""
    var longitude = ""
    var temperature = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.title = place
        annotation.subtitle = "Currently \(temperature)°C"
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
        
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = annotation.coordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        annotationView?.image = UIImage(named: "annotation_pin")
        annotationView?.canShowCallout = true
        
        return annotationView
    }
}

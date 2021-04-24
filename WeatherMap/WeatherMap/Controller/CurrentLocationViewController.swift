import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentlyLabel: UILabel!
    @IBOutlet weak var centigradeLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var goToMapButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    var latitudeValue = 0.0
    var longitudeValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRoundButton()
        launchScreenSettings(hidden: true)
        
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func launchScreenSettings(hidden: Bool) {
        conditionImageView.isHidden = hidden
        temperatureLabel.isHidden = hidden
        longitudeLabel.isHidden = hidden
        latitudeLabel.isHidden = hidden
        cityLabel.isHidden = hidden
        goToMapButton.isHidden = hidden
        centigradeLabel.isHidden = hidden
        currentlyLabel.isHidden = hidden
        instructionLabel.isHidden = !hidden
    }
    
    func configureRoundButton() {
        goToMapButton.layer.cornerRadius = 20
        
        goButton.frame = CGRect(x: 357, y: 100, width: 39, height: 39)
        goButton.layer.cornerRadius = 0.5 * goButton.bounds.size.width
        goButton.clipsToBounds = true
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
    @IBAction func goToMap(_ sender: Any) {
        performSegue(withIdentifier: "GoToMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToMap" {
            let controller = segue.destination as! MapViewController
            controller.place = cityLabel.text!
            controller.latitude = String(latitudeValue)
            controller.longitude = String(longitudeValue)
            controller.temperature = temperatureLabel.text!
        }
    }
}

extension CurrentLocationViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

extension CurrentLocationViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            
            self.getCoordinateFrom(address: weather.cityName) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.latitudeValue = coordinate.latitude
                    self.longitudeValue = coordinate.longitude
                    
                    self.latitudeLabel.text = String(self.latitudeValue)
                    self.longitudeLabel.text = String(self.longitudeValue)
                }
            }
            
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.condtionName)
            self.conditionImageView.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            self.cityLabel.text = weather.cityName
            self.launchScreenSettings(hidden: false)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

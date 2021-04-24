import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double

    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var condtionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 801...804:
            return "cloud"
        case 800:
            return "sun.min"
        case 701:
            return "drop"
        case 711:
            return "smoke"
        case 721:
            return "sun.haze"
        case 731:
            return "sun.dust"
        case 741:
            return "cloud.fog"
        case 751:
            return "sparkles"
        case 762:
            return "sparkles"
        case 771:
            return "wind"
        case 781:
            return "tornado"
        default:
            return "cloud"
        }
    }
}

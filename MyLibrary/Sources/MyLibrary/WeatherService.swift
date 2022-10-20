import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}


enum Url : String {
    case real_weather = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"
    case mock_server = "http://localhost:3000"
    
}

class WeatherServiceImpl: WeatherService {

    let url = "http://localhost:3000"

    func getTemperature() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                switch response.result {
                case let .success(weather):
                    let temperature = weather.main.temp
                    let temperatureAsInteger = Int(temperature)
                    continuation.resume(with: .success(temperatureAsInteger))

                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
    
}

public struct Weather: Decodable {
    let main: main

    struct main: Decodable {
        let temp: Double
    }
}

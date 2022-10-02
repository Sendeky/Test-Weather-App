//
//  MainVC.swift
//  Getting the location
//
//  Created by RuslanS on 6/13/22.
//

import UIKit
import SwiftyJSON

// We need global variables because i don't know how to make sure that they have the updated values when passing variables between View Controllers
var globalUserLatitude = 0.0
var globalUserLongitude = 0.0
var localDateArray = [String]()
var sortedArray = [String]()


struct WeatherData {
    static var weatherTemp = ""
    static var weatherTempMin = ""
    static var weatherTempMax = ""
    static var weatherDesc = ""
    static var cityName = ""
}

class MainVC: UIViewController {
    

    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempLabelMin: UILabel!
    @IBOutlet weak var tempLabelMax: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    

    let shape = CAShapeLayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 300, y: 100),
                                      radius: 50,
                                      startAngle: .pi,
                                      endAngle: .pi * 2,
                                      clockwise: true)
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 15
        trackShape.strokeColor = UIColor.lightGray.cgColor
        scrollView.layer.addSublayer(trackShape)
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 15
        shape.strokeColor = UIColor.blue.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        
        
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)
        scrollView.layer.addSublayer(shape)
        
        
        let UVIndexCalculate = DateUVIndexCalculate()
        UVIndexCalculate.calculateUVIndex()
        
        
        let API_KEY = "f2c07a8a58926a5ea9caa5e00b95167a"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(globalUserLatitude)&lon=\(globalUserLongitude)&appid=\(API_KEY)"
        let urlString2 = "https://api.openweathermap.org/data/2.5/forecast?lat=\(globalUserLatitude)&lon=\(globalUserLongitude)&appid=\(API_KEY)"
        
        //Runs on background thread so that UI doesn't freeze up
        DispatchQueue.global().async {
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let result = JSON(data)
                    
                    print(result)
                    
                    WeatherData.weatherTemp = result["main"]["temp"].stringValue
                    WeatherData.weatherTempMin = result["main"]["temp_min"].stringValue
                    WeatherData.weatherTempMax = result["main"]["temp_max"].stringValue
                    WeatherData.weatherDesc = result["weather"][0]["description"].stringValue
                    WeatherData.cityName = result["name"].stringValue
                    
                    
                    let weatherTempDouble = Double(WeatherData.weatherTemp)
                    let weatherTempMinDouble = Double(WeatherData.weatherTempMin)
                    let weatherTempMaxDouble = Double(WeatherData.weatherTempMax)
                    
                    
                    let weatherTempCelsius = round(weatherTempDouble! - 273.0)
                    let weatherTempMinCelsius = round(weatherTempMinDouble! - 273.0)
                    let weatherTempMaxCelsius = round(weatherTempMaxDouble! - 273.0)
                    
                    
                    // TODO: - Use animate:() to animate the changing of the location of the ui elements
                    
                    
                    //Runs on main thread so that the UI updates
                    DispatchQueue.main.async {
                        self.tempLabel.text = "\(Int(weatherTempCelsius))˚"
                        self.tempLabelMin.text = "\(Int(weatherTempMinCelsius))˚"
                        self.tempLabelMax.text = "\(Int(weatherTempMaxCelsius))˚"
                        self.locationLabel.text = "\(WeatherData.cityName)"
                        
                        
                        // TODO: - parameters for weather icons by temperature
                        switch WeatherData.weatherDesc {
                        case "clear sky":
                            self.imageView.image = UIImage(named: "sunny_icon")
                        case "few clouds":
                            self.imageView.image = UIImage(named: "mostly_sunny_icon")
                        case "scattered clouds":
                            self.imageView.image = UIImage(named: "cloudy_icon")
                        case "overcast clouds":
                            self.imageView.image = UIImage(named: "cloudy_icon")
                        case "broken clouds":
                            self.imageView.image = UIImage(named: "mostly_cloudy_icon")
                        case "light rain":
                            self.imageView.image = UIImage(named: "light_rain_icon")
                        case "rain":
                            self.imageView.image = UIImage(named: "rain_icon")
                        case "thunderstorm":
                            self.imageView.image = UIImage(named: "thunderstorm_icon")
                        case "mist":
                            self.imageView.image = UIImage(named: "haze_fog_icon")
                        default:
                            self.imageView.image = UIImage(named: "error_icon")
                        }
                    }
                }
            }
        }
//        Second dispatch to get the forecast json from the url
        DispatchQueue.global().async {
            if let url2 = URL(string: urlString2) {
                if let data2 = try? Data(contentsOf: url2) {
                    let result2 = JSON(data2)

//                    print(result2)

                    // for loop to put the json data into the variables
                    let count = 0...39
                    for number in count {
                        let forecastDate = result2["list"][number]["dt"].doubleValue
                        let forecastTemp = result2["list"][number]["main"]["temp"].doubleValue
                        let date = NSDate(timeIntervalSince1970: forecastDate)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = DateFormatter.Style.medium    //Set time style
                        dateFormatter.dateStyle = DateFormatter.Style.medium    //Set date style
                        dateFormatter.timeZone = .current                       //Set time zone
                        dateFormatter.dateFormat = "dd.MM.yy"
                        let localDate = dateFormatter.string(from: date as Date)
                        localDateArray.append(localDate)                        //Appends the date into the array (includes positioning ie. [0],[1],etc.)
                        sortedArray = localDateArray.sorted(by: { $0.compare($1) == .orderedDescending})
                        print(sortedArray[number])
                        print(forecastTemp)
                    }
                }
            }
        }
    }
    @IBAction func uvButtonClicked(_ sender: Any) {
        //Animate the UV Index circle
        let animationSpeedInt = 1
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = (Float(UVIndex.UVIndex))/10
        animation.duration = 10
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        let count = 1...10
        for i in count {
            animation.speed = Float(animationSpeedInt + (i * 2))
        }
        shape.add(animation, forKey: "animation")
//        let test = DateUVIndexCalculate()
//        test.calculateUVIndex()
//        print(Float(UVIndex.UVIndex))
    }
}
    

    


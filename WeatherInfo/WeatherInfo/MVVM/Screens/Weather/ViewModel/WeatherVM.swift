//
//  WeatherVM.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation
import CoreLocation

class WeatherVM {
    var weatherManager = WeatherManager()
     var weatherModel = WeatherModel()
     var onCompleted:((WeatherModel)->())?
     var onErrorResponse:((APIError)->())?
     var onImageComp: ((Data)->())?
     var date = String()
     var templbl = String()
     var tempDescp = String()
     var sunriseLbl = String()
     var sunsetLbl = String()
     var windLbl = String()
     var pressureLbl = String()
     var temperatureLbl = String()
     var humidityLbl = String()
     var cityLbl = String()
     
     func getWeatherDetails(searchPlace:String) {
         weatherManager.weatherResponse(place: searchPlace) { (result) in
             switch result {
             case .success(let response):
                 guard (response != nil) else {
                     self.onErrorResponse?(APIError.requestFailed)
                     return
                 }
                 self.weatherModel = response!
                 self.weatherCalculation()
                 
             case .failure(let error):
                 self.onErrorResponse?(error)
             }
         }
     }
     
     func  displayDate(dateStr:Int)->String{
        
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "EEE dd MMMM"
         let newDate = Date(timeIntervalSince1970: Double(dateStr))
         let dates = dateFormatter.string(from: newDate)
         print(dates)
         
      return dates
     }
     
     func  displayTime(dateStr:Int)->String{
        
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "HH:mm"
         let newDate = Date(timeIntervalSince1970: Double(dateStr))
         let dates = dateFormatter.string(from: newDate)
         print(dates)
         
      return dates
     }
     
     func imageDisplay(id:String){
         weatherManager.imageResponse(icon: id) { (result) in
             
             switch result {
             case .success(let response):
                 self.onImageComp?(response)
             case .failure(let error):
                 self.onErrorResponse?(error)
                 
             }
         }
     }
     func temperatureConversion(celicus: Double)->String{
       //  let measurement = Measurement(value: celicus, unit: UnitTemperature.celsius)

         let measurementFormatter = MeasurementFormatter()
         measurementFormatter.unitStyle = .short
         measurementFormatter.numberFormatter.maximumFractionDigits = 0
         measurementFormatter.unitOptions = .temperatureWithoutUnit
         let measurementInKelvin = Measurement(value: celicus, unit: UnitTemperature.kelvin)
         let measurements = measurementInKelvin.converted(to: .celsius)
         let temp = measurementFormatter.string(from: measurements) + "C"
         
         return temp
         
     }
     func weatherCalculation(){
         date = self.displayDate(dateStr: self.weatherModel.date ?? 0)
         cityLbl = self.weatherModel.name ?? ""
         let celicus  = self.weatherModel.main?.temperature ?? 0
       templbl  = temperatureConversion(celicus: celicus)
       tempDescp = self.weatherModel.weather?[0].description ?? ""
         
         //let id = self.weatherModel.weather?[0].icon ?? ""
       //  self.weatherVM.imageDisplay(id:id)
         
         let wind = self.weatherModel.wind?.speed ?? 0
         let temperature = self.weatherModel.main?.temperature ?? 0
         let pressure = self.weatherModel.main?.pressure ?? 0
         
         windLbl = String(wind) + "m/s"
         temperatureLbl = temperatureConversion(celicus: temperature)
         pressureLbl = String(pressure)
         
         self.onCompleted?(self.weatherModel)
     }
     
     func getCityNameUsingLatLog(_ latitude:Double ,_ longitude:Double) {
         let location = CLLocation.init(latitude: latitude, longitude: longitude)
         location.fetchCityName { (city ,error) in
            print(city)
             DispatchQueue.main.async {
                 self.getWeatherDetails(searchPlace: city ?? "")

             }
         }
         print(location)
         
     }
 }

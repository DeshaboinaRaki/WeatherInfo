//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController,NormalAlert,ShowAlert {
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var cityLbl : UILabel!
    @IBOutlet weak var tempLbl : UILabel!
    @IBOutlet weak var descTempLbl : UILabel!
    @IBOutlet weak var tempImageView : UIImageView!
    @IBOutlet weak var sunriseLbl : UILabel!
    @IBOutlet weak var sunsetLbl : UILabel!
    @IBOutlet weak var humidityLbl : UILabel!
    @IBOutlet weak var windLbl : UILabel!
    @IBOutlet weak var pressureLbl : UILabel!
    @IBOutlet weak var temperatureLbl : UILabel!
    var weatherVM = WeatherVM()
    var weatherModel = WeatherModel()
    var locationManager : CLLocationManager?
    var hasPermission = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
     //   searchBar.barTintColor = .clear
    
        weatherResponse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForLocationEnabled()
     

    }
    func checkForLocationEnabled(){
        // check for permission
                self.locationManager = CLLocationManager()
                self.locationManager?.delegate = self
     //   self.locationManager?.requestWhenInUseAuthorization()
   
            
    }

    
    func weatherResponse() {
        weatherVM.onCompleted = {[weak self] result in
            print(result)
            self?.weatherModel = result
            DispatchQueue.main.async {
                self?.weatherDisplay()
            }
        }
        weatherVM.onErrorResponse = { error in
            
            DispatchQueue.main.async {
                self.normalAlert(title: alertContent.title, message: error.description, {})
            }
            
        }
       
        
        weatherVM.onImageComp = { data in
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.tempImageView.image = image
                
            }
          
        }
    }
    //MARK:- display UI
    func weatherDisplay(){
        
        self.dateLbl.text = self.weatherVM.date
        self.cityLbl.text = self.weatherVM.cityLbl
        
        self.tempLbl.text = self.weatherVM.templbl
        
        self.descTempLbl.text = self.weatherVM.tempDescp
        let id = self.weatherModel.weather?[0].icon ?? ""
        self.weatherVM.imageDisplay(id:id)
        self.pressureLbl.text = self.weatherVM.pressureLbl
        self.humidityLbl.text = self.weatherVM.humidityLbl
        self.sunriseLbl.text = self.weatherVM.sunriseLbl
        self.sunsetLbl.text = self.weatherVM.sunsetLbl
        self.windLbl.text = self.weatherVM.windLbl
        self.temperatureLbl.text = self.weatherVM.temperatureLbl
      
        let sunrise = weatherVM.displayTime(dateStr: weatherModel.system?.sunrise ?? 0)
        let sunset = weatherVM.displayTime(dateStr: weatherModel.system?.sunset ?? 0)
        
        let humidity = weatherModel.main?.humidity ?? 0
        
        sunriseLbl.text = sunrise
        sunsetLbl.text = sunset
        humidityLbl.text = String(humidity) + " %"
       
    }
    //MARK:- Alerts
    func alertResponse(message:String){
        normalAlert(title: alertContent.title, message: message, {})
    }
    func openSettingForPermission(){
        if !hasPermission {
            
            showAlert(title: alertContent.permissionTitle, message: alertContent.permissionMsg) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.canOpenURL(url)
                }
            } _: {
                
            }

      
        }
    }
}
extension WeatherVC: UISearchBarDelegate,CLLocationManagerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        let finalText =  searchText + ",US"
      //  locationManager?.startUpdatingLocation()
       weatherVM.getWeatherDetails(searchPlace: finalText)
    }
    
//MARK:- location manager delegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        hasPermission = false
        //check for location is accessed
        let status = manager.authorizationStatus
        
        switch status {
        case . notDetermined:
            locationManager?.requestWhenInUseAuthorization()
            hasPermission = false
            
            break
        case .authorizedAlways ,.authorizedWhenInUse:
            print("access")
            locationManager?.startUpdatingLocation()
            hasPermission = true
        case .restricted ,.denied:
            print("not accessed\(status)")
            hasPermission = false
            openSettingForPermission()
        default:
            print("")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        if let location = locations.last {
            let latitide = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            weatherVM.getCityNameUsingLatLog(latitide, longitude)
        }
                
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        locationManager?.stopUpdatingLocation()
        alertResponse(message: error.localizedDescription)
       
    }
    
    
}



//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Intents
import CoreSpotlight
import CoreServices



class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate  {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b46a4e401e9e0f50342ccc170f68fe78"
    var isCelcius : String = ""
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Requesting auth for siri
        INPreferences.requestSiriAuthorization { (status) in
            
        }
        
        if #available(iOS 12.0, *) {
            userActivity?.isEligibleForPrediction = true
        } else {
           
        }
        
       //setupIntents()
        //setupIntents2()
        
    }
    
    
    
    
    @available(iOS 12.0, *)
    func setIntent()-> WeatherCityIntent{
  
            let intent = WeatherCityIntent()
            intent.city = "New York"
            let interaction = INInteraction(intent: intent, response: nil)
            
            interaction.donate { (error) in
                
            }
       return intent
    }

    func setupIntents() {
        let activity = NSUserActivity(activityType: "com.YourName.Climaaaf.sayHi")
        activity.title = "Look up weather in city" //object.name
        activity.isEligibleForSearch = true
        activity.userInfo = ["key" : "value"]
        if #available(iOS 12.0, *) {
            activity.suggestedInvocationPhrase = "Weather in city"
        } else {

        }
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)

        attributes.contentDescription = "Get the Weather before you leave"

        activity.contentAttributeSet = attributes
       


        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {

        }
        if #available(iOS 12.0, *) {
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier("com.YourName.Climaaaf.sayHi")
        } else {

        }
        self.userActivity = activity
       activity.becomeCurrent()
    }
    
    func setupIntents2() {
        let activity = NSUserActivity(activityType: "com.YourName.Climaaaf.sayHi2")
        activity.title = "look up something else" //object.name
        activity.isEligibleForSearch = true
        activity.userInfo = ["key" : "value"]
        if #available(iOS 12.0, *) {
            activity.suggestedInvocationPhrase = "Weather in city"
        } else {
            
        }
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        
        attributes.contentDescription = "now"
        
        activity.contentAttributeSet = attributes
       
        
        
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {
            
        }
        if #available(iOS 12.0, *) {
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier("com.YourName.Climaaaf.sayHi2")
        } else {
            
        }
        self.userActivity = activity
        activity.becomeCurrent()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getWeatherData(url: String, parameters: [String : String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            }else{
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
                }
            }
        }

    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    func updateWeatherData(json : JSON){
        
        if let tempResult = json["main"]["temp"].double {
        weatherDataModel.temperature = Int(tempResult)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
        updateUIWithWeatherData()
            
        }
        else{
            cityLabel.text = "Weather Unavailable"
        }
    }
    

    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID, "units" : "imperial"]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        let params :  [String : String] = ["q" : city, "appid" : APP_ID, "units" : "imperial"]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

    
    //Write the PrepareForSegue Method here

    
    override func prepare(for seque: UIStoryboardSegue, sender: Any?){
        if seque.identifier == "changeCityName" {
            if #available(iOS 12.0, *) {
                let destinationVC = seque.destination as! ChangeCityViewController
                destinationVC.delegate = self
            } else {
                // Fallback on earlier versions
            }
            
            
        }
    }
    
  
    
}



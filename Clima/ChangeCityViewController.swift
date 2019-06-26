//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Intents
import IntentsUI
import Alamofire

//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnteredANewCityName (city : String)
   
}


@available(iOS 12.0, *)
class ChangeCityViewController: UIViewController, INUIAddVoiceShortcutViewControllerDelegate, ShowTSVIntentHandling{
    
    func handle(intent: ShowTSVIntent, completion: @escaping (ShowTSVIntentResponse) -> Void) {
        print("test")
    }
    
 


    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error{
            print(error.localizedDescription)
        }

         controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
  
    override func viewDidLoad() {
     
    }
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        let cityName = changeCityTextField.text!
        
        delegate?.userEnteredANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCity(cityName: String){
        delegate?.userEnteredANewCityName(city: cityName)
    }

    
    
    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
    }
    @IBAction func mainPageButtonPressed(_ sender: UIButton) {
        
     
    }
    
    @IBAction func secondPageButtonPressed(_ sender: UIButton) {
        
        let intent = ShowTSVIntent()
        let shortcut = INShortcut(intent: intent)

        let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut!)
        vc.delegate = self

//        let coder = NSCoder()
//        coder.encode(DeepLink(url: "this is a url"), forKey: "url")
//        let response = INIntentResponse(coder: coder)
        //will allow you to donate a response or an object to the intent
//        let interaction = INInteraction(intent: intent, response: response)
//        interaction.donate { (error) in
//            print("donated")
//        }
        self.present(vc, animated: true, completion: nil)

    }
}

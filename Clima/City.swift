//
//  City.swift
//  Clima
//
//  Created by Anthony Rogers on 6/20/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import Intents

class City{
    
    var city: String
    
    init(city: String){
        self.city = city
    }
    
}

extension City{

    @available(iOS 12.0, *)
    public func setIntent()-> INIntent{
        
        let intent = WeatherCityIntent()
        intent.city = "New York="
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            
        }
        return intent
    }
    
}

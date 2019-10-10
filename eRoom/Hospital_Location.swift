//
//  Hospital_Location.swift
//  eRoom
//
//  Created by Roe Iton on 1/8/19.
//  Copyright © 2019 Roe Iton. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Hospital_Location{
    
    var longiutde: Double!
    var latitude: Double!
    
    var destination: String!
    
    init(d_latitude: Double, d_longitude: Double){
        
        self.latitude = d_latitude;
        self.longiutde = d_longitude;
        self.destination = String(d_latitude) + "%2C" + String(d_longitude);
    }
    
    //Function that returns the latitude
    func GetLatitude() -> Double {
        return latitude;
    }
    
    //Function that returns the longitude
    func GetLongitude() -> Double {
        return longiutde;
    }
}

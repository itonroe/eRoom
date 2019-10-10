//
//  Hospital.swift
//  eRoom
//
//  Created by Roe Iton on 1/8/19.
//  Copyright © 2019 Roe Iton. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class Hospital{
    var name: String!
    var firstline: Int!
    var lastline: Int!
    var doctors: Int!
    var avg_app: Int!
    var avg_com: Int!
    var park: Int!
    var time: Int!
    
    var location: Hospital_Location!
    
    var insurance: String!
    
    init(name:String!,
         d_latitude:Double!,
         d_longitude:Double!){
        
        self.name = name;
        
        location = Hospital_Location(d_latitude: d_latitude, d_longitude: d_longitude)
    }
    
    init(name:String!,
         insurance:String!,
         d_latitude:Double!,
         d_longitude:Double!){
        
        self.name = name;
        self.insurance = insurance;
        
        location = Hospital_Location(d_latitude: d_latitude, d_longitude: d_longitude)
    }
    
    //Function that sets online Data from Firebase
    func SetOnlineDate(firstline: Int!,
                       lastline: Int!,
                       doctors: Int!,
                       avg_app: Int!,
                       avg_com: Int!,
                       park: Int!){
        
        self.firstline = firstline;
        self.lastline = lastline;
        self.doctors = doctors;
        self.avg_app = avg_app;
        self.avg_com = avg_com;
        self.park = park;
    }
    
    //Function that returns the number of People
    func GetPeople() -> Int{
        return lastline - firstline;
    }
    
    //Function that returns the Longitude
    func GetLatitude() -> Double{
        return location.GetLatitude();
    }
    
    //Function that returns the Latitude
    func GetLongitude() -> Double{
        return location.GetLongitude();
    }
    
    //Function that returns the Calculated Time in Minutes
    func GetTime() -> Int{
        return time;
    }
    
    //Function that returns the Insurance
    func GetInsurance() -> String{
        return insurance;
    }
}

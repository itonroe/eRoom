//
//  Sechos_ViewController.swift
//  eRoom
//
//  Created by Roe Iton on 1/12/19.
//  Copyright © 2019 Roe Iton. All rights reserved.
//

import UIKit
import Alamofire

class Sechos_ViewController: UIViewController{
    
    @IBOutlet weak var hospital_Logo: UIImageView!
    @IBOutlet weak var lbl_Time_Hours: UILabel!
    @IBOutlet weak var lbl_Time_Minutes: UILabel!
    @IBOutlet weak var lbl_Minutes: UILabel!
    @IBOutlet weak var btn_Go: UIButton!
    
    //Current Location
    var current_Latitude: Double!
    var current_Longitude: Double!
    
    var hospitals: [Hospital]!
    
    //Times
    var sortedIndexHospital: [Int] = [];
    
    var currentH: Int!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionR(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        getDurationFromGoogleMaps();
    }
    
    //Function that orginizes the list of the hospitals, Shortes to Lognest
    func OrginizeFtoS(timeTo: [Int]) -> [Int]{
        var index_OfLowToHigh = [Int](repeating: 0, count: hospitals.count);
        var j = 0;
        
        var new_timeTo = timeTo
        
        var times = [Bool](repeating: false, count: hospitals.count);
        
        //Find Max
        let max = new_timeTo.max();
        
        while j < index_OfLowToHigh.count {
            var min = max;
            var min_i = 0;
            
            for i in 0...(new_timeTo.count - 1){
                if((new_timeTo[i] <= min!) && (!times[i])){
                    min = new_timeTo[i];
                    min_i = i;
                }
            }
            
            times[min_i] = true;
            index_OfLowToHigh[j] = min_i;
            
            j += 1;
        }
        
        return index_OfLowToHigh;
    }
    
    //Function that gets a number of minutes (Int) and returning a hour in 4 digits (String)
    func MinutesToClock(m: Int, r: String) -> String{
        let hours = m / 60;
        let minutes = m % 60;
        
        var time = "";
        
        time += String(hours) + ":";
        
        if(r == "H"){
            return time;
        }
        
        time = "";
        
        if(minutes <= 9){
            time += "0";
        }
        time += String(minutes);
        
        return time;
    }
    
    //Function that returns the hour you see a doctor
    func SpecificTime(time: Int, r: String) -> String{
        let current_Time = currentTime();
        let current_Time_Hours: Int? = Int(current_Time.split(separator: ":")[0]);
        let current_Time_Minutes: Int? = Int(current_Time.split(separator: ":")[1]);
        
        var ex_Hours: Int? = Int(current_Time_Hours!);
        var ex_Minutes: Int? = Int(current_Time_Minutes! + time);
        
        while(ex_Minutes! >= 60){
            ex_Minutes! -= 60;
            ex_Hours! += 1;
        }
        
        if(ex_Hours! >= 24){
            ex_Hours! -= 24;
        }
        
        var ex = "";
        if(ex_Hours! <= 9){
            ex += "0";
        }
        
        ex += String(ex_Hours!);
        
        ex += ":";
        
        if(r == "H"){
            return ex;
        }
        
        ex = "";
        if(ex_Minutes! <= 9){
            ex += "0";
        }
        
        ex += String(ex_Minutes!);
        
        return ex;
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }
    
    //Function that updates the screen objects
    func ShowToUser(time: [Int]){
        currentH = sortedIndexHospital[1];
        
        lbl_Time_Hours.text = SpecificTime(time: time[currentH], r: "H");
        lbl_Time_Minutes.text = SpecificTime(time: time[currentH], r: "M");
        
        let minutes = time[currentH];
        if(minutes >= 60){
            lbl_Minutes.text = MinutesToClock(m: minutes, r: "H") + MinutesToClock(m: minutes, r: "M") + " ש׳";
        }
        else{
            lbl_Minutes.text = (String)(time[currentH]) + " דק׳";
        }
        
        btn_Go.isEnabled = true;
        
        hospital_Logo.image = changeImage(i: currentH)
    }
    
    //Function that changes the image
    func changeImage(i: Int) -> UIImage!{
        switch hospitals[i].name {
        case "Belinson":
            return UIImage(named: "Belinson_Logo");
        case "Meir":
            return UIImage(named: "Meir_Logo");
        case "Hilel Yafe":
            return UIImage(named: "Hilel_Logo");
        case "Tel Hashomer":
            return UIImage(named: "Hashomer_Logo");
        case "Wolfson":
            return UIImage(named: "Wolfson_Logo");
        default:
            return UIImage(named: "Defualt_Logo");
        }
    }
    
    func GetOrigin() -> String{
        return String(current_Latitude) + "," + String(current_Longitude);
    }
    
    func GetDestination(i: Int!) -> String {
        return hospitals[i].location.destination;
    }
    
    //Function that sets the duration from origin to destination by Google Maps Destination Matrix API
    func getDurationFromGoogleMaps(){
        var distanceURL = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=" + GetOrigin() + "&destinations="
        for i in 0...hospitals.count - 1{
            distanceURL += GetDestination(i: i)
            if(i != hospitals.count - 1){
                distanceURL += "%7C"
            }
            else{
                distanceURL += "&mode=driving&departure_time=now&traffic_model=pessimistic&key=AIzaSyCZlgPdbJlEnZ688h94TSCnTHf_hBOjkP4"
            }
        }
        
        AF.request(distanceURL).responseJSON{ response in
            if(response.result.isSuccess){
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // convert "destination_addresses" to "destinationAddresses"
                do {
                    var time = [Int]()
                    for i in 0...self.hospitals.count - 1{
                        time.append((try (decoder.decode(JSON_Distance.self, from: response.data!).rows[0].elements?[i].duration.value)!) / 60);
                        print(time[i])
                    }
                    self.SetTime(timeByWaze: time)
                }catch let error {
                    print(error)
                }
            }
        }
    }
    
    //Function that sets the Calculated Time in Minutes
    func SetTime(timeByWaze: [Int]){
        var time = [Int]()
        for i in 0...timeByWaze.count-1{
            time.append(timeByWaze[i] + hospitals[i].park + getXFactor(i: i, timeByWaze: timeByWaze[i]))
        }
        
        sortedIndexHospital = OrginizeFtoS(timeTo: time)
        
        ShowToUser(time: time);
    }
    
    //Function that returns the time that will take l people enter d doctors according to average by index
    func getXFactor(i: Int, timeByWaze: Int) -> Int{
        //New people coming
        let y = timeByWaze / hospitals[i].avg_com;
        
        let x = (hospitals[i].GetPeople() + y) / hospitals[i].doctors;
        
        return (x * hospitals[i].avg_app);
    }
    
    //Function that opens waze to navigate
    func navigateToDestination(latitude: Double, longitude: Double) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            // Waze is installed. Launch Waze and start navigation
            let urlStr = String(format: "waze://?ll=%f,%f&navigate=yes", latitude, longitude)
            UIApplication.shared.open(URL(string: urlStr)!)
        } else {
            // Waze is not installed. Launch AppStore to install Waze app
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/il/app/waze-navigation-live-traffic/id323229106?mt=8")!)
        }
    }
 
    @IBAction func btn_Go(_ sender: Any) {
        navigateToDestination(latitude: hospitals[currentH].GetLatitude(), longitude: hospitals[currentH].GetLongitude())
    }
    
    @IBAction func btn_Call(_ sender: Any) {
    }
    
    struct JSON_Distance: Codable{
        var destination_addresses: [String]!
        var origin_addresses: [String]!
        var rows: [Element]!
        var status: String!
    }//struct
    
    struct Element: Codable {
        var elements: [internalJSON]!
    }//struct
    
    struct internalJSON: Codable {
        var distance: DistanceOrTime!
        var duration: DistanceOrTime!
        var status: String!
        
        
    }//struct
    
    struct DistanceOrTime: Codable {
        var text: String!
        var value: Int!
        
    }//struct
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sec: Treshos_ViewController = segue.destination as! Treshos_ViewController
        sec.hospitals = hospitals;
        sec.current_Latitude = current_Latitude;
        sec.current_Longitude = current_Longitude;
    }
    
    @objc func swipeActionR(swipe: UISwipeGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer){
        switch swipe.direction.rawValue {
        case 2:
            performSegue(withIdentifier: "goRight", sender: self)
        default:
            break;
        }
    }
}

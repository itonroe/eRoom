//
//  MedicalView.swift
//  eRoom
//
//  Created by Roe Iton on 1/7/19.
//  Copyright © 2019 Roe Iton. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

import Alamofire
import SwiftyJSON

class MedicalView: UIViewController, CLLocationManagerDelegate{
    
    let locationMgr = CLLocationManager()
    
    //Current Location
    var current_Latitude: Double!
    var current_Longitude: Double!
    
    //Hospitals
    var insurance: String!
    var refHospitals: DatabaseReference!
    var hospitals: [Hospital]!
    var currentH: Int!
    
    //Times
    var sortedIndexHospital: [Int] = [];
    
    //Outlets
    @IBOutlet weak var lbl_Time_Hours: UILabel!
    @IBOutlet weak var lbl_Time_Minutes: UILabel!
    @IBOutlet weak var hospital_Logo: UIImageView!
    @IBOutlet weak var btn_Go: UIButton!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Minutes: UILabel!
    @IBOutlet weak var btn_Back: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        //Show Indicatior
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.gray;
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        BuildHospitals();
        SetLocation();
    }
    
    //Function that builds the Hospitals
    func BuildHospitals(){
        hospitals = [Hospital]();
        
        //Maccabi
            //Netanya
            let maccabi_netanya = Hospital(name: "נתניה", insurance: "Maccabi", d_latitude: 32.3251851, d_longitude: 34.8574279)
            hospitals.append(maccabi_netanya)
        
            //Petah Tikva
            let maccabi_petah_tikva = Hospital(name: "פתח תקווה", insurance: "Maccabi", d_latitude: 32.0877715, d_longitude: 34.8872557)
            hospitals.append(maccabi_petah_tikva)
        
            //Ramat Hasharon
            let maccabi_ramat_hasharon = Hospital(name: "רמת השרון", insurance: "Maccabi", d_latitude: 32.1385374, d_longitude: 34.8439333)
            hospitals.append(maccabi_ramat_hasharon)
        
            //Tel Aviv
            let maccabi_telaviv = Hospital(name: "תל אביב", insurance: "Maccabi", d_latitude: 32.069392, d_longitude: 34.7943003)
                hospitals.append(maccabi_telaviv)
        
            //Rishon Letsiyon
            let maccabi_rishon = Hospital(name: "ראשון לציון", insurance: "Maccabi", d_latitude: 31.96443220, d_longitude: 34.80530090)
            hospitals.append(maccabi_rishon)
        
        //Meuhedet
            //Hadera
            let meuhedet_hadera = Hospital(name: "חדרה", insurance: "Meuhedet", d_latitude: 32.4381585, d_longitude: 34.9272989)
            hospitals.append(meuhedet_hadera)
        
            //Haifa
            let meuhedet_haifa = Hospital(name: "חיפה", insurance: "Meuhedet", d_latitude: 32.8214024, d_longitude: 34.9915652)
            hospitals.append(meuhedet_haifa)
        
            //Beitar Elit
            let meuhedet_beitarelit = Hospital(name: "ביתר עלית", insurance: "Meuhedet", d_latitude: 31.6949492, d_longitude: 35.1177658)
            hospitals.append(meuhedet_beitarelit)
        
            //Beer Sheva
            let meuhedet_beersheva = Hospital(name: "באר שבע", insurance: "Meuhedet", d_latitude: 31.2440581, d_longitude: 34.7991434)
            hospitals.append(meuhedet_beersheva)
        
            //Ashkelon
            let meuhedet_ashkleon = Hospital(name: "אשקלון", insurance: "Meuhedet", d_latitude: 31.6634889, d_longitude: 34.5859913)
            hospitals.append(meuhedet_ashkleon)
        
        //Leumit
            //Tel Aviv
            let leumit_telaviv = Hospital(name: "תל אביב", insurance: "Leumit", d_latitude: 32.0671507, d_longitude: 34.7931032)
            hospitals.append(leumit_telaviv)
        
            //Hadera
            let leumit_hadera = Hospital(name: "חדרה", insurance: "Leumit", d_latitude: 32.4381585, d_longitude: 34.9272989)
            hospitals.append(leumit_hadera)
        
            //Holon
            let leumit_holon = Hospital(name: "חולון", insurance: "Leumit", d_latitude: 32.0183059, d_longitude: 34.7709615)
            hospitals.append(leumit_holon)
        
            //Kfar Saba
            let leumit_kfarsaba = Hospital(name: "כפר סבא", insurance: "Leumit", d_latitude: 32.1743979, d_longitude: 34.912957)
            hospitals.append(leumit_kfarsaba)
        
            //Rehovot
            let leumit_rehovot = Hospital(name: "רחובות", insurance: "Leumit", d_latitude: 31.896534, d_longitude: 34.8100362)
            hospitals.append(leumit_rehovot)
        
        //Clalit
            //Hertseliya
            let clalit_hertseliya = Hospital(name: "הרצליה", insurance: "Clalit", d_latitude: 32.1636867, d_longitude: 34.8428502)
            hospitals.append(clalit_hertseliya)
        
            //Netanya
            let clalit_netanya = Hospital(name: "נתניה", insurance: "Clalit", d_latitude: 32.328841, d_longitude: 34.8623899)
            hospitals.append(clalit_netanya)
        
            //Hadera
            let clalit_hadera = Hospital(name: "חדרה", insurance: "Clalit", d_latitude: 32.4416848, d_longitude: 34.913177)
            hospitals.append(clalit_hadera)
        
            //Tel Aviv
            let clalit_telaviv = Hospital(name: "תל אביב", insurance: "Clalit", d_latitude: 32.0671507, d_longitude: 34.7931032)
            hospitals.append(clalit_telaviv)
        
            //Rehovot
            let clalit_rehovot = Hospital(name: "רחובות", insurance: "Clalit", d_latitude: 31.896534, d_longitude: 34.8100362)
            hospitals.append(clalit_rehovot)
    }
    
    //Function that gets the online data from firebase Database
    func GetOnlineData() {
        var j = 0;
        
        refHospitals = Database.database().reference().child("mokdim");
        refHospitals.observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                for h in snapshot.childSnapshot(forPath: "Maccabi").children.allObjects as![DataSnapshot]{
                    let hospitalObject = h.value as! [String: Any]
                    
                    let hospitalFirstLine = hospitalObject["moked_FirstInLine"] as! String;
                    let hospitalLastLine = hospitalObject["moked_LastInLine"] as! String;
                    let hospitalDoctors = hospitalObject["moked_Doctors"] as! String;
                    let hospitalAvgApp = hospitalObject["moked_Avg_app"] as! String;
                    let hospitalAvgCom = hospitalObject["moked_Avg_com"] as! String;
                    let hospitalPark = hospitalObject["moked_Park"] as! String;
                    
                    self.hospitals[j].SetOnlineDate(firstline: (Int)(hospitalFirstLine), lastline: (Int)(hospitalLastLine),
                                                    doctors: (Int)(hospitalDoctors), avg_app: (Int)(hospitalAvgApp),
                                                    avg_com: (Int)(hospitalAvgCom), park: (Int)(hospitalPark));
                    
                    j += 1;
                }
                
                for h in snapshot.childSnapshot(forPath: "Meuhedet").children.allObjects as![DataSnapshot]{
                    let hospitalObject = h.value as! [String: Any]
                    
                    let hospitalFirstLine = hospitalObject["moked_FirstInLine"] as! String;
                    let hospitalLastLine = hospitalObject["moked_LastInLine"] as! String;
                    let hospitalDoctors = hospitalObject["moked_Doctors"] as! String;
                    let hospitalAvgApp = hospitalObject["moked_Avg_app"] as! String;
                    let hospitalAvgCom = hospitalObject["moked_Avg_com"] as! String;
                    let hospitalPark = hospitalObject["moked_Park"] as! String;
                    
                    self.hospitals[j].SetOnlineDate(firstline: (Int)(hospitalFirstLine), lastline: (Int)(hospitalLastLine),
                                                    doctors: (Int)(hospitalDoctors), avg_app: (Int)(hospitalAvgApp),
                                                    avg_com: (Int)(hospitalAvgCom), park: (Int)(hospitalPark));
                    
                    j += 1;
                }
                
                for h in snapshot.childSnapshot(forPath: "Leumit").children.allObjects as![DataSnapshot]{
                    let hospitalObject = h.value as! [String: Any]
                    
                    let hospitalFirstLine = hospitalObject["moked_FirstInLine"] as! String;
                    let hospitalLastLine = hospitalObject["moked_LastInLine"] as! String;
                    let hospitalDoctors = hospitalObject["moked_Doctors"] as! String;
                    let hospitalAvgApp = hospitalObject["moked_Avg_app"] as! String;
                    let hospitalAvgCom = hospitalObject["moked_Avg_com"] as! String;
                    let hospitalPark = hospitalObject["moked_Park"] as! String;
                    
                    self.hospitals[j].SetOnlineDate(firstline: (Int)(hospitalFirstLine), lastline: (Int)(hospitalLastLine),
                                                    doctors: (Int)(hospitalDoctors), avg_app: (Int)(hospitalAvgApp),
                                                    avg_com: (Int)(hospitalAvgCom), park: (Int)(hospitalPark));
                    
                    j += 1;
                }
                
                for h in snapshot.childSnapshot(forPath: "Clalit").children.allObjects as![DataSnapshot]{
                    let hospitalObject = h.value as! [String: Any]
                    
                    let hospitalFirstLine = hospitalObject["moked_FirstInLine"] as! String;
                    let hospitalLastLine = hospitalObject["moked_LastInLine"] as! String;
                    let hospitalDoctors = hospitalObject["moked_Doctors"] as! String;
                    let hospitalAvgApp = hospitalObject["moked_Avg_app"] as! String;
                    let hospitalAvgCom = hospitalObject["moked_Avg_com"] as! String;
                    let hospitalPark = hospitalObject["moked_Park"] as! String;
                    
                    self.hospitals[j].SetOnlineDate(firstline: (Int)(hospitalFirstLine), lastline: (Int)(hospitalLastLine),
                                                    doctors: (Int)(hospitalDoctors), avg_app: (Int)(hospitalAvgApp),
                                                    avg_com: (Int)(hospitalAvgCom), park: (Int)(hospitalPark));
                    
                    j += 1;
                }
                
                self.getDurationFromGoogleMaps();
            }
        })
    }
    
    //Functions that sets the current GPS location of a user - using Location Core
    func SetLocation(){
        let status  = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return;
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return;
        }
        
        locationMgr.delegate = self
        locationMgr.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        current_Latitude = currentLocation.coordinate.latitude;
        current_Longitude = currentLocation.coordinate.longitude;
        
        GetOnlineData();
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
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
        for i in 0...sortedIndexHospital.count-1{
            let toprint = (String)(i + 1) + ". " + hospitals[sortedIndexHospital[i]].name + ", " + hospitals[sortedIndexHospital[i]].GetInsurance() + " - " + (String)(time[sortedIndexHospital[i]]) + " Minutes";
            print(toprint);
        }
        
        if(insurance != "None"){
            for i in 0...sortedIndexHospital.count-1{
                if(hospitals[sortedIndexHospital[i]].GetInsurance() == insurance){
                    currentH = sortedIndexHospital[i];
                    break;
                }
            }
        }
        else{
            currentH = sortedIndexHospital[0];
        }
        
        lbl_Time_Hours.text = SpecificTime(time: time[currentH], r: "H");
        lbl_Time_Minutes.text = SpecificTime(time: time[currentH], r: "M");
        
        let minutes = time[currentH];
        if(minutes >= 60){
            lbl_Minutes.text = MinutesToClock(m: minutes, r: "H") + MinutesToClock(m: minutes, r: "M") + " ש׳";
        }
        else{
            lbl_Minutes.text = (String)(time[currentH]) + " דק׳";
        }
        
        lbl_Name.text = hospitals[currentH].name;
        hospital_Logo.image = changeImage(i: currentH)
        
        btn_Go.isEnabled = true;
        
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    //Function that returns new Sorted Time
    /*func betterSorted(old_sorted: [Int]) -> [Int]{
        var new_sorted: [Int] = [];
        
        var maccabi_sorted: [Int] = [];
        var meuhedet_sorted: [Int] = [];
        var leumit_sorted: [Int] = [];
        var clalit_sorted: [Int] = [];
        
        for i in 0...(old_sorted.count - 1){
            switch(hospitals[old_sorted[i]].GetInsurance()){
                case "Maccabi": maccabi_sorted.append(old_sorted[i]);
                case "Meuhedet": meuhedet_sorted.append(old_sorted[i]);
                case "Clalit": clalit_sorted.append(old_sorted[i]);
                case "Leumit": leumit_sorted.append(old_sorted[i]);
            default:
                break;
            }
        }
        
        var length_Mokdim = maccabi_sorted.count;
        
        switch(insurance){
            case "Maccabi":
                for i in 0...length_Mokdim{
                    
                };
            case "Meuhedet": meuhedet_sorted.append(old_sorted[i]);
            case "Clalit": clalit_sorted.append(old_sorted[i]);
            case "Leumit": leumit_sorted.append(old_sorted[i]);
            default:
                break;
        }
        
        return new_sorted;
    }*/
    
    //Function that changes the image
    func changeImage(i: Int) -> UIImage!{
        switch hospitals[i].GetInsurance() {
        case "Maccabi":
            return UIImage(named: "Maccabi_Logo_2");
        case "Meuhedet":
            return UIImage(named: "Meuhedet_Logo_2");
        case "Clalit":
            return UIImage(named: "Clalit_Logo_2");
        case "Leumit":
            return UIImage(named: "Leumit_Logo_2");
        default:
            return UIImage(named: "Defualt_Logo");
        }
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
                        //print(time[i])
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
            time.append(timeByWaze[i] + hospitals[i].park + getXFactor(i: i, timeByWaze: timeByWaze[i]));
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
    
    @IBAction func btn_Go(_ sender: Any) {
        navigateToDestination(latitude: hospitals[currentH].GetLatitude(), longitude: hospitals[currentH].GetLongitude())
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sec: Sechos_ViewController = segue.destination as! Sechos_ViewController
        sec.hospitals = hospitals;
        sec.current_Latitude = current_Latitude;
        sec.current_Longitude = current_Longitude;
    }*/
    
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
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer){
        switch swipe.direction.rawValue {
        case 2:
            break;
            //performSegue(withIdentifier: "goRight", sender: self)
        default:
            break;
        }
    }
}

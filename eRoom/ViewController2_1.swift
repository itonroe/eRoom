//
//  ViewController2_1.swift
//  eRoom
//
//  Created by Roe Iton on 1/19/19.
//  Copyright © 2019 Roe Iton. All rights reserved.
//

import UIKit

class ViewController2_1: UIViewController {
    
    var insurance_Comp: String!
    var insurance_Urgent = "None";
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btn_Type1(_ sender: Any) {
        insurance_Urgent = "Ambulance";
        dialNumber(number: "101")
    }
    
    @IBAction func btn_Type2(_ sender: Any) {
        insurance_Urgent = "Maternity";
        //performSegue(withIdentifier: "final_show", sender: self)
    }
    
    @IBAction func btn_Type3(_ sender: Any) {
        insurance_Urgent = "Moked";
        performSegue(withIdentifier: "final_show", sender: self)
    }
    
    @IBAction func btn_Type4(_ sender: Any) {
        insurance_Urgent = "ER";
        performSegue(withIdentifier: "gotoMain", sender: self)
    }
    
    @IBAction func btn_Skip(_ sender: Any) {
        insurance_Urgent = "None";
        if(insurance_Comp == "None"){
            performSegue(withIdentifier: "gotoMain", sender: self)
        }
        else{
            performSegue(withIdentifier: "final_show", sender: self)
            //כאן צריך להיות ההחלטה של אם בית חולים או מיון, כעת נשלח למוקד.
            //performSegue(withIdentifier: "final_show", sender: self)
        }
    }
    
    @IBAction func btn_Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(insurance_Urgent == "Moked"){
            let final: MedicalView = segue.destination as! MedicalView
            final.insurance = insurance_Comp;
        }
        if(insurance_Comp != "None" && insurance_Urgent == "None"){
            let final: MedicalView = segue.destination as! MedicalView
            final.insurance = insurance_Comp;
        }
    }
    
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
}

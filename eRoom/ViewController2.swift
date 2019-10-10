//
//  ViewController2.swift
//  eRoom
//
//  Created by Roe Iton on 1/19/19.
//  Copyright © 2019 Roe Iton. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    var clicked = "None";
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btn_Maccabi(_ sender: Any) {
        clicked = "Maccabi";
        performSegue(withIdentifier: "go_Step2", sender: self)
    }
    
    @IBAction func btn_Meuhedet(_ sender: Any) {
        clicked = "Meuhedet";
        performSegue(withIdentifier: "go_Step2", sender: self)
    }
    
    @IBAction func btn_Klalit(_ sender: Any) {
        clicked = "Clalit";
        performSegue(withIdentifier: "go_Step2", sender: self)
    }
    
    @IBAction func btn_Leumit(_ sender: Any) {
        clicked = "Leumit";
        performSegue(withIdentifier: "go_Step2", sender: self)
    }
    
    @IBAction func btn_Skip(_ sender: Any) {
        clicked = "None";
        performSegue(withIdentifier: "go_Step2", sender: self)

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let step_2: ViewController2_1 = segue.destination as! ViewController2_1
        step_2.insurance_Comp = clicked;
    }
}

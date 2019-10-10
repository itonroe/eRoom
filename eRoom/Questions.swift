//
//  Questions.swift
//  eRoom
//
//  Created by Roe Iton on 1/19/19.
//  Copyright © 2019 Roe Iton. All rights reserved.
//

import UIKit

class Questions: UIViewController {
    
    var questions = [[String]]()
    
    var problem: String!
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readProblem()
    }
    
    func readProblem(){
        let file = Bundle.main.url(forResource: "Headache", withExtension: "rtf")
        do{
            let text = try String(contentsOf: file!, encoding: .utf8);
            readEnglishHebrew(text: text)
        }
        catch {
            print(file!)
        }
    }
    
    func readEnglishHebrew(text: String){
        var hebText = ""
        for character in text {
            switch(character){
            case "a":
                hebText += "א";
                break;
            case "b":
                hebText += "ב";
            default:
                hebText += String(character)
                break;
            }
        }
        
        lbl_Title.text = hebText
    }
}

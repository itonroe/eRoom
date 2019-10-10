//
//  Paths.swift
//  eRoom
//
//  Created by Roe Iton on 3/16/19.
//  Copyright © 2019 Roe Iton. All rights reserved.
//

import UIKit

class Paths: UIViewController {

    var problem: String!
    
    @IBOutlet weak var btn_Func1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func headache_onClick(_ sender: Any) {
        problem = "Headache";
        performSegue(withIdentifier: "go_to_questions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let questions: Questions = segue.destination as! Questions
        questions.problem = problem;
    }
}

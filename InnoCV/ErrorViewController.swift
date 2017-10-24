//
//  ErrorViewController.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 24/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

    @IBOutlet weak var errorTitleLbl: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var errorMessageLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    var message: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        self.okBtn.layer.cornerRadius = 5
        self.viewBg.layer.cornerRadius = 5

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let message = message {
            self.errorMessageLbl.text = message
        }
    }
    

    @IBAction func DismissBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

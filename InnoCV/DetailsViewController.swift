//
//  DetailsViewController.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 23/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userIdLbl: UILabel!
    @IBOutlet weak var userBirthDateLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var userBirthdateTextField: UITextField!
    
    var mode: String = "create"
    var user: CoreDataUser = CoreDataUser()
    var selectedDate:Date?
    let dp = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveBtn.layer.cornerRadius = 5
        self.deleteBtn.layer.cornerRadius = 5
        
        userBirthdateTextField.inputView = dp
        dp.datePickerMode = .date
        selectedDate = dp.date
        
        dp.addTarget(self, action: #selector(dateUpdated), for: .valueChanged)
        
        
        if (mode == "update") {
            
            self.saveBtn.setTitle("Update User", for: .normal)
            self.saveBtn.setTitle("Update User", for: .highlighted)
            
            self.userNameTextField.text = user.name
            self.userBirthdateTextField.text = user.birthdate
            self.userIdTextField.text = "\(user.id!)"

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dateUpdated() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        self.userBirthdateTextField.text = formatter.string(from: dp.date)
        
    }
    
    
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {

        if (mode == "update") {

            ECProgressView.shared.showProgressView(view)
            
            UserService.shared.deleteUser(id: user.id!) { response in

                ECProgressView.shared.hideProgressView()
                if let response = response {
                    
                    print("call to the delete API: \(response["status"] ?? "")")
                    self.notifyUser("user deleted successfully!")
                }
                else {
                    // some issue 
                    self.showErrorViewController(message: "the server is down. Please try again later")
                }
            }
        }
        else {
            self.showErrorViewController(message: "You cannot delete an empty user. Try to save it before")
        }
    }
    
    
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        
        if let nameText = userNameTextField.text, let birthdateText = userBirthdateTextField.text {
            if (!nameText.isEmpty && !birthdateText.isEmpty) {
                
                ECProgressView.shared.showProgressView(view)
                
                if (mode == "create") {
                    user.name = nameText
                    user.birthdate = birthdateText
                    print("sending to the API: \(user.name!) \(user.birthdate!)")
                    
                    UserService.shared.createUser(user: user) { response in
                        
                        ECProgressView.shared.hideProgressView()
                        if let response = response {
                            
                            print("call to the API: \(response["status"] ?? "")")
                            self.notifyUser("user saved successfully!")
                        }
                    }
                }
                else {
                    // update
                    user.name = nameText
                    user.birthdate = birthdateText
                    print("sending to the API: \(user.name!) \(user.birthdate!)")
                    
                    UserService.shared.updateUser(user: user) { response in
                        
                        ECProgressView.shared.hideProgressView()
                        if let response = response {

                            print("call to the update API: \(response["status"] ?? "")")
                            self.notifyUser("user updated successfully!")
                        }
                    }
                }
            }
            else {
                // please fill the fields
                showErrorViewController(message: "you have to fill name and birthdate fields")
            }
        }
        
        
    }
    
    
    
    
    // Show alert messages
    func notifyUser(_ message: String) -> Void
    {
        let alert = UIAlertController(title: "Inno CV",
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: {(action) in
                                            // We're leaving this View
                                            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func showErrorViewController(message: String?) {
        let errorVC = viewControllerWithStoryboardIdentifier(name: "errorVC") as! ErrorViewController
        errorVC.modalPresentationStyle = .overCurrentContext
        errorVC.modalTransitionStyle = .crossDissolve
        if let message = message {
            errorVC.message = message
        }
        self.present(errorVC, animated: true)
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

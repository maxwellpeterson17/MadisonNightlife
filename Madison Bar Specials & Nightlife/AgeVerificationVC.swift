//
//  AgeVerificationVC.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 17/12/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
class AgeVerificationVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var BackScroll: UIScrollView!
    @IBOutlet var SubmitBTN: UIButton!
    @IBOutlet var TXTAge: UITextField!
    @IBOutlet var AgeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(view.LoaderView())
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = AppThemeColor.cgColor
        border.frame = CGRect(x: 0, y: TXTAge.frame.size.height - width, width:  TXTAge.frame.size.width, height: TXTAge.frame.size.height)
        
        border.borderWidth = width
        TXTAge.layer.addSublayer(border)
        TXTAge.layer.masksToBounds = true
        
        DispatchQueue.main.async {
            self.SubmitBTN.clipsToBounds=true
            self.SubmitBTN.layer.cornerRadius = self.SubmitBTN.Height/2
            self.AgeView.clipsToBounds=true
            self.AgeView.layer.cornerRadius = 5.0
            
            self.BackScroll.contentSize.height = self.AgeView.Y + self.TXTAge.YH
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitBTNClick(_ sender: UIButton) {
        self.view.endEditing(true)
        if TXTAge.text!.isEmpty == true
        {
            ShowAlert(subTitle: "Please enter your age.", viewController: self)
        }
        else
        {
            if Float(TXTAge.text!)! > 0
            {
                var is_Student = ""
                if Float(TXTAge.text!)! > 22
                {
                    is_Student = "0"
                }
                else
                {
                    is_Student = "1"
                }
                startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
                let params = [
                    "device_token":Token,
                    "device_udid":OpenUDID.value()!,
                    "is_student":is_Student
                ]
                print(params)
                Alamofire.request("\(API_URL)addUserDetail", method: .post, parameters: params).responseJSON { (response) in
                    if response.result.error != nil
                    {
                        //ShowAlert(subTitle: "Please check your internet connection.", viewController: self)
                    }
                    else
                    {
                        let responseDict = response.result.value as! NSDictionary
                        let ResponseCode = "\(responseDict.value(forKey: "code")!)"
                        //print(responseDict)
                        if ResponseCode == "200"
                        {
                            Default.setValue("1", forKey: "CheckStudent")
                            let Stry = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                            self.present(Stry, animated: true, completion: nil)
                        }
                        else
                        {
                            ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                        }
                    }
                    self.stopAnimating()
                }
            }
            else
            {
                ShowAlert(subTitle: "Please enter your valid your age.", viewController: self)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden=true
    }

}

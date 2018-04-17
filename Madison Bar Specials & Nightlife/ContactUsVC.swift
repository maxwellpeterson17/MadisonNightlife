//
//  ContactUsVC.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 29/11/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
class ContactUsVC: UIViewController, UITextViewDelegate, NVActivityIndicatorViewable {

    @IBOutlet var LBL: UILabel!
    @IBOutlet var BackScroll: UIScrollView!
    @IBOutlet var SubmitBTN: UIButton!
    @IBOutlet var MessageText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(view.LoaderView())
        
        SubmitBTN.clipsToBounds=true
        SubmitBTN.layer.cornerRadius=5.0
        MessageText.layer.borderWidth=1.0
        MessageText.layer.borderColor = AppThemeColor.cgColor
        MessageText.clipsToBounds=true
        MessageText.layer.cornerRadius=5.0
        
        DispatchQueue.main.async {
            self.LBL.numberOfLines = 0
            self.LBL.sizeToFit()
            self.MessageText.frame.origin.y = self.LBL.YH + 20
            self.SubmitBTN.frame.origin.y = self.MessageText.YH + 20
            self.BackScroll.contentSize.height = self.SubmitBTN.YH + 20
        }
        startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
        Alamofire.request("\(API_URL)getContactUsDetail", method: .get).responseJSON(completionHandler: { (response) in
            if response.result.error != nil
            {
                ShowAlert(subTitle: "Please check your internet connection.", viewController: self)
            }
            else
            {
                let responseDict = response.result.value as! NSDictionary
                let ResponseCode = "\(responseDict.value(forKey: "code")!)"
                print(responseDict)
                if ResponseCode == "200"
                {
                    let Dict = responseDict.value(forKey: "response") as! NSDictionary
                    let decodedData = Data(base64Encoded: Dict.value(forKey: "contact_us") as! String)
                    do{
                        let AttStr = try NSAttributedString(data: decodedData!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                        self.LBL.attributedText = AttStr
                        self.LBL.numberOfLines = 0
                        self.LBL.sizeToFit()
                        self.LBL.textColor = UIColor.white
                        self.MessageText.frame.origin.y = self.LBL.YH + 20
                        self.SubmitBTN.frame.origin.y = self.MessageText.YH + 20
                        self.BackScroll.contentSize.height = self.SubmitBTN.YH + 20
                    }catch{
                    }
                }
                else
                {
                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                }
            }
            
            DispatchQueue.main.async {
                self.stopAnimating()
            }
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitBTNClick(_ sender: UIButton) {
        self.view.endEditing(true)
        if MessageText.text == "Type Here...."
        {
            ShowAlert(subTitle: "Please enter your message.", viewController: self)
        }
        else
        {
            startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
            let params = [
                "contact_us_text":MessageText.text!
            ]
            Alamofire.request("\(API_URL)contactUs", method: .post, parameters: params).responseJSON(completionHandler: { (response) in
                if response.result.error != nil
                {
                    ShowAlert(subTitle: "Please check your internet connection.", viewController: self)
                }
                else
                {
                    let responseDict = response.result.value as! NSDictionary
//                    let ResponseCode = "\(responseDict.value(forKey: "code")!)"
//                    print(responseDict)
                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                }
                self.stopAnimating()
            })
        }
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Here...." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true
        {
            textView.text = "Type Here...."
        }
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

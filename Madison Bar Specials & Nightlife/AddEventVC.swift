//
//  AddEventVC.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 29/11/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import GooglePlacePicker
import TOCropViewController
class AddEventVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NVActivityIndicatorViewable, UITextFieldDelegate, GMSPlacePickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TOCropViewControllerDelegate {
    
    @IBOutlet var BioTextView: UITextView!
    @IBOutlet var BioLBL: UILabel!
    @IBOutlet var LinkView: UIView!
    @IBOutlet var OptionView: UIView!
    @IBOutlet var TicketNeededLBL: UILabel!
    @IBOutlet var MiscellaneousCheck: CheckBox!
    @IBOutlet var ComedyCheck: CheckBox!
    @IBOutlet var TheaterCheck: CheckBox!
    @IBOutlet var SportsCheck: CheckBox!
    @IBOutlet var ConcertCheck: CheckBox!
    @IBOutlet var HouseCheck: CheckBox!
    @IBOutlet var GreekCheck: CheckBox!
    @IBOutlet var BarEventCheck: CheckBox!
    @IBOutlet var TXTBarName: UITextField!
    @IBOutlet var TXTTicketLink: UITextField!
    @IBOutlet var TicketsLBL: UILabel!
    @IBOutlet var CheckBox: CheckBox!
    @IBOutlet var LocationLBL: UILabel!
    @IBOutlet var EventLocationView: UIView!
    @IBOutlet var SubmitBTN: UIButton!
    @IBOutlet var TXTEventTime: UITextField!
    @IBOutlet var TXTEventDate: UITextField!
    @IBOutlet var TXTEventName: UITextField!
    @IBOutlet var EventImageView: UIImageView!
    @IBOutlet var BackScroll: UIScrollView!
    var imagePicker = UIImagePickerController()
    var CheckImage = 0
    var SelectedDate = Date()
    var SelectedTime = Date()
    var CheckTickets = 0
    var Latitude = "", Longitude = ""
    var BarNameAry = NSMutableArray()
    var ID = ""
    var EventAry = [String]()
    var colorAry = [UIColor]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add New Event"
        view.addSubview(view.LoaderView())
        imagePicker.delegate=self
//        TXTPhone.SetBorder()
//        TXTEventVenue.SetBorder()
        EventLocationView.layer.borderWidth=1.0
        EventLocationView.layer.borderColor = AppThemeColor.cgColor
        EventLocationView.clipsToBounds=true
        EventLocationView.layer.cornerRadius = 5.0
        BioTextView.layer.borderWidth=1.0
        BioTextView.layer.borderColor = AppThemeColor.cgColor
        BioTextView.clipsToBounds=true
        BioTextView.layer.cornerRadius = 5.0
        TXTEventTime.SetBorder()
        TXTEventDate.SetBorder()
        TXTEventName.SetBorder()
        TXTTicketLink.SetBorder()
        TXTBarName.SetBorder()
        
        DispatchQueue.main.async {
            
            self.EventImageView.frame.size.width = self.EventImageView.Height
            self.EventImageView.frame.origin.x = (self.BackScroll.Width/2) - (self.EventImageView.Width/2)
            self.EventImageView.clipsToBounds=true
            self.EventImageView.layer.cornerRadius = self.EventImageView.Width/2
            self.EventImageView.layer.borderWidth=1.0
            self.EventImageView.layer.borderColor=AppThemeColor.cgColor
            self.SubmitBTN.clipsToBounds=true
            self.SubmitBTN.layer.cornerRadius = 5.0
            self.BackScroll.contentSize.height = self.SubmitBTN.YH + 20
        }
        
        let TimePicker = UIDatePicker()
        TimePicker.datePickerMode = .time
//        TimePicker.minimumDate = Date()
        TimePicker.addTarget(self, action: #selector(TimePick(_:)), for: .valueChanged)
//        TimePicker.locale = Locale(identifier: "en_GB")
        TXTEventTime.inputView = TimePicker
        
        let DatePicker = UIDatePicker()
        DatePicker.datePickerMode = .date
        DatePicker.minimumDate = Date()
        DatePicker.addTarget(self, action: #selector(DatePick(_:)), for: .valueChanged)
//        DatePicker.locale = Locale(identifier: "en_GB")
        TXTEventDate.inputView = DatePicker
//        SetFrame()
        //CheckBox.title
        CheckBox.onClick = { (checkbox) in
            //print(checkbox.isChecked)
            if checkbox.isChecked
            {
                self.CheckTickets = 1
            }
            else
            {
                self.CheckTickets = 0
            }
            self.SetFrame()
        }
        
        BarEventCheck.onClick = { (checkbox) in
            if checkbox.isChecked
            {
                self.EventAry.append("BarEvent")
                self.colorAry.append(UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 34.0/255.0, alpha: 1.0))
                self.setColor()
            }
            else
            {
                for i in 0..<self.EventAry.count
                {
                    if self.EventAry[i] == "BarEvent"
                    {
                        self.EventAry.remove(at: i)
                        self.colorAry.remove(at: i)
                        self.setColor()
                        break
                    }
                }
            }
        }
        GreekCheck.onClick = { (checkbox) in
            //print(checkbox.isChecked)
            if checkbox.isChecked
            {
                self.EventAry.append("Philanthropy")
                self.colorAry.append(UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 79.0/255.0, alpha: 1.0))
                self.setColor()
            }
            else
            {
                for i in 0..<self.EventAry.count
                {
                    if self.EventAry[i] == "Philanthropy"
                    {
                        self.EventAry.remove(at: i)
                        self.colorAry.remove(at: i)
                        self.setColor()
                        break
                    }
                }
            }
        }
        HouseCheck.onClick = { (checkbox) in
            //print(checkbox.isChecked)
            if checkbox.isChecked
            {
                self.EventAry.append("Party")
                self.colorAry.append(UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0))
                self.setColor()
            }
            else
            {
                for i in 0..<self.EventAry.count
                {
                    if self.EventAry[i] == "Party"
                    {
                        self.EventAry.remove(at: i)
                        self.colorAry.remove(at: i)
                        self.setColor()
                        break
                    }
                }
            }
        }
        ConcertCheck.onClick = { (checkbox) in
            //print(checkbox.isChecked)
            if checkbox.isChecked
            {
                self.EventAry.append("Concert")
                self.colorAry.append(UIColor(red: 207.0/255.0, green: 64.0/255.0, blue: 255.0/255.0, alpha: 1.0))
                self.setColor()
            }
            else
            {
                for i in 0..<self.EventAry.count
                {
                    if self.EventAry[i] == "Concert"
                    {
                        self.EventAry.remove(at: i)
                        self.colorAry.remove(at: i)
                        self.setColor()
                        break
                    }
                }
            }
        }
        SportsCheck.onClick = { (checkbox) in
            //print(checkbox.isChecked)
            if checkbox.isChecked
            {
                self.EventAry.append("Sports")
                self.colorAry.append(UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0))
                self.setColor()
            }
            else
            {
                for i in 0..<self.EventAry.count
                {
                    if self.EventAry[i] == "Sports"
                    {
                        self.EventAry.remove(at: i)
                        self.colorAry.remove(at: i)
                        self.setColor()
                        break
                    }
                }
            }
        }
        TheaterCheck.onClick = { (checkbox) in
            //print(checkbox.isChecked)
            if checkbox.isChecked
            {
                self.EventAry.append("Theater")
                self.colorAry.append(UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 85.0/255.0, alpha: 1.0))
                self.setColor()
            }
            else
            {
                for i in 0..<self.EventAry.count
                {
                    if self.EventAry[i] == "Theater"
                    {
                        self.EventAry.remove(at: i)
                        self.colorAry.remove(at: i)
                        self.setColor()
                        break
                    }
                }
            }
        }
        ComedyCheck.onClick = { (checkbox) in
            //print(checkbox.isChecked)
            if checkbox.isChecked
            {
                self.EventAry.append("Comedy")
                self.colorAry.append(UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1.0))
                self.setColor()
            }
            else
            {
                for i in 0..<self.EventAry.count
                {
                    if self.EventAry[i] == "Comedy"
                    {
                        self.EventAry.remove(at: i)
                        self.colorAry.remove(at: i)
                        self.setColor()
                        break
                    }
                }
            }
        }
        MiscellaneousCheck.onClick = { (checkbox) in
            //print(checkbox.isChecked)
            if checkbox.isChecked
            {
                self.EventAry.append("Miscellaneous")
                self.colorAry.append(UIColor.white)
                self.setColor()
            }
            else
            {
                for i in 0..<self.EventAry.count
                {
                    if self.EventAry[i] == "Miscellaneous"
                    {
                        self.EventAry.remove(at: i)
                        self.colorAry.remove(at: i)
                        self.setColor()
                        break
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setColor()
    {
        if self.colorAry.count > 1
        {
            EventImageView.layer.borderColor = UIColor.white.cgColor//colorAry.last!.cgColor
        }
        else if colorAry.count == 1
        {
            EventImageView.layer.borderColor = colorAry.last!.cgColor
        }
        else
        {
            EventImageView.layer.borderColor = AppThemeColor.cgColor
        }
    }
    
    @IBAction func LocationTap(_ sender: UITapGestureRecognizer) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BarNameAry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (BarNameAry.object(at: row) as AnyObject).value(forKey: "bar_name") as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TXTBarName.text = (BarNameAry.object(at: row) as AnyObject).value(forKey: "bar_name") as? String
        ID = "\((BarNameAry.object(at: row) as AnyObject).value(forKey: "id")!)"
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        if place.formattedAddress == nil
        {
            UIAlertView(title: "Madison NL", message: "Please select valid event address.", delegate: self, cancelButtonTitle: "OK").show()
        }
        else
        {
//            LocationLBL.frame.origin.x = 8
//            LocationLBL.frame.origin.y = 8
            
            Latitude = "\(place.coordinate.latitude)"
            Longitude = "\(place.coordinate.longitude)"
            
            LocationLBL.frame.size.width = EventLocationView.Width-16
            LocationLBL.frame.origin.y = EventLocationView.Y + 8
            LocationLBL.text = place.formattedAddress
            LocationLBL.numberOfLines = 0
            LocationLBL.sizeToFit()
//            LocationLBL.center = EventLocationView.center
            if EventLocationView.Height < (LocationLBL.Height+16)
            {
                EventLocationView.frame.size.height = LocationLBL.Height + 16
            }
            else
            {
                EventLocationView.frame.size.height = TXTEventTime.Height
                LocationLBL.frame.origin.y = EventLocationView.Y + ((EventLocationView.Height/2)-(LocationLBL.Height/2))
            }
            
//            PhoneLBL.frame.origin.y = EventLocationView.YH + 15
//            TXTPhone.frame.origin.y = PhoneLBL.YH + 8
//            TicketNeededLBL.frame.origin.y = EventLocationView.YH + 15
//            OptionView.frame.origin.y = TicketNeededLBL.YH + 8
            CheckBox.frame.origin.y = EventLocationView.YH + 15
            SetFrame()
            
        }
        
//        print("Place name \(place.name)")
//        print("Place address \(place.formattedAddress)")
//        print("Place attributions \(place.attributions)")
    }
    
    func SetFrame()
    {
//        SubmitBTN.frame.origin.y = CheckBox.YH + 25
        if CheckTickets == 1
        {
//            TicketsLBL.isHidden=false
//            TXTTicketLink.isHidden=false
            LinkView.isHidden=false
//            TicketsLBL.frame.origin.y = CheckBox.YH + 15
//            TXTTicketLink.frame.origin.y = TicketsLBL.YH + 8
            LinkView.frame.origin.y = CheckBox.YH + 15
            TicketNeededLBL.frame.origin.y = LinkView.YH + 15
            OptionView.frame.origin.y = TicketNeededLBL.YH + 8
            BioLBL.frame.origin.y = OptionView.YH + 7
            BioTextView.frame.origin.y = BioLBL.YH + 8
            SubmitBTN.frame.origin.y = BioTextView.YH + 20
        }
        else
        {
            TXTTicketLink.text = ""
            LinkView.isHidden = true
//            TicketsLBL.isHidden=true
//            TXTTicketLink.isHidden=true
            TicketNeededLBL.frame.origin.y = CheckBox.YH + 15
            OptionView.frame.origin.y = TicketNeededLBL.YH + 8
            BioLBL.frame.origin.y = OptionView.YH + 7
            BioTextView.frame.origin.y = BioLBL.YH + 8
            SubmitBTN.frame.origin.y = BioTextView.YH + 20
        }
        BackScroll.contentSize.height = SubmitBTN.YH + 25
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    
    func TimePick(_ sender: UIDatePicker)
    {
        SelectedTime = sender.date
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "hh:mm a"
        TXTEventTime.text = dateFormater.string(from: sender.date)
    }
    func DatePick(_ sender: UIDatePicker)
    {
        SelectedDate = sender.date
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "M/d/yyyy"
        TXTEventDate.text = dateFormater.string(from: sender.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TXTEventDate && textField.text!.isEmpty == true
        {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "M/d/yyyy"
            TXTEventDate.text = dateFormater.string(from: Date())
        }
        else if textField == TXTEventTime && textField.text!.isEmpty == true
        {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "hh:mm a"
            TXTEventTime.text = dateFormater.string(from: Date())
        }
//        else if textField == TXTBarName && textField.text!.isEmpty == true && BarNameAry.count > 0
//        {
//            TXTBarName.text = (BarNameAry.object(at: 0) as AnyObject).value(forKey: "bar_name") as? String
//            ID = "\((BarNameAry.object(at: 0) as AnyObject).value(forKey: "id")!)"
//        }
    }
    
    @IBAction func SubmitBTNClick(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        
        if TXTEventName.text!.isEmpty == true
        {
            ShowAlert(subTitle: "Please enter event name.", viewController: self)
        }
        else if TXTBarName.text!.isEmpty == true
        {
            ShowAlert(subTitle: "Please enter location name.", viewController: self)
        }
        else if TXTEventDate.text!.isEmpty == true
        {
            ShowAlert(subTitle: "Please select event date.", viewController: self)
        }
        else if TXTEventTime.text!.isEmpty == true
        {
            ShowAlert(subTitle: "Please select event time.", viewController: self)
        }
        else if LocationLBL.text!.isEmpty == true
        {
            ShowAlert(subTitle: "Please enter event address.", viewController: self)
        }
//        else if TXTPhone.text!.isEmpty == true
//        {
//            ShowAlert(subTitle: "Please enter your phone number.", viewController: self)
//        }
        else if TXTTicketLink.text!.isEmpty == true && CheckTickets == 1
        {
            ShowAlert(subTitle: "Please enter link to buy tickets.", viewController: self)
        }
        else
        {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "HH:mm:ss"
            
            let dateFormater1 = DateFormatter()
            dateFormater1.dateFormat = "yyyy-MM-dd"
            
            startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
            let params = [
                "event_name":TXTEventName.text!,
                "date":dateFormater1.string(from: SelectedDate),
                "time":dateFormater.string(from: SelectedTime),
                "event_location":LocationLBL.text!,
//                "phone_number":TXTPhone.text!,
                "is_ticket_need":EventAry.joined(separator: ","),
                "latitude":Latitude,
                "longitude":Longitude,
                "is_ticket": "\(CheckTickets)",
                "ticket_url":TXTTicketLink.text!,
                "bar_name":TXTBarName.text!,
                "event_bio":BioTextView.text!
                ]
            print(params)
            var event_image : UIImage!
            if EventImageView.image != nil {
                event_image = EventImageView.image!
            }
            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                if self.CheckImage == 1
//                {
                    if event_image != nil
                    {
                        let imageData = UIImageJPEGRepresentation(event_image, 0.5)
                        let TimeStamp = Date().timeIntervalSince1970 * 1000
                        print(TimeStamp)
                        multipartFormData.append(imageData!, withName: "event_image", fileName: "\(TimeStamp).png", mimeType: "image/png")
                    }
//                }
                
                for (key, value) in params
                {
//                    print(key)
//                    print(value)
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: "\(API_URL)addEventDetail", method: .post) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
//                        print(response.result.value)
//                        print(response.result.error)
                        
                        if response.result.error != nil
                        {
                           // ShowAlert(subTitle: "Please check your internet connection.", viewController: self)
                        }
                        else
                        {
                            let responseDict = response.result.value as! NSDictionary
                            let ResponseCode = "\(responseDict.value(forKey: "code")!)"
                            print(responseDict)
                            if ResponseCode == "200"
                            {
                                self.navigationController?.popViewController(animated: true)
                                DispatchQueue.main.async {
                                    ShowAlert(subTitle: "Your event has been submitted and will be reviewed shortly.", viewController: self)
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                                }
                            }
                            
                            
                        }
                        DispatchQueue.main.async {
                            self.stopAnimating()
                        }
                    }
                case .failure(let encodingError):
                    //ShowAlert(subTitle: "Please check your internet connection.", viewController: self)
                    DispatchQueue.main.async {
                        self.stopAnimating()
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func ImagePickBTNClick(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let gallaryAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else
            {
                ShowAlert(subTitle: "Your device don't have camera.", viewController: self)
            }
        }
        let RemoveAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        alert.addAction(gallaryAction)
        alert.addAction(RemoveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        DispatchQueue.main.async {
            let cropViewController = TOCropViewController(croppingStyle: .circular, image: image!)//(image: image!)
            cropViewController.delegate = self
            cropViewController.toolbar.tintColor = UIColor.white
            cropViewController.toolbar.doneTextButton.setTitleColor(UIColor.white, for: .normal)
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        EventImageView.image = image
        CheckImage = 1
    }
    

}

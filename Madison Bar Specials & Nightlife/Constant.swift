//
//  Constant.swift
//  Veta
//
//  Created by Vivek Malani on 06/10/17.
//  Copyright © 2017 FutureMD. All rights reserved.
//
import UIKit
import Foundation
import NVActivityIndicatorView
import MapKit
var API_URL = "http://madisonbarspecialsandnightlife.com/MedisonBar/public/api/"
var LoadeSize = CGSize(width: 45, height: 45)
var BarListAry = NSMutableArray()
var EventListAry = NSMutableArray()
var Default = UserDefaults.standard
var Token = "123456"
var AppThemeColor = UIColor(red: 197.0/255.0, green: 5.0/255.0, blue: 12.0/255.0, alpha: 1.0)
var PrimaryColor = UIColor(red: 155.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
extension UIView
{
    var YH : CGFloat{
        return self.frame.size.height+self.frame.origin.y
    }
    var XW : CGFloat{
        return self.frame.size.width+self.frame.origin.x
    }
    var Width : CGFloat{
        return self.frame.size.width
    }
    var Height : CGFloat{
        return self.frame.size.height
    }
    var X : CGFloat{
        return self.frame.origin.x
    }
    var Y : CGFloat{
        return self.frame.origin.y
    }
    func setBorderAndCorner(_ BS:CGFloat,color:UIColor,CS:CGFloat) {
        self.layer.cornerRadius = CS
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = BS
        self.clipsToBounds = true
    }
    
    func LoaderView() -> NVActivityIndicatorView
    {
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.Width/4, height: self.Width/8),
                                                            type: NVActivityIndicatorType(rawValue: 3)!)
        activityIndicatorView.center = self.center
        return activityIndicatorView
    }
}

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UITextField
{
    func SetBorder()
    {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = AppThemeColor.cgColor
        self.clipsToBounds=true
        self.layer.cornerRadius = 5.0
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)//CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

func ShowAlert(subTitle:String, viewController:UIViewController)
{
    let alert = UIAlertController(title: "Madison Nightlife", message: subTitle, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(defaultAction)
    viewController.present(alert, animated: true, completion: nil)
}
func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func timeAgoSinceDate(date:NSDate, numericDates:Bool, agoStr: String) -> String {
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
    
    if (components.year! >= 2) {
        return "\(components.year!) years \(agoStr)"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year \(agoStr)"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months \(agoStr)"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month \(agoStr)"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks \(agoStr)"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week \(agoStr)"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days \(agoStr)"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day \(agoStr)"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours \(agoStr)"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour \(agoStr)"
        } else {
            return "An hour \(agoStr)"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes \(agoStr)"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute \(agoStr)"
        } else {
            return "A minute \(agoStr)"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds \(agoStr)"
    } else {
        return "Just now"
    }
    
}
extension String {
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
    var index = 0
    var imageView: UIImageView!
}

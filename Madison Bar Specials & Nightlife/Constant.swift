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
var API_URL = "https://api.urban.boutique/dev/"
var Header = ["x-api-key":"UePBKb6Hdx9jfHue3GaDy30MpyzwJ7DS2PtjXu95"]
//var Account_ID = "123456"
var FCMToken = "123456"
var UserData = NSDictionary()
var Default = UserDefaults.standard
var EventID = ""
var LoadeSize = CGSize(width: 45, height: 45)
var AddressAry = NSMutableArray()
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

extension UITextField
{
    func BottomBorder()
    {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
}

extension String {
    
    // get word array from text-line
    var words: [String] {
        var result:[String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) {
            (substring, substringRange, enclosingRange, stop) -> () in
            result.append(substring!)
        }
        return result
    }
    // find word length
    var length: Int {
        return characters.count
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var strikethroughStyle : NSMutableAttributedString {
        
        let myMutableString = NSMutableAttributedString(string: self)
        
        myMutableString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location:0,length:self.length))
        
        return myMutableString
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

extension Date {
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    //    func weeksFrom(date:NSDate) -> Int{
    //        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    //    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    //    func secondsFrom(date:NSDate) -> Int{
    //        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    //    }
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date)) years"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date)) months"  }
        //        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date)) days"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date)) hours"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date)) mins" }
        //        if secondsFrom(date) > 0 { return "\(secondsFrom(date)) second ago" }
        
        
        return ""
    }
}

func ShowAlert(subTitle:String, viewController:UIViewController)
{
    let alert = UIAlertController(title: "Urban Boutique", message: subTitle, preferredStyle: .alert)
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
func ConvertDate(_ dateString : String) -> String
{
    let dateformate = DateFormatter()
    dateformate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateformate.timeZone = TimeZone.autoupdatingCurrent
    
    let date = Date()
    let sdate = dateformate.string(from: date)
    let todate = dateformate.date(from: sdate)
    
    
    
    let finaldate  = dateformate.date(from: dateString)!
    let diff = todate!.offsetFrom(finaldate)
    
    return diff
    
}

func CreateProductView(XPoint:CGFloat, YPoint:CGFloat, Width:CGFloat, productDict: NSDictionary) -> UIView
{
    let BackView = UIView(frame: CGRect(x: XPoint, y: YPoint, width: Width, height: 200))
    BackView.clipsToBounds=true
    BackView.layer.cornerRadius=5.0
    BackView.layer.borderWidth=1.0
    BackView.layer.borderColor=UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
    
    let productIMG = UIImageView(frame: CGRect(x: 0, y: 0, width: BackView.Width, height: BackView.Width))
    productIMG.sd_setImage(with: URL(string: productDict.value(forKey: "image") as! String), placeholderImage: UIImage(named: "ic_home_main_logo"))
    BackView.addSubview(productIMG)
    
    let TitleLBL = UILabel(frame: CGRect(x: 5, y: productIMG.YH + 5, width: BackView.Width-10, height: 20))
    TitleLBL.font = UIFont.boldSystemFont(ofSize: 11.0)
    TitleLBL.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    TitleLBL.text = productDict.value(forKey: "title") as? String
    BackView.addSubview(TitleLBL)
    
    let SalePrice = Double("\(productDict.value(forKey: "discount_price")!)")!
    let RegPrice = Double("\(productDict.value(forKey: "regular_price")!)")!
    
    let DiscountPriceLBL = UILabel(frame: CGRect(x: 5, y: TitleLBL.YH + 5, width: (BackView.Width/2)-5, height: 20))
    DiscountPriceLBL.font = UIFont.boldSystemFont(ofSize: 11.0)
    DiscountPriceLBL.textColor = UIColor(red: 29.0/255.0, green: 87.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    DiscountPriceLBL.text = "$\(String(format: "%.2f", SalePrice))"
    BackView.addSubview(DiscountPriceLBL)
    
    let RegularPriceLBL = UILabel(frame: CGRect(x: DiscountPriceLBL.XW, y: TitleLBL.YH + 5, width: (BackView.Width/2)-5, height: 20))
    RegularPriceLBL.font = UIFont.boldSystemFont(ofSize: 11.0)
    RegularPriceLBL.textColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    BackView.addSubview(RegularPriceLBL)

    if SalePrice < RegPrice
    {
        let discountP : Double = 100.0 - SalePrice/RegPrice*100
        
        RegularPriceLBL.attributedText = "$\(String(format: "%.2f", RegPrice))".strikethroughStyle
        let DiscountImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        DiscountImage.image = UIImage(named: "ic_triangle")
        DiscountImage.tintColor = UIColor(red: 29.0/255.0, green: 87.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        BackView.addSubview(DiscountImage)
        
        let DiscountLBL = UILabel(frame: CGRect(x: -3,y: 7,width: 35,height: 20))
        DiscountLBL.text = "\(String(format: "%.0f", discountP)) %"
        DiscountLBL.font = UIFont.systemFont(ofSize: 10)
        DiscountLBL.textColor=UIColor.white
        DiscountLBL.textAlignment = .center
        BackView.addSubview(DiscountLBL)
        DiscountLBL.transform = CGAffineTransform(rotationAngle: CGFloat(-0.785))
    }
    BackView.frame.size.height = DiscountPriceLBL.YH + 5
    
    return BackView
}

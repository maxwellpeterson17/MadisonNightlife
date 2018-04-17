//
//  BarDetailsVC.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 29/11/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import Alamofire
class BarDetailsVC: UIViewController {

    @IBOutlet var BackScroll: UIScrollView!
    var BarDict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bar Details"
        LoadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func LoadData()
    {
        let barImageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 80, height: 80))
        barImageView.sd_setImage(with: URL(string: BarDict.value(forKey: "original_image") as! String), placeholderImage: nil, options: .refreshCached)
        barImageView.clipsToBounds=true
        barImageView.layer.cornerRadius = barImageView.Width/2
        barImageView.layer.borderWidth = 1.0
        barImageView.layer.borderColor = AppThemeColor.cgColor
        BackScroll.addSubview(barImageView)
        
        let BarTitle = UIButton(frame: CGRect(x: barImageView.XW+10, y: 10, width: BackScroll.Width-(barImageView.XW+15), height: 20))
        BarTitle.setTitle(BarDict.value(forKey: "bar_name") as? String, for: .normal)
        BarTitle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        BarTitle.setTitleColor(AppThemeColor, for: .normal)
        BarTitle.contentHorizontalAlignment = .left
        BackScroll.addSubview(BarTitle)
        //            BarTitle.layer.borderWidth = 1.0
        //            BarTitle.layer.borderColor = UIColor.white.cgColor
        let BarAddress = UILabel(frame: CGRect(x: barImageView.XW+10, y: BarTitle.YH+8, width: BackScroll.Width-(barImageView.XW+15), height: 25))
        BarAddress.text = BarDict.value(forKey: "address") as? String
        BarAddress.font = UIFont.systemFont(ofSize: 12.0)
        BarAddress.textColor = UIColor.white//(red: 249.0/255.0, green: 142.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        BarAddress.numberOfLines=0
        BarAddress.sizeToFit()
        BarAddress.isUserInteractionEnabled=true
        //        BarAddress.layer.borderWidth = 1.0
        //        BarAddress.layer.borderColor = UIColor.white.cgColor
        BackScroll.addSubview(BarAddress)
        
        let Tap = UITapGestureRecognizer(target: self, action: #selector(TapClick(_:)))
        BarAddress.addGestureRecognizer(Tap)
        
        let HourLBL = UILabel(frame: CGRect(x: barImageView.XW+10, y: BarAddress.YH+8, width: BackScroll.Width-(barImageView.XW+15), height: 25))
        HourLBL.text = BarDict.value(forKey: "hours") as? String
        HourLBL.font = UIFont.systemFont(ofSize: 12.0)
        HourLBL.textColor = UIColor.white//(red: 160.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        HourLBL.numberOfLines=0
        HourLBL.sizeToFit()
        BackScroll.addSubview(HourLBL)
        
        let PhoneNumber = UIButton(frame: CGRect(x: barImageView.XW+10, y: HourLBL.YH+8, width: BackScroll.Width-(barImageView.XW+15), height: 18))
        PhoneNumber.setTitle(BarDict.value(forKey: "phone_number") as? String, for: .normal)
        PhoneNumber.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        PhoneNumber.setTitleColor(UIColor.white, for: .normal)
        PhoneNumber.contentHorizontalAlignment = .left
        PhoneNumber.addTarget(self, action: #selector(PhoneBTNClick(_:)), for: .touchUpInside)
        BackScroll.addSubview(PhoneNumber)
        
        var YPoint = barImageView.YH + 10
        if barImageView.YH < PhoneNumber.YH
        {
            YPoint = PhoneNumber.YH + 10
        }
        let TempAry = BarDict.value(forKey: "bar_special") as! NSArray
        let dayAry = NSMutableArray()
        for i in 0..<TempAry.count
        {
            let TextStr = (TempAry.object(at: i) as AnyObject).value(forKey: "special_text") as! String
            if TextStr.isEmpty == false
            {
                dayAry.add(TempAry.object(at: i))
            }
        }
        
        let link = BarDict.value(forKey: "link") as! String
        if link.isEmpty == false
        {
            let yourAttributes : [String: Any] = [
                NSFontAttributeName : UIFont.systemFont(ofSize: 15.0),
                NSForegroundColorAttributeName : UIColor(red: 173.0/255.0, green: 216.0/255.0, blue: 230.0/255.0, alpha: 1.0),
                NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
            let attributeString = NSMutableAttributedString(string: "Want to skip the line?",
                                                            attributes: yourAttributes)
            let LinkBTN = UIButton(frame: CGRect(x: 0, y: YPoint, width: BackScroll.Width, height: 22))
            LinkBTN.setAttributedTitle(attributeString, for: .normal)
            LinkBTN.contentHorizontalAlignment = .right
            LinkBTN.titleLabel?.sizeToFit()
            //        LinkBTN.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            LinkBTN.addTarget(self, action: #selector(LinkBTNClick(_:)), for: .touchUpInside)
            LinkBTN.frame.origin.x = BackScroll.Width - LinkBTN.Width - 10
            BackScroll.addSubview(LinkBTN)
        }
        
        
        if dayAry.count > 0
        {
            for i in 0..<dayAry.count
            {
                let DayNameLBL = UILabel(frame: CGRect(x: barImageView.X, y: YPoint, width: BackScroll.Width-(barImageView.X*2), height: 25))
                DayNameLBL.text = (dayAry.object(at: i) as AnyObject).value(forKey: "day_name") as? String
                DayNameLBL.font = UIFont.boldSystemFont(ofSize: 15.0)
                DayNameLBL.textColor = AppThemeColor
                DayNameLBL.numberOfLines = 0
                DayNameLBL.sizeToFit()
                BackScroll.addSubview(DayNameLBL)
                
                let TextStr = (dayAry.object(at: i) as AnyObject).value(forKey: "special_text") as! String
                let decodedData = Data(base64Encoded: TextStr)
                let SpecialLBL = UILabel(frame: CGRect(x: barImageView.X, y: DayNameLBL.YH+8, width: BackScroll.Width-(barImageView.X*2), height: 25))
                if TextStr.isEmpty == true
                {
                    SpecialLBL.text = "----------------"
                }
                else
                {
                    do{
                        let AttStr = try NSAttributedString(data: decodedData!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                        SpecialLBL.attributedText = AttStr
                    }catch{
                    }
                }
                
                //SpecialLBL.text = TextStr
                SpecialLBL.font = UIFont.italicSystemFont(ofSize: 15.0)
                SpecialLBL.textColor = UIColor.white//(red: 249.0/255.0, green: 142.0/255.0, blue: 21.0/255.0, alpha: 1.0)
                SpecialLBL.numberOfLines=0
                SpecialLBL.sizeToFit()
                //                SpecialLBL.layer.borderWidth = 1.0
                BackScroll.addSubview(SpecialLBL)
                if TextStr.isEmpty == true
                {
                    YPoint = YPoint + DayNameLBL.Height + SpecialLBL.Height + 18
                }
                else
                {
                    YPoint = YPoint + DayNameLBL.Height + SpecialLBL.Height - 2
                }
            }
        }
        else
        {
            let TotalRemainingSpace = self.view.Height - YPoint
            
            let NoSpecialsLBL = UILabel(frame: CGRect(x: 10, y: TotalRemainingSpace/2, width: BackScroll.Width-20, height: 25))
            NoSpecialsLBL.text = "No specials at the moment."
            NoSpecialsLBL.font = UIFont.boldSystemFont(ofSize: 17.0)
            NoSpecialsLBL.textColor = AppThemeColor
            NoSpecialsLBL.textAlignment = .center
            //            NoSpecialsLBL.numberOfLines=0
            //            NoSpecialsLBL.sizeToFit()
            BackScroll.addSubview(NoSpecialsLBL)
        }
        BackScroll.contentSize.height = YPoint
    }

    func PhoneBTNClick(_ sender: UIButton)
    {
        let phoneNumber = "tel://\(sender.title(for: .normal)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)"
        UIApplication.shared.openURL(URL(string:phoneNumber)!)
    }
    
    func TapClick(_ sender: UITapGestureRecognizer)
    {
        UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/?q=\(BarDict.value(forKey: "latitude")!),\(BarDict.value(forKey: "longitude")!)")!)
    }
    
    func LinkBTNClick(_ sender: UIButton)
    {
        let Url = BarDict.value(forKey: "link") as! String
        let UrlFinal = URL(string: "\(Url)")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(UrlFinal, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(UrlFinal)
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

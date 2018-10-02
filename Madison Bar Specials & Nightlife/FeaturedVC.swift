//
//  FeaturedVC.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 15/12/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
class FeaturedVC: UIViewController, NVActivityIndicatorViewable {

    //@IBOutlet var background: UIImageView!
    @IBOutlet var NoLBL: UILabel!
    @IBOutlet var BackScroll: UIScrollView!
    @IBOutlet var GetTicketsBN: UIButton!
    @IBOutlet var DescLBL: UILabel!
    @IBOutlet var SubTitleLBL: UILabel!
    @IBOutlet var TitleLBL: UILabel!
    var FeaturedAry = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(view.LoaderView())
        
        let Formater = DateFormatter()
        Formater.dateFormat = "EEEE MM/d"
        TitleLBL.text = Formater.string(from: Date())
        
        //startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
        Alamofire.request("\(API_URL)getFutureDetail", method: .get).responseJSON { (response) in
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
                    if let responseD = responseDict.value(forKey: "response") as? NSDictionary
                    {
                        self.FeaturedAry.add(responseD)
                    }
                    else
                    {
                        self.FeaturedAry = NSMutableArray(array: responseDict.value(forKey: "response") as! NSArray)
                    }
                    if self.FeaturedAry.count > 0
                    {
                        self.LoadData()
                    }
                }
                else
                {
                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                }
            }
            //self.stopAnimating()
           // self.background.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func LoadData()
    {
        //print(dict)
        NoLBL.isHidden = true
        TitleLBL.isHidden = false
//        background.isHidden = true
        var YPoint : CGFloat = 0.0
        for i in 0..<FeaturedAry.count
        {
            let FeaturedDict = FeaturedAry.object(at: i) as! NSDictionary
            
            let SubTitle = UILabel(frame: CGRect(x: 10, y: YPoint, width: BackScroll.Width-20, height: 25))
            SubTitle.text = FeaturedDict.value(forKey: "bar_name") as? String
            SubTitle.textColor = AppThemeColor
            SubTitle.font = UIFont.systemFont(ofSize: 18.0)
            BackScroll.addSubview(SubTitle)
            
            let DescLBL = UILabel(frame: CGRect(x: 10, y: SubTitle.YH + 8, width: BackScroll.Width-20, height: 25))
            let EncodeStr = FeaturedDict.value(forKey: "event_name") as! String
            let decodedData = Data(base64Encoded: EncodeStr)
            do{
                let AttStr = try NSAttributedString(data: decodedData!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                DescLBL.attributedText=AttStr
            }catch{
            }
            DescLBL.font = UIFont.systemFont(ofSize: 18.0)
            DescLBL.textColor = UIColor.white
            DescLBL.numberOfLines=0
            DescLBL.sizeToFit()
            BackScroll.addSubview(DescLBL)
            if "\(FeaturedDict.value(forKey: "links")!)" != ""
            {
                let yourAttributes : [String: Any] = [
                    NSFontAttributeName : UIFont.systemFont(ofSize: 17.0),
                    NSForegroundColorAttributeName : UIColor(red: 173.0/255.0, green: 216.0/255.0, blue: 230.0/255.0, alpha: 1.0),
                    NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
                let attributeString = NSMutableAttributedString(string: "Get Tickets",
                                                                attributes: yourAttributes)
                let LinkBTN = UIButton(frame: CGRect(x: 10, y: DescLBL.YH - 20, width: BackScroll.Width-20, height: 25))
                LinkBTN.setAttributedTitle(attributeString, for: .normal)
                LinkBTN.contentHorizontalAlignment = .left
//                LinkBTN.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                LinkBTN.tag = i
                LinkBTN.addTarget(self, action: #selector(TicketBTNClick(_:)), for: .touchUpInside)
                BackScroll.addSubview(LinkBTN)
                
                YPoint = LinkBTN.YH + 20
            }
            else
            {
                YPoint = DescLBL.YH - 15
            }
        }
        BackScroll.contentSize.height = YPoint
    }
    
    func TicketBTNClick(_ sender: UIButton) {
        let Url = (FeaturedAry.object(at: sender.tag) as AnyObject).value(forKey: "links") as! String
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

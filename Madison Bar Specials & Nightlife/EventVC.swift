//
//  EventVC.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 29/11/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SDWebImage
import CCBottomRefreshControl
class EventVC: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var NoDataLBL: UILabel!
    @IBOutlet var EventListTBL: UITableView!
    let cellID = "cell"
    
    let refereshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(view.LoaderView())
        
        EventListTBL.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        EventListTBL.tableFooterView = UIView(frame: .zero)
        refereshControl.tintColor = UIColor.white
        refereshControl.triggerVerticalOffset = 100
        refereshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        EventListTBL.addSubview(refereshControl)//bottomRefreshControl = refereshControl
        
        
        //self.navigationItem.title = "Events"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Events"
        if EventListAry.count == 0
        {
            startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
            CallAPI()
        }
        else
        {
            NoDataLBL.isHidden=true
            EventListTBL.reloadData()
        }
    }
    
    func refresh()
    {
        CallAPI()
    }
    
    @IBAction func AddBTNClick(_ sender: UIBarButtonItem) {
        
        self.navigationItem.title = "Back"
        
        let Stry = self.storyboard?.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        self.navigationController?.pushViewController(Stry, animated: true)
    }

    func CallAPI()
    {
        Alamofire.request("\(API_URL)getEventList", method: .get).responseJSON(completionHandler: { (response) in
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
                    EventListAry.removeAllObjects()
                    let TempAry = responseDict.value(forKey: "response") as! NSArray
                    for i in 0..<TempAry.count
                    {
                        let Dict = TempAry.object(at: i) as! NSDictionary
                        let Formater = DateFormatter()
                        Formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = Formater.date(from: "\(Dict.value(forKey: "date")!) \(Dict.value(forKey: "time")!)")
                        let dayHourMinuteSecond: Set<Calendar.Component> = [.hour,.minute,.second]
                        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to: date!)
                        //print(difference.hour)
                        if (-3) <= difference.hour!
                        {
                            EventListAry.insert(TempAry.object(at: i), at: 0)
                        }
                    }
                    if EventListAry.count > 0
                    {
                        self.NoDataLBL.isHidden = true
                    }
                    else
                    {
                        self.NoDataLBL.isHidden = false
                    }
//                    self.EventListAry = NSMutableArray(array: responseDict.value(forKey: "response") as! NSArray)
                }
                else
                {
                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                }
            }
            
            DispatchQueue.main.async {
                self.stopAnimating()
                self.refereshControl.endRefreshing()
                self.EventListTBL.reloadData()
            }
            
//            let when = DispatchTime.now() + 1
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                
//            }
            
//            DispatchQueue.main.async {
//                
//            }
        })
        
        //        self.stopAnimating()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventListAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellID)!
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellID)
        cell.backgroundColor = UIColor.clear
        cell.frame.size.width = self.view.Width
        let barDict = EventListAry.object(at: indexPath.row) as! NSDictionary
//        let TypeAry = "\(barDict.value(forKey: "")!)".components(separatedBy: ",")
        let barImageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 60, height: 60))
        barImageView.sd_setImage(with: URL(string: barDict.value(forKey: "original_image") as! String), placeholderImage: nil, options: .refreshCached)
        barImageView.clipsToBounds=true
        barImageView.layer.cornerRadius = barImageView.Width/2
        barImageView.layer.borderWidth = 1.0
        barImageView.layer.borderColor = AppThemeColor.cgColor
        cell.addSubview(barImageView)
        var width = cell.Width - barImageView.XW - 20
        let is_ticket = barDict.value(forKey: "ticket_url") as! String
        let SettingBTN = UIButton(frame: CGRect(x: cell.Width-35, y: 0, width: 25, height: 25))
        if is_ticket.isEmpty == false
        {
            SettingBTN.setImage(#imageLiteral(resourceName: "invoice"), for: .normal)
            SettingBTN.tintColor = UIColor.white
            SettingBTN.addTarget(self, action: #selector(BuyTicketBTNClick(_:)), for: .touchUpInside)
            SettingBTN.tag = indexPath.row
            cell.addSubview(SettingBTN)
            width = SettingBTN.X - barImageView.XW - 20
        }
        
        let EventTitle = UILabel(frame: CGRect(x: barImageView.XW+10, y: 10, width: width, height: 25))
        EventTitle.text = barDict.value(forKey: "event_name") as? String//setTitle(barDict.value(forKey: "event_name") as? String, for: .normal)
        EventTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        EventTitle.textColor=AppThemeColor//setTitleColor(UIColor(red: 249.0/255.0, green: 142.0/255.0, blue: 21.0/255.0, alpha: 1.0), for: .normal)
//        EventTitle.contentHorizontalAlignment = .left
        //BarTitle.addTarget(self, action: #selector(TitleClick(_:)), for: .touchUpInside)
        cell.addSubview(EventTitle)
//                    EventTitle.layer.borderWidth = 1.0
        //            BarTitle.layer.borderColor = UIColor.white.cgColor
        
        let Formater = DateFormatter()
        Formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Formater.date(from: "\(barDict.value(forKey: "date")!) \(barDict.value(forKey: "time")!)")
        Formater.dateFormat = "MM/dd/yy hh:mm a"
        
        let EventDate = UILabel(frame: CGRect(x: barImageView.XW+10, y: EventTitle.YH+8, width: width, height: 25))
        EventDate.text = Formater.string(from: date!)
        EventDate.font = UIFont.systemFont(ofSize: 12.0)
        EventDate.textColor = UIColor.white//(red: 249.0/255.0, green: 142.0/255.0, blue: 21.0/255.0, alpha: 1.0
        cell.addSubview(EventDate)
        
        
//        EventVenue.layer.borderWidth = 1.0
//        print(date)
//        print(Date())
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.hour,.minute,.second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to: date!)
        if 3 >= difference.hour! && difference.hour! >= 0
        {
            if difference.second! >= 0
            {
                let AttStr = NSMutableAttributedString(string: "Starts in \(timeAgoSinceDate(date: date! as NSDate, numericDates: true, agoStr: "")) (\(Formater.string(from: date!)))")
                AttStr.addAttributes([NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)], range: NSRange(location: 0, length: "Starts in \(timeAgoSinceDate(date: date! as NSDate, numericDates: true, agoStr: ""))".count))
                EventDate.attributedText = AttStr
                EventDate.numberOfLines = 0
                EventDate.sizeToFit()
            }
            else
            {
                let AttStr = NSMutableAttributedString(string: "Started \(timeAgoSinceDate(date: date! as NSDate, numericDates: true, agoStr: "ago")) (\(Formater.string(from: date!)))")
                AttStr.addAttributes([NSForegroundColorAttributeName:UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 128.0/255.0, alpha: 1.0)], range: NSRange(location: 0, length: "Started \(timeAgoSinceDate(date: date! as NSDate, numericDates: true, agoStr: "ago"))".count))
                EventDate.attributedText = AttStr
                EventDate.numberOfLines = 0
                EventDate.sizeToFit()
            }
        }
        else
        {
            if difference.hour! <= 0
            {
                let AttStr = NSMutableAttributedString(string: "Started \(timeAgoSinceDate(date: date! as NSDate, numericDates: true, agoStr: "ago")) (\(Formater.string(from: date!)))")
                AttStr.addAttributes([NSForegroundColorAttributeName:UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 128.0/255.0, alpha: 1.0)], range: NSRange(location: 0, length: "Started \(timeAgoSinceDate(date: date! as NSDate, numericDates: true, agoStr: "ago"))".count))
                EventDate.attributedText = AttStr
                EventDate.numberOfLines = 0
                EventDate.sizeToFit()
            }
        }
//        print(YPoint)
        var locationName = barDict.value(forKey: "bar_name") as! String
        let address = barDict.value(forKey: "event_location") as! String
        if address.isEmpty == false
        {
            locationName = locationName + ", "
        }
        let AttStr = NSMutableAttributedString(string: "\(locationName)\(address)")
        AttStr.addAttributes([NSForegroundColorAttributeName:UIColor.white], range: NSRange(location: locationName.count, length: address.count))
        let BarName = UILabel(frame: CGRect(x: barImageView.XW+10, y: EventDate.YH+8, width: width, height: 25))
        BarName.textColor = AppThemeColor
        BarName.attributedText = AttStr//text = barDict.value(forKey: "bar_name") as? String
        BarName.font = UIFont.systemFont(ofSize: 12.0)
        BarName.numberOfLines=0
        BarName.sizeToFit()
        cell.addSubview(BarName)
        var Yp = BarName.YH + 8
        if let Type = barDict.value(forKey: "is_ticket_need") as? String
        {
            if Type.isEmpty == false
            {
                let EventType = UILabel(frame: CGRect(x: barImageView.XW+10, y: Yp, width: width, height: 25))
                EventType.text = returnType(Type.components(separatedBy: ",")).joined(separator: ",")
                EventType.font = UIFont.systemFont(ofSize: 12.0)
                EventType.textColor = returnColor(Type.components(separatedBy: ","))
                EventType.numberOfLines=0
                EventType.sizeToFit()
                cell.addSubview(EventType)
                
                barImageView.layer.borderColor = returnColor(Type.components(separatedBy: ",")).cgColor
                
                Yp = EventType.YH + 8
            }
        }
        if let bio = barDict.value(forKey: "event_bio") as? String
        {
            if bio.isEmpty == false
            {
//                let str = String(UnicodeScalar(Int(bio, radix: 16)!)!)
//                print(str)
                
//                print(bio)
//                print(bio.decodeEmoji)
                let Bio = UILabel(frame: CGRect(x: barImageView.XW+10, y: Yp, width: width, height: 25))
                Bio.text = bio.decodeEmoji
                Bio.font = UIFont.systemFont(ofSize: 12.0)
                Bio.textColor = UIColor.white
                Bio.numberOfLines = 0
                Bio.sizeToFit()
                cell.addSubview(Bio)
                Yp = Bio.YH + 8
            }
        }
        
        
        if barImageView.YH < Yp
        {
            EventListTBL.rowHeight = Yp + 2
        }
        else
        {
            EventListTBL.rowHeight = barImageView.YH + 10
        }
        SettingBTN.frame.origin.y = (EventListTBL.rowHeight/2) - (SettingBTN.Height/2)
        
        cell.selectionStyle = .none
       // cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let EventLat = (EventListAry.object(at: indexPath.row) as AnyObject).value(forKey: "latitude") as! String
        let EventLong = (EventListAry.object(at: indexPath.row) as AnyObject).value(forKey: "longitude") as! String
        let locationStr = (EventListAry.object(at: indexPath.row) as AnyObject).value(forKey: "event_location") as! String
        let EventName = (EventListAry.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
        if locationStr.isEmpty == true
        {
            UIApplication.shared.openURL(URL(string:"http://maps.apple.com/?q=\(EventLat),\(EventLong)")!)
        }
        else
        {
            let url = URL(string: "http://maps.apple.com/?q=\(EventName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
//            UIApplication.shared.openURL()
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func BuyTicketBTNClick(_ sender: UIButton)
    {
        DispatchQueue.global(qos: .background).async {
            let ID = (EventListAry.object(at: sender.tag) as AnyObject).value(forKey: "event_id") as! String
            Alamofire.request("\(API_URL)addVeiwDetail", method: .post, parameters: ["view_type":"events","view_id":ID]).responseJSON(completionHandler: { (response) in })
        }
        
        let Url = (EventListAry.object(at: sender.tag) as AnyObject).value(forKey: "ticket_url") as! String
        let UrlFinal = URL(string: "\(Url)")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(UrlFinal, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(UrlFinal)
        }
        
    }
    
    func returnType(_ strAry: [String])->[String]
    {
        var ary = [String]()
        for i in 0..<strAry.count
        {
            if strAry[i] == "BarEvent"
            {
                ary.append("Bar Event")
            }
            else if strAry[i] == "GreekLife"
            {
                ary.append("Greek Life")
            }
            else if strAry[i] == "HouseParty"
            {
                ary.append("House Party")
            }
            else
            {
                ary.append(strAry[i])
            }
        }
        return ary
    }
    
    func returnColor(_ typeAry: [String]) -> UIColor
    {
        if typeAry.count > 1
        {
            return UIColor.white
        }
        else
        {
            if typeAry[0] == "BarEvent"
            {
                return AppThemeColor
            }
            else if typeAry[0] == "GreekLife"
            {
                return UIColor(red: 255.0/255.0, green: 227.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            }
            else if typeAry[0] == "HouseParty"
            {
                return UIColor(red: 105.0/255.0, green: 180.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            }
            else if typeAry[0] == "Concert"
            {
                return UIColor(red: 207.0/255.0, green: 64.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            }
            else if typeAry[0] == "Sports"
            {
                return UIColor(red: 180.0/255.0, green: 255.0/255.0, blue: 105.0/255.0, alpha: 1.0)
            }
            else if typeAry[0] == "Theater"
            {
                return UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            }
            else if typeAry[0] == "Comedy"
            {
                return UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            }
            else
            {
                return UIColor.white
            }
        }
    }
}

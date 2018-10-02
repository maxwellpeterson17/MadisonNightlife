//
//  DaysDetailsVC.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 29/11/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CCBottomRefreshControl
import Alamofire
class DaysDetailsVC: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var BarlistTBL: UITableView!
    @IBOutlet var NoLBL: UILabel!
    let cellID = "cell"
    var BarListAry = NSMutableArray()
    var TempAry = NSMutableArray()
    let refereshControl = UIRefreshControl()
    var DayName = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = DayName
        
        view.addSubview(view.LoaderView())
        
        BarlistTBL.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        BarlistTBL.tableFooterView = UIView(frame: .zero)
        BarlistTBL.separatorStyle = .none
        
        if TempAry.count > 0
        {
            NoLBL.isHidden = true
        }
        else
        {
            NoLBL.isHidden = false
        }
        
        for i in 0..<TempAry.count
        {
            let dayAry = (TempAry.object(at: i) as AnyObject).value(forKey: "bar_special") as! NSArray
            for j in 0..<dayAry.count
            {
                //                            print(self.DayName.lowercased())
                //                            print("\((dayAry.object(at: j) as AnyObject).value(forKey: "day_name")!)".lowercased())
                
                let DayStr = "\((dayAry.object(at: j) as AnyObject).value(forKey: "day_name")!)".lowercased()
                let TextStr = "\((dayAry.object(at: j) as AnyObject).value(forKey: "special_text")!)"
                if DayName.lowercased() == DayStr && TextStr.isEmpty == false
                {
                    BarListAry.add(TempAry.object(at: i))
                    break
                }
            }
            
        }
        
        
//        CallAPI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh()
    {
        refereshControl.endRefreshing()
        //        if NextStr.isEmpty == false
        //        {
        //            Offset += 1
        //            GetEventList()
        //        }
        //        else
        //        {
        //            refereshControl.endRefreshing()
        //        }
    }
    
    
    
    func CallAPI()
    {
        startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
        Alamofire.request("\(API_URL)getBarList", method: .get).responseJSON(completionHandler: { (response) in
            if response.result.error != nil
            {
                //ShowAlert(subTitle: "Please check your internet connection.", viewController: self)
            }
            else
            {
                let responseDict = response.result.value as! NSDictionary
                let ResponseCode = "\(responseDict.value(forKey: "code")!)"
                print(responseDict)
                if ResponseCode == "200"
                {
                    let TempAry = responseDict.value(forKey: "response") as! NSArray
                    for i in 0..<TempAry.count
                    {
                        let dayAry = (TempAry.object(at: i) as AnyObject).value(forKey: "bar_special") as! NSArray
                        for j in 0..<dayAry.count
                        {
//                            print(self.DayName.lowercased())
//                            print("\((dayAry.object(at: j) as AnyObject).value(forKey: "day_name")!)".lowercased())
                            
                            let DayStr = "\((dayAry.object(at: j) as AnyObject).value(forKey: "day_name")!)".lowercased()
                            let TextStr = "\((dayAry.object(at: j) as AnyObject).value(forKey: "special_text")!)"
                            if self.DayName.lowercased() == DayStr && TextStr.isEmpty == false
                            {
                                self.BarListAry.add(TempAry.object(at: i))
                                break
                            }
                        }
                    }
                    
                    //self.BarListAry = NSMutableArray(array: responseDict.value(forKey: "response") as! NSArray)
                }
                else
                {
                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                }
            }
            
            DispatchQueue.main.async {
                self.BarlistTBL.reloadData()
                self.stopAnimating()
//                self.refereshControl.endRefreshing()
            }
        })
        
        //        self.stopAnimating()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BarListAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellID)!
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellID)
        cell.backgroundColor = UIColor.clear
        cell.frame.size.width = self.view.Width
        let barDict = BarListAry.object(at: indexPath.row) as! NSDictionary
        
        let BarTitle = UIButton(frame: CGRect(x: 10, y: 10, width: cell.Width-20, height: 20))
        BarTitle.setTitle(barDict.value(forKey: "bar_name") as? String, for: .normal)
        BarTitle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        BarTitle.setTitleColor(AppThemeColor, for: .normal)
//        BarTitle.contentHorizontalAlignment = .left
        cell.addSubview(BarTitle)
        
        let dayAry = barDict.value(forKey: "bar_special") as! NSArray
        let SpecialLBL = UILabel(frame: CGRect(x: 10, y: BarTitle.YH+8, width: cell.Width-20, height: 25))
        for i in 0..<dayAry.count
        {
            if DayName.lowercased() == "\((dayAry.object(at: i) as AnyObject).value(forKey: "day_name")!)".lowercased()
            {
                let EncodeStr = (dayAry.object(at: i) as AnyObject).value(forKey: "special_text") as! String
                let decodedData = Data(base64Encoded: EncodeStr)
//                let decodedStr = String(data: decodedData!, encoding: .utf8)
//                print(decodedStr)
                do{
                    let AttStr = try NSAttributedString(data: decodedData!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                    SpecialLBL.attributedText=AttStr
                }catch{
                    
                }
                
                break
            }
        }
        SpecialLBL.font = UIFont.italicSystemFont(ofSize: 15.0)
        SpecialLBL.textColor = UIColor.white//(red: 249.0/255.0, green: 142.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        SpecialLBL.numberOfLines=0
        SpecialLBL.sizeToFit()
        cell.addSubview(SpecialLBL)
        
        cell.selectionStyle = .none
        
        BarlistTBL.rowHeight = SpecialLBL.YH - 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

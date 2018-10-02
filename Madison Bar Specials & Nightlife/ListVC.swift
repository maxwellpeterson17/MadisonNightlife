//
//  ViewController.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 29/11/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CCBottomRefreshControl
import Alamofire
import SDWebImage
class ListVC: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource{

    //@IBOutlet var background: UIImageView!
    @IBOutlet var DaysTBL: UITableView!
    @IBOutlet var NoDataLBL: UILabel!
    @IBOutlet var BarlistTBL: UITableView!
    let cellID = "cell"
    
    var DaysAry : NSMutableArray = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let refereshControl = UIRefreshControl()
    @IBOutlet var Segment: UISegmentedControl!
    var day = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(view.LoaderView())
        
        BarlistTBL.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        BarlistTBL.tableFooterView = UIView(frame: .zero)
        
        DaysTBL.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        DaysTBL.tableFooterView = UIView(frame: .zero)
        
        refereshControl.tintColor = UIColor.white
//        refereshControl.triggerVerticalOffset = 100
        refereshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        BarlistTBL.addSubview(refereshControl)//bottomRefreshControl = refereshControl
        
        self.tabBarController?.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: PrimaryColor, size: CGSize(width: self.view.Width/5, height: self.tabBarController!.tabBar.Height))
//        tabBar.setValue(true, forKey: "_hidesShadow")
        
        let Formater = DateFormatter()
        Formater.dateFormat = "EEEE"
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: -4, to: Date())
        day = Formater.string(from: date!)
        
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        
        //print(day)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Bar Specials"
        if BarListAry.count > 0
        {
            NoDataLBL.isHidden=true
            BarlistTBL.reloadData()
        }
        else
        {
            //background.isHidden = false
            //startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
            CallAPI()
        }
    }

    func refresh()
    {
        CallAPI()
    }
    
    func timerFire()
    {
        CallAPI()
    }
    
    @IBAction func SegmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            NoDataLBL.isHidden=true
            DaysTBL.isHidden=false
            BarlistTBL.isHidden=true
        }
        else
        {
            if BarListAry.count == 0
            {
//                NoDataLBL.isHidden = false
                //startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
                //background.isHidden = false
                CallAPI()
            }
            DaysTBL.isHidden=true
            BarlistTBL.isHidden=false
        }
        
    }
    
    
    func CallAPI()
    {
        
        Alamofire.request("\(API_URL)getBarList/\(day.lowercased())", method: .get).responseJSON(completionHandler: { (response) in
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
                    BarListAry = NSMutableArray(array: responseDict.value(forKey: "response") as! NSArray)
                    if self.Segment.selectedSegmentIndex == 1
                    {
                        if BarListAry.count > 0
                        {
                            self.NoDataLBL.isHidden = true
                        }
                        else
                        {
                            self.NoDataLBL.isHidden = false
                        }
                        
                    }
                    
                }
                else
                {
                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                }
            }
            
            DispatchQueue.main.async {
                self.BarlistTBL.reloadData()
                //self.stopAnimating()
                //self.background.isHidden = true
                self.refereshControl.endRefreshing()
            }
        })
        
//        self.stopAnimating()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == BarlistTBL
        {
            return BarListAry.count
        }
        else
        {
            return DaysAry.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellID)!
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellID)
        cell.backgroundColor = UIColor.clear
        cell.frame.size.width = self.view.Width
        
        if tableView == DaysTBL
        {
            cell.textLabel?.text = DaysAry.object(at: indexPath.row) as? String
            if day.lowercased() == "\(DaysAry.object(at: indexPath.row))".lowercased()
            {
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                cell.textLabel?.textColor = AppThemeColor
            }
            else
            {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
                cell.textLabel?.textColor = UIColor.white
            }
            BarlistTBL.rowHeight = 44
        }
        else
        {
            
            let barDict = BarListAry.object(at: indexPath.row) as! NSDictionary
            
            let barImageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 60, height: 60))
            barImageView.sd_setImage(with: URL(string: barDict.value(forKey: "original_image") as! String), placeholderImage: nil, options: .refreshCached)
            barImageView.clipsToBounds=true
            barImageView.layer.cornerRadius = barImageView.Width/2
            barImageView.layer.borderWidth = 1.0
            barImageView.layer.borderColor = AppThemeColor.cgColor
            cell.addSubview(barImageView)
            
            let BarTitle = UIButton(frame: CGRect(x: barImageView.XW+10, y: 10, width: cell.Width-(barImageView.XW+40), height: 20))
            BarTitle.setTitle(barDict.value(forKey: "bar_name") as? String, for: .normal)
            BarTitle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            BarTitle.setTitleColor(AppThemeColor, for: .normal)
            BarTitle.contentHorizontalAlignment = .left
            BarTitle.addTarget(self, action: #selector(TitleClick(_:)), for: .touchUpInside)
//            BarTitle.isUserInteractionEnabled=true
            BarTitle.isEnabled = false
            cell.addSubview(BarTitle)
//            BarTitle.layer.borderWidth = 1.0
//            BarTitle.layer.borderColor = UIColor.white.cgColor
            let BarAddress = UILabel(frame: CGRect(x: barImageView.XW+10, y: BarTitle.YH+8, width: cell.Width-(barImageView.XW+40), height: 25))
            BarAddress.text = barDict.value(forKey: "address") as? String
            BarAddress.font = UIFont.systemFont(ofSize: 12.0)
            BarAddress.textColor = UIColor.white//(red: 249.0/255.0, green: 142.0/255.0, blue: 21.0/255.0, alpha: 1.0)
            BarAddress.numberOfLines=0
            BarAddress.sizeToFit()
            cell.addSubview(BarAddress)
            
            if barImageView.YH < BarAddress.YH
            {
                BarlistTBL.rowHeight = BarAddress.YH + 10
            }
            else
            {
                BarlistTBL.rowHeight = barImageView.YH + 10
            }
        }
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationItem.title = "Back"
        
        if tableView == DaysTBL
        {
            let Stry = self.storyboard?.instantiateViewController(withIdentifier: "DaysDetailsVC") as! DaysDetailsVC
            self.navigationController?.pushViewController(Stry, animated: true)
            
            //print(DaysAry.object(at: indexPath.row))
            
            Stry.DayName = DaysAry.object(at: indexPath.row) as! String
            Stry.TempAry = BarListAry
        }
        else
        {
            DispatchQueue.global(qos: .background).async {
                let ID = (BarListAry.object(at: indexPath.row) as AnyObject).value(forKey: "bar_id") as! String
                Alamofire.request("\(API_URL)addVeiwDetail", method: .post, parameters: ["view_type":"bars","view_id":ID]).responseJSON(completionHandler: { (response) in })
            }
            let Stry = self.storyboard?.instantiateViewController(withIdentifier: "BarDetailsVC") as! BarDetailsVC
            self.navigationController?.pushViewController(Stry, animated: true)
            Stry.BarDict = BarListAry.object(at: indexPath.row) as! NSDictionary
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func TitleClick(_ sender: UIButton)
    {
        
    }
    
}


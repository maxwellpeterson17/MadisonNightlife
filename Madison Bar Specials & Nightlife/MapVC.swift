//
//  MapVC.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 29/11/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView
import Alamofire
import SDWebImage
import GoogleMaps
class MapVC: UIViewController, MKMapViewDelegate, NVActivityIndicatorViewable, GMSMapViewDelegate {

    //@IBOutlet var background: UIImageView!
    @IBOutlet var googleMap: GMSMapView!
    @IBOutlet var MapView: MKMapView!
    var eventTempAry = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(view.LoaderView())
        
//        let location = CLLocationCoordinate2DMake(43.073131, -89.400936)
//        
//        let span = MKCoordinateSpanMake(0.01, 0.01)
//        let region =  MKCoordinateRegionMake(location, span)
//        MapView.setRegion(region, animated: false)
        
        let camera = GMSCameraPosition.camera(withLatitude: 43.073131, longitude: -89.400936, zoom: 15)
        googleMap.camera = camera
//        googleMap
//        googleMap.isHidden = true
        
        
        //MapView.removeAnnotations(MapView.annotations)
        
        do {
            // Set the map style by passing a valid JSON string.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                googleMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
//        CallAPI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Map"
        DispatchQueue.main.async {
            self.LoadDataOnMap()
        }
        if BarListAry.count == 0
        {
            CallAPI()
        }
        else if EventListAry.count == 0
        {
            //startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
            //background.isHidden = false
            EventsCallAPI()
        }
    }

    func CallAPI()
    {
        let Formater = DateFormatter()
        Formater.dateFormat = "EEEE"
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: -4, to: Date())
        let day = Formater.string(from: date!)
        //startAnimating(LoadeSize, type: NVActivityIndicatorType(rawValue: 3)!)
        //background.isHidden = false
        Alamofire.request("\(API_URL)getBarList/\(day.lowercased())", method: .get).responseJSON(completionHandler: { (response) in
            if response.result.error != nil
            {
                //ShowAlert(subTitle: "Please check your internet connection.", viewController: self)
                //self.stopAnimating()
                //self.background.isHidden = true
            }
            else
            {
                let responseDict = response.result.value as! NSDictionary
                let ResponseCode = "\(responseDict.value(forKey: "code")!)"
                print(responseDict)
                if ResponseCode == "200"
                {
                    BarListAry = NSMutableArray(array: responseDict.value(forKey: "response") as! NSArray)
                }
                else
                {
                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                }
                if EventListAry.count == 0
                {
                    self.EventsCallAPI()
                }
                else
                {
                    //self.stopAnimating()
                    //self.background.isHidden = true
                    DispatchQueue.main.async {
                        self.LoadDataOnMap()
                    }
                }
            }
        })
    }
    
    func EventsCallAPI()
    {
        Alamofire.request("\(API_URL)getEventList", method: .get).responseJSON(completionHandler: { (response) in
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
                }
                else
                {
                    ShowAlert(subTitle: responseDict.value(forKey: "message") as! String, viewController: self)
                }
            }
            DispatchQueue.main.async {
                self.LoadDataOnMap()
                //self.background.isHidden = true
                //self.stopAnimating()
            }
        })
    }
    
    func LoadDataOnMap()
    {
        eventTempAry = EventListAry
        googleMap.clear()
        for i in 0..<BarListAry.count
        {
            let Latitude = CLLocationDegrees("\((BarListAry.object(at: i) as AnyObject).value(forKey: "latitude")!)")
            let Longitude = CLLocationDegrees("\((BarListAry.object(at: i) as AnyObject).value(forKey: "longitude")!)")
            
//            print(Latitude)
//            print(Longitude)
//            var check : NSDictionary!
//            let barName = (BarListAry.object(at: i) as AnyObject).value(forKey: "bar_name") as! String
//            for j in 0..<eventTempAry.count
//            {
//                let eventName = (eventTempAry.object(at: j) as AnyObject).value(forKey: "bar_name") as! String
//                if eventName.lowercased() == barName.lowercased()
//                {
//                    check = eventTempAry.object(at: j) as! NSDictionary
//                    eventTempAry.removeObject(at: j)
//                    break
//                }
//            }
            
            let PinView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 47))
            PinView.backgroundColor = UIColor.clear
            PinView.isUserInteractionEnabled = true
            PinView.image = #imageLiteral(resourceName: "orange_pin")
//            if check != nil
//            {
//                if let Type = check.value(forKey: "is_ticket_need") as? String
//                {
//                    if Type.isEmpty == false
//                    {
//                        let TypeAry = Type.components(separatedBy: ",")
//                        if TypeAry.count > 1
//                        {
//                            PinView.image = pinImage("123")
//                        }
//                        else
//                        {
//                            PinView.image = pinImage(Type)
//                        }
//                    }
//                }
//            }
            let barImg = UIImageView(frame: CGRect(x: 5, y: 5, width: PinView.Width-10, height: PinView.Width-10))
            barImg.sd_setImage(with: URL(string: "\((BarListAry.object(at: i) as AnyObject).value(forKey: "original_image")!)"), placeholderImage: nil, options: .refreshCached)
            barImg.clipsToBounds=true
            barImg.layer.cornerRadius = barImg.Width/2
            PinView.addSubview(barImg)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Latitude!, longitude: Longitude!)
            marker.appearAnimation = .pop
            marker.map = googleMap
            marker.title = (BarListAry.object(at: i) as AnyObject).value(forKey: "bar_name") as? String
            marker.iconView = PinView
            marker.snippet = (BarListAry.object(at: i) as AnyObject).value(forKey: "hours") as? String
            marker.userData = ["id":"\(i)"]
//            let info = CustomPointAnnotation()
//            info.coordinate = CLLocationCoordinate2DMake(Latitude!, Longitude!)
//            let EventHere = "\((BarListAry.object(at: i) as AnyObject).value(forKey: "is_event")!)"
//            if EventHere == "1"
//            {
//                info.imageName = "yellow_pin"
//            }
//            else
//            {
//                info.imageName = "orange_pin"
//            }
//            
//            info.title=(BarListAry.object(at: i) as AnyObject).value(forKey: "bar_name") as? String
//            info.index = i
//            info.subtitle = (BarListAry.object(at: i) as AnyObject).value(forKey: "hours") as? String
//            
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//            imageView.sd_setImage(with: URL(string: (BarListAry.object(at: i) as AnyObject).value(forKey: "original_image") as! String), placeholderImage: nil, options: .refreshCached)
//            imageView.clipsToBounds=true
//            imageView.layer.cornerRadius = imageView.Width/2
//            imageView.layer.borderWidth = 1.0
//            imageView.layer.borderColor = UIColor(red: 160.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
//            info.imageView = imageView
//            MapView.addAnnotation(info)
        }
//        print(eventTempAry)
        for i in 0..<eventTempAry.count
        {
            let visibility = "\((eventTempAry.object(at: i) as AnyObject).value(forKey: "pin_visibility")!)"
            if visibility == "1"
            {
                let Latitude = CLLocationDegrees("\((eventTempAry.object(at: i) as AnyObject).value(forKey: "latitude")!)")
                let Longitude = CLLocationDegrees("\((eventTempAry.object(at: i) as AnyObject).value(forKey: "longitude")!)")
                
                //            print(Latitude)
                //            print(Longitude)
                
                let PinView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 47))
                PinView.backgroundColor = UIColor.clear
                PinView.isUserInteractionEnabled = true
                PinView.image = #imageLiteral(resourceName: "orange_pin")
                
                if let Type = (eventTempAry.object(at: i) as AnyObject).value(forKey: "is_ticket_need") as? String
                {
                    if Type.isEmpty == false
                    {
                        let TypeAry = Type.components(separatedBy: ",")
                        if TypeAry.count > 1
                        {
                            PinView.image = pinImage("123")
                        }
                        else
                        {
                            PinView.image = pinImage(Type)
                        }
                    }
                }
                
                //            let TypeStr = (eventTempAry.object(at: i) as AnyObject).value(forKey: "is_ticket_need") as! String
                //            let TypeAry = TypeStr.components(separatedBy: ",")
                //            if TypeAry.count > 1
                //            {
                //                PinView.image = pinImage("123")
                //            }
                //            else
                //            {
                //                PinView.image = pinImage(TypeStr)
                //            }
                let barImg = UIImageView(frame: CGRect(x: 5, y: 5, width: PinView.Width-10, height: PinView.Width-10))
                barImg.sd_setImage(with: URL(string: "\((eventTempAry.object(at: i) as AnyObject).value(forKey: "original_image")!)"), placeholderImage: nil, options: .refreshCached)
                barImg.clipsToBounds=true
                barImg.layer.cornerRadius = barImg.Width/2
                PinView.addSubview(barImg)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Latitude!, longitude: Longitude!)
                marker.appearAnimation = .pop
                marker.map = googleMap
                marker.title = (eventTempAry.object(at: i) as AnyObject).value(forKey: "event_name") as? String
                marker.iconView = PinView
                
                let Formater = DateFormatter()
                Formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = Formater.date(from: "\((eventTempAry.object(at: i) as AnyObject).value(forKey: "date")!) \((eventTempAry.object(at: i) as AnyObject).value(forKey: "time")!)")
                Formater.dateFormat = "MM/dd/yy hh:mm a"
                
                let location = (eventTempAry.object(at: i) as AnyObject).value(forKey: "event_location") as! String
                var Str = Formater.string(from: date!)
                if location.isEmpty == false
                {
                    Str = Str + "\n\(location)"
                }
                marker.snippet = Str
                marker.userData = ["id":"event"]
            }
            
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let userInfo = marker.userData as! NSDictionary
        let I = userInfo.value(forKey: "id") as! String
        
        if I == "event"
        {
            self.tabBarController?.selectedIndex = 3
        }
        else
        {
            let In = Int(I)!
            DispatchQueue.global(qos: .background).async {
                let ID = (BarListAry.object(at: In) as AnyObject).value(forKey: "bar_id") as! String
                Alamofire.request("\(API_URL)addVeiwDetail", method: .post, parameters: ["view_type":"bars","view_id":ID]).responseJSON(completionHandler: { (response) in })
            }
            self.navigationItem.title = "Back"
            let Stry = self.storyboard?.instantiateViewController(withIdentifier: "BarDetailsVC") as! BarDetailsVC
            self.navigationController?.pushViewController(Stry, animated: true)
            Stry.BarDict = BarListAry.object(at: In) as! NSDictionary
        }
    }
    
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        
//        let V = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        V.backgroundColor = UIColor.red
//        
//        return V
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            let cpa = annotation as! CustomPointAnnotation
            annotationView.image = UIImage(named:cpa.imageName)
            annotationView.leftCalloutAccessoryView = cpa.imageView
            annotationView.tag = cpa.index
        }
        
        return annotationView
    }
    

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
//        view.center = mapView.center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ClickTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.removeGestureRecognizer(view.gestureRecognizers!.first!)
    }
    
    func ClickTap(_ sender: UITapGestureRecognizer)
    {
        
        
        
        let Stry = self.storyboard?.instantiateViewController(withIdentifier: "BarDetailsVC") as! BarDetailsVC
        self.navigationController?.pushViewController(Stry, animated: true)
        Stry.BarDict = BarListAry.object(at: sender.view!.tag) as! NSDictionary
    }
    
    func pinImage(_ str: String) -> UIImage
    {
        if str == "BarEvent"
        {
            return #imageLiteral(resourceName: "bar_event")
        }
        else if str == "Philanthropy"
        {
            return #imageLiteral(resourceName: "greek_life_yellow")
        }
        else if str == "Party"
        {
            return #imageLiteral(resourceName: "house_party_blue")
        }
        else if str == "Concert"
        {
            return #imageLiteral(resourceName: "concert_purple")
        }
        else if str == "Sports"
        {
            return #imageLiteral(resourceName: "sports_green")
        }
        else if str == "Theater"
        {
            return #imageLiteral(resourceName: "comedy_theater_pink")
        }
        else if str == "Comedy"
        {
            return #imageLiteral(resourceName: "comedy")
        }
        else
        {
            return #imageLiteral(resourceName: "miscellaneous_white")
        }
    }
    
}

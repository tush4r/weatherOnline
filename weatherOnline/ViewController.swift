//
//  ViewController.swift
//  weatherOnline
//
//  Created by Tushar Sharma on 08/01/16.
//  Copyright © 2016 edbinx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var weatherMonth: UILabel!
    var json = JSON.null
    
    
    
    private struct weatherConstants {
    
        static let monthsName =         ["Jan", "Feb", "Mar", "Apr", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
        static let websiteAPI =         "http://api.worldweatheronline.com/free/v1/weather.ashx?q=bangalore&format=json&num_of_days=5&key=329c87ezzdxyx73v8wahx9cm"
        static let cellReuseIdentity = "cell"
        static let JSONFieldData =     "data"
        static let JSONFieldWeather =  "weather"
        static let defaultImage =      "na.png"
        static let constantIndex = 0
    }
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        jsonParse()
        getMonth()
    }

//MARK: Alamofire GET Requests
//Using Alamofire 3rd Party API for fetching JSON
    
    func jsonParse () {
        
        
        Alamofire.request(.GET, weatherConstants.websiteAPI) .responseJSON { data in
            guard data.result.error == nil else {
                return
            }
            
            let value : AnyObject = data.result.value!
            self.json = JSON(value)
            self.collectionView.reloadData()
            
            }
    }

//END OF ALAMOFIRE MODULE
//MARK: UILabel Month Display
    
    func getMonth() {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Month, fromDate: date)
        let month = components.month
        weatherMonth.text = weatherConstants.monthsName[month-1]
    }

//END OF Month Display
  
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: WeatherCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(weatherConstants.cellReuseIdentity, forIndexPath: indexPath) as! WeatherCollectionViewCell
    
//MARK: Loading Temperature
        
        let row = indexPath.row
    
        if let weatherTempData = self.json[weatherConstants.JSONFieldData][weatherConstants.JSONFieldWeather][row]["tempMaxC"].string{
            
                cell.weatherTemp.text = weatherTempData+"℃"
        
        } else {
            
            cell.weatherTemp.text = "- -"
        }
        
       
//END OF DATA FOR TEMPERATURE
//MARK: Loading Day
        
    if self.json[weatherConstants.JSONFieldData][weatherConstants.JSONFieldWeather] != nil {
    
        let weatherDay: NSDateFormatter = NSDateFormatter()
        weatherDay.dateFormat = "YYYY-MM-DD"
        let weatherDateFromJSON = self.json[weatherConstants.JSONFieldData][weatherConstants.JSONFieldWeather][row]["date"].string
        let todayDate:NSDate = weatherDay.dateFromString(weatherDateFromJSON!)!
        let currentDate = NSCalendar.currentCalendar().component(.Day, fromDate: todayDate)
        cell.weatherDay.text = String(currentDate)
        
    
    } else { cell.weatherDay.text = "- -" }
        
//END OF DATA FOR DATE
//MARK: Loading Icon

    let weatherName = self.json[weatherConstants.JSONFieldData][weatherConstants.JSONFieldWeather][row]["weatherDesc"][weatherConstants.constantIndex]["value"].string
    
        if weatherName != nil { cell.weatherImage.image = UIImage(named: weatherName!+".png")}
        
        else {cell.weatherImage.image = UIImage(named: weatherConstants.defaultImage) }
        
//END OF WEATHER ICON
    
        return cell
    }
    
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       let cell = self.json[weatherConstants.JSONFieldData][weatherConstants.JSONFieldWeather].count
        if cell != 0 { return cell } else { return 1 }
        
    }

    
}


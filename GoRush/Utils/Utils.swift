//
//  Utils.swift
//  GoRush
//
//  Created by Julien Levallois on 26/03/2020.
//  Copyright © 2020 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension
import AVKit

extension UIColor {
    public convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}



extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func loadingIndicatorLetsgoButton(_ show: Bool, image : String) {
            let tag = 808404
            if show {
                self.isEnabled = false
                let indicator = UIActivityIndicatorView()
                let buttonHeight = self.bounds.size.height
                let buttonWidth = self.bounds.size.width
                indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
                indicator.tag = tag
                indicator.color = Brain.kColorMain
                self.addSubview(indicator)
                self.setBackgroundImage(nil, for: UIControl.State.normal)
    //            self.layer.borderWidth = 0.0

                indicator.startAnimating()
            } else {
                self.isEnabled = true
                self.setBackgroundImage(UIImage.init(named:image), for: UIControl.State.normal)
    //            self.layer.borderWidth = 0.5

                if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
        }
        
        
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            self.titleLabel?.alpha = 0
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.titleLabel?.alpha = 1

            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    func loadingIndicatorGray(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            let indicator = UIActivityIndicatorView()
            indicator.color = .black
            
            
            let buttonHeight = self.bounds.size.height
            indicator.center = CGPoint(x:15, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            self.titleLabel?.alpha = 0
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.titleLabel?.alpha = 1
            
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
            }
    }
              
   func loadingIndicatorWhite(_ show: Bool) {
        let tag = 808404
               if show {
                   self.isEnabled = false
                   let indicator = UIActivityIndicatorView()
                   indicator.color = .white
                   
                   
                if let indicatorOld = self.viewWithTag(tag) as? UIActivityIndicatorView {
                                    indicatorOld.stopAnimating()
                                    indicatorOld.removeFromSuperview()
                                }
                
                   let buttonHeight = self.bounds.size.height
                   let buttonWidth = self.bounds.size.width
                   indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
                   indicator.tag = tag
                   self.addSubview(indicator)
                   self.titleLabel?.alpha = 0
                   indicator.startAnimating()
               } else {
                   self.isEnabled = true
                   self.titleLabel?.alpha = 1
                   
                   if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                       indicator.stopAnimating()
                       indicator.removeFromSuperview()
                   }
                
            }
      }
                                                    
                                                                             
    
    func loadingIndicatorFbButton(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            self.setBackgroundImage(nil, for: UIControl.State.normal)
            self.setBackgroundImage(nil, for: UIControl.State.highlighted)
            self.backgroundColor = UIColor(hex:"4267B2")
//            self.layer.borderWidth = 0.0

            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.setBackgroundImage(UIImage.init(named:NSLocalizedString("connectFb", comment: "")), for: UIControl.State.normal)
            self.setBackgroundImage(UIImage.init(named:NSLocalizedString("connectFbOn", comment: "")), for: UIControl.State.highlighted)
            self.backgroundColor = UIColor.clear
//            self.layer.borderWidth = 0.5

            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    

}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

class Utils {

    class func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }

    class func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
    
    class func returnCodeLangageEnFr() -> String {
        
        if (Locale.current.languageCode?.contains("fr"))! {
            
            return "fr"
        }else{
            
            return "en"
        }
    }

  

    
    
    class func getHeightOfStory() -> CGFloat{
        
     
        
        if Device.IS_IPHONE_X {
            
            return CGFloat(812-44)
            
        }else if Device.IS_IPHONE_XMax{
            
            return CGFloat(896-44)
            
        }else if Device.IS_IPHONE_6{
            
            return CGFloat(667)
            
        }else if Device.IS_IPHONE_6P {
            
            return CGFloat(736)
            
        }else{
            
            return CGFloat(568)
        }
        }
    
    
}

extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
        NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
        NSAttributedString.Key.font: self.font!
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}



                                       
                                       

extension UIView {
    
    func applyGradient() {
        
        let colours = [Brain.kColorMainFonce, Brain.kColorMain]
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0,y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0,y: 0.5)
        
        if self.layer.sublayers != nil {
            
            if self.layer.sublayers!.count > 1 {
                
                let old = self.layer.sublayers![0]
                old.removeFromSuperlayer()
            }
        }
        
        
        self.layer.insertSublayer(gradient, at: 0)

        self.clipsToBounds = true
    }
}
                                            
                                            
extension UIButton {
    func addRightImage(image: UIImage, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
}

                                       

extension UIView {
    func makeCorner(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.isOpaque = false
    }
    
    func roundBorder() {
        self.layer.cornerRadius = self.h() / 2
        
    }
    
    func setVerticalGradient(from color1: UIColor, to color2: UIColor) {
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setHorizontalGradient(from color1: UIColor, to color2: UIColor) {
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}



extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

func yTopBottomButtonCTA() -> CGFloat {
   
   if isIphoneXFamily() {
       
       return Brain.kHauteurIphone-90
       
   }else{
       
       return Brain.kHauteurIphone-80
   }
}

func yTop () -> CGFloat {
   
   if Device.IS_IPHONE_X || Device.IS_IPHONE_XMax {
       
       return 30
       
   }else{
       
       return 0
   }
}




func yBottom () -> CGFloat {
   
   if Device.IS_IPHONE_X || Device.IS_IPHONE_XMax {
       
       return Brain.kHauteurIphone - 30
       
   }else{
       
       return Brain.kHauteurIphone
   }
}

extension AVPlayer{
   
   func urlOfCurrentlyPlayingInPlayer() -> URL? {
       return ((self.currentItem?.asset) as? AVURLAsset)?.url
   }
}

extension UIView {
   
   func y() -> CGFloat{
       
       return  self.frame.origin.y
   }
   
   func x() -> CGFloat{
       
       return  self.frame.origin.x
   }
   
   func h() -> CGFloat{
       
       return  self.frame.size.height
   }
   
   func w() -> CGFloat{
       
       return  self.frame.size.width
       
   }
   
   func yBottom() -> CGFloat{
       
       return  self.frame.origin.y + self.frame.size.height
       
   }
    
  
}

struct Device {
   // iDevice detection code
   static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
   static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
   static let IS_RETINA           = UIScreen.main.scale >= 2.0
   
   static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
   static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
   static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
   static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
   
   static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
   static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
   static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
   static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
   static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
   static let IS_IPHONE_XMax      = IS_IPHONE && SCREEN_MAX_LENGTH == 896
   
   
}

func isIphoneXFamily()->Bool {
   
   if Device.IS_IPHONE_X || Device.IS_IPHONE_XMax{
       
       return true
       
   }else {
       
       return false
       
   }
}

                                       
func heightView(heightView:UIView) ->(CGFloat){
    
    if Device.IS_IPHONE_X {
        
        return heightView.frame.size.height - 30

    }else{
        
        return heightView.frame.size.height
    }
}



extension String {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter().mtl()
        formatter.calendar = CalendarMtl()
        formatter.dateStyle = .short
        return formatter
    }()
    var shortDate: Date! {
        return String.shortDate.date(from: self)
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIAlertController{
    
    func addColorInTitleAndMessage(color:UIColor,titleFontSize:CGFloat = 17, messageFontSize:CGFloat = 13){
        
        let attributesTitle = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleFontSize)]
        let attributesMessage = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: messageFontSize)]
        let attributedTitleText = NSAttributedString(string: self.title ?? "", attributes: attributesTitle)
        let attributedMessageText = NSAttributedString(string: self.message ?? "", attributes: attributesMessage)
        
        self.setValue(attributedTitleText, forKey: "attributedTitle")
        self.setValue(attributedMessageText, forKey: "attributedMessage")
        
    }
    
    
}


extension String {
    
    func localizableName() ->String{
        
        if (Locale.current.languageCode?.contains("fr"))! {
                  
            return Brain.kNameFr
          }else{
              
              return Brain.kName
          }
    }
}

extension URL    {
    func checkFileExist() -> Bool {
        let path = self.path
      
        if (FileManager.default.fileExists(atPath: path))   {
            print("FILE AVAILABLE")
            return true
        }else        {
            print("FILE NOT AVAILABLE")
            return false;
        }
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension DateFormatter {
    
    func mtl() -> DateFormatter {
        
        self.timeZone = TimeZone(identifier: "America/New_York")
        return self
    }
}

func CalendarMtl() -> Calendar {
    
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "America/New_York")!
    
    return calendar
    
}

extension Date {
    
    
    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
 
    
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return CalendarMtl().dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return CalendarMtl().dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return CalendarMtl().dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return CalendarMtl().dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return CalendarMtl().dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return CalendarMtl().dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return CalendarMtl().dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    

    
    func mtl() -> Date {
        
        let delta = TimeInterval(TimeZone.current.secondsFromGMT() - TimeZone.init(identifier: "America/New_York")!.secondsFromGMT())
        return addingTimeInterval(delta)
    }

    var yesterday: Date {
        return CalendarMtl().date(byAdding: .day, value: -1, to: noon)!
    }
    var lastWeek: Date {
        return CalendarMtl().date(byAdding: .day, value: -7, to: noon)!
    }
    var tomorrow: Date {
        return CalendarMtl().date(byAdding: .day, value: 1, to: noon)!
    }
    
    var in2days: Date {
        return CalendarMtl().date(byAdding: .day, value: 2, to: self)!
    }
    
    var noon: Date {
        return CalendarMtl().date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return CalendarMtl().component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter().mtl()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    var startOfDayDate: Date {
        return CalendarMtl().startOfDay(for: self)
    }
    
    var endOfDayDate: Date {
        let nextDayDate = CalendarMtl().date(byAdding: .day, value: 1, to: self.startOfDayDate)!
        return nextDayDate.addingTimeInterval(-1)
    }
    
  
    func getWeekDates() -> (thisWeek:[Date],nextWeek:[Date]) {
        var tuple: (thisWeek:[Date],nextWeek:[Date])
        var arrThisWeek: [Date] = []
        for i in 0..<7 {
            arrThisWeek.append(CalendarMtl().date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        var arrNextWeek: [Date] = []
        for i in 1...7 {
            arrNextWeek.append(CalendarMtl().date(byAdding: .day, value: i, to: arrThisWeek.last!)!)
        }
        tuple = (thisWeek: arrThisWeek,nextWeek: arrNextWeek)
        return tuple
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
    }
    
    
    var dateAdding7Hours: Date {
        return CalendarMtl().date(byAdding: .hour, value: +7, to: self)!
    }
    var dateMinus7Hours: Date {
        return CalendarMtl().date(byAdding: .hour, value: -7, to: self)!
    }
    
    var dateMinus48Hours: Date {
        return CalendarMtl().date(byAdding: .hour, value: -48, to: self)!
    }
    
    func timeAgo() -> String {
        
        let now = Date()
        let difference = now.timeIntervalSince(self)
        
        let hours = Int(difference) / 3600
        let minutes = (Int(difference) / 60) % 60
        
        
        if difference < 60 {
            
            return String(format:NSLocalizedString("%d secs ago", comment: ""),Int(difference))
            
        }else if hours < 1 {
            
            if minutes == 1 {
                
                return String(format:NSLocalizedString("%d min ago", comment: ""),minutes)
                
                
            }else{
                
                return  String(format:NSLocalizedString("%d min ago", comment: ""),minutes)
                
            }
            
        }else if hours > 24 {
            
            let days = Int(hours / 24)
            
            if days == 1 {
                
                return  String(format:NSLocalizedString("%d day ago", comment: ""),days)
                
            }else{
                
                return  String(format:NSLocalizedString("%d days ago", comment: ""),days)
                
            }
            
            
            
        }else{
            
            if hours == 1 {
                
                return  String(format:NSLocalizedString("%d hour ago", comment: ""),hours)
                
                
            }else{
                
                return  String(format:NSLocalizedString("%d hours ago", comment: ""),hours)
                
            }
            
        }
        
        
        
    }

}

extension UIViewController {
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}


extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

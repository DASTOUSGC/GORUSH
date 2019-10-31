//
//  Utils.swift
//  GoRush
//
//  Created by Julien Levallois on 18-01-27.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit

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
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
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
            let buttonWidth = self.bounds.size.width
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
            self.setBackgroundImage(nil, for: UIControlState.normal)
            self.setBackgroundImage(nil, for: UIControlState.highlighted)
            self.backgroundColor = UIColor(hex:"4267B2")
//            self.layer.borderWidth = 0.0

            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.setBackgroundImage(UIImage.init(named:NSLocalizedString("connectFb", comment: "")), for: UIControlState.normal)
            self.setBackgroundImage(UIImage.init(named:NSLocalizedString("connectFbOn", comment: "")), for: UIControlState.highlighted)
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
                                                         attributes: [NSAttributedStringKey.font: font])
        let boldFontAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
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
        NSAttributedStringKey.foregroundColor: color.withAlphaComponent(0.6),
        NSAttributedStringKey.font: self.font!
        ] as [NSAttributedStringKey : Any]
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


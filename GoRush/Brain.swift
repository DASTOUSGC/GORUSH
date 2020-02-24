//
//  Brain.swift
// GoRush
//
//  Created by Julien Levallois on 18-01-23.
//  Copyright © 2018 Julien Levallois. All rights reserved.
//

import Foundation
import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import Intercom
import Contacts
import PhoneNumberKit
import AVKit
import SwiftDate


class Brain: NSObject {


    static let kParseAppId                    =    "rd5MHEoMvQSL5eV4BUVtI9RPUbNM75JKkoESQqiT"
    static let kParseClientKey                =    "lbxe5hLHPFEPo3iNGEtYxId5QidJEcNT7iBMPbUp"
    static let kParseServer                   =    "https://pg-app-3s4icbv58asgut9dz8st2xtgd5ftbe.scalabl.cloud/1/"

    static let kStripeKey                =    "pk_test_BmEUUY0w13S2RkV1qdpFfuNS00LJ1bLSrj"

    
    static let kInstallationNotifications = "notifications"
    static let kInstallationNotificationsGroupId = "notificationsGroup"


    static let kGoogleMapsAPIKey                =    "AIzaSyA3zInJd8N5WhBsR8a7WrxQ-JaSUvhNEy0"

    static let kIntercomAPIKey                =    ""
    static let kIntercomAppId                =    ""
    
    static let kDevise                =    "cad"
    static let kCountry                =    "CA"

    static let kLoginFacebook                    =    true
    static let kLoginFacebookGetDataEachTime     =    false
    static let kFacebookPermissions = ["public_profile","email"]
    static let kFacebookData = "id, name, first_name, last_name, email,picture.type(large)"
    static let kSignup                           =    true
    static let kPhoneVerification                =    true

    static let kNavbarFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let kItemNavBarFont = UIFont.systemFont(ofSize: 13, weight: .medium)
    static let kNavbarColor = UIColor(hex: "FFFFFF")
    static let kBarbuttonItemColor = UIColor(hex: "FFFFFF")

    static let kColorMain = UIColor(hex:"EE5210")
    static let kColorMainFonce = UIColor(hex:"DB3B20")
    static let kColorCustomGray = UIColor(hex:"1E1E1E")

    static let kLargeurIphone = UIScreen.main.bounds.width
    static let kHauteurIphone = UIScreen.main.bounds.height

    static let kL = UIScreen.main.bounds.width
    static let kH = UIScreen.main.bounds.height

   // static let kColor_Seperator: UIColor = UIColor(red: 53.0/255.0, green: 126.0/255.0, blue: 167.0/255.0, alpha: 1.0)


   // Classes
    

    //Notifications
    static let kNotificationClassName = "Notification"
    static let kNotificationName = "name"
    static let kNotificationNameFr = "nameFr"
    static let kNotificationEvent = "event"
    static let kNotificationClub = "club"
    static let kNotificationAvailable = "available"
    static let kInstallationDisabledNotifs = "disabledNotifs"

    
    //User
    static let kUserClassName = "_User"
    static let kUserFirstName = "firstName"
    static let kUserLastName = "lastName"
    static let kUserEmail = "email"
    static let kUserFacebookId = "facebookId"
    static let kUserPhone = "phone"
    static let kUserProfilePicture = "profilePicture"
    static let kUserType = "type"
    static let kUserLocation = "location"
    static let kUserStripeCustomer = "stripeCustomer"
    static let kUserSkills = "skills"
    static let kUserRateWorker = "rateWorker"
    static let kUserRateCustomer = "rateCustomer"
    static let kUserReviewsCustomerNumber = "reviewsCustomerNumber"
    static let kUserReviewsWorkerNumber = "reviewsWorkerNumber"

    
    
    //StripeCustomer
      static let kStripeCustomerClassName = "StripeCustomer"
      static let kStripeCustomerIdStripe = "idStripe"
      static let kStripeWorkerIdStripe = "workerIdStripe"
      static let kStripeCustomerUser = "user"
    
    
        ////User->Mowing
        static let kUserMowing = "mowing"
        static let kUserMowingCenterPosition = "centerPosition"
        static let kUserMowingCoordinatesTotal = "coordinatesTotal"
        static let kUserMowingCoordinatesHome = "coordinatesHome"
        static let kUserMowingAreaTotal = "areaTotal"
        static let kUserMowingAreaHome = "areaHome"
        static let kUserMowingAreaResult = "areaResult"
        static let kUserMowingHeightGrass = "heightGrass"

    
    //Services
    static let kServicesClassName = "Services"
    static let kServicesName = "name"
    static let kServiceIcon = "icon"
    static let kServiceComingSoon = "comingSoon"
    static let kServiceAvailable = "available"
    static let kServiceCover = "cover"
    static let kServiceOrder = "order"
    static let kServiceFee = "fee"
    static let kServiceCancellationFee = "cancellationFee"

        ////Services->Mowing
        static let kServiceMinPrice = "minPrice"
        static let kServicePriceByPi2 = "priceByPi2"
        static let kServiceLimitUpArea = "limitUpArea"
        static let kServicePercentByGraassHeight = "percentByGrassHeight"


    //Request
    static let kRequestClassName = "Request"
    static let kRequestUrl = "url"
    static let kRequestFront = "front"
    static let kRequestService = "service"
    static let kRequestServiceId = "serviceId"
    static let kRequestAddress = "address"
    static let kRequestCenter = "center"
    static let kRequestMowing = "mowing"
    static let kRequestPriceCustomer = "priceCustomer"
    static let kRequestPriceWorker = "priceWorker"
    static let kRequestMowingHeightGrass = "mowingHeightGrass"
    static let kRequestState = "state"
    static let kRequestCustomer = "customer"
    static let kRequestVideo = "video"
    static let kRequestPhoto = "photo"
    static let kRequestVideoWelcome = "videoWelcome"
    static let kRequestPhotoWelcome = "photoWelcome"
    static let kRequestSurface = "surface"
    static let kRequestWorker = "worker"
    static let kRequestRefuseWorkerId = "refuseWorkerId"
    static let kRequestRefuseWorker = "refuseWorker"

    static let kRequestVideoStart = "videoStart"
    static let kRequestPhotoStart = "photoStart"
    static let kRequestTimeStart = "timeStart"

    static let kRequestVideoEnd = "videoEnd"
    static let kRequestPhotoEnd = "photoEnd"
    static let kRequestReviewFromCustomer = "reviewFromCustomer"
    static let kRequestReviewFromWorker = "reviewFromWorker"


    //Review
    static let kReviewClassName = "Review"
    static let kReviewRequest = "request"
    static let kReviewRequestId = "requestId"
    static let kReviewCustomer = "customer"
    static let kReviewCustomerId = "customerId"
    static let kReviewWorker = "worker"
    static let kReviewWorkerId = "workerId"
    static let kReviewRate = "rate"
    static let kReviewFrom = "from"
    static let kReviewReview = "review"
    static let kReviewAvailable = "available"

    
    //Config
    static let kConfigTerms = "terms"
    static let kConfigPrivacy = "terms"
    static let kConfigContactEmail = "contactEmail"
    static let kConfigIdApp = "appleId"
    static let kConfigShareText = "shareText"
    static let kConfigAppStoreUrl = "appStoreUrl"
    static let kConfigEmail = "email"
    static let kconfigInviteFriendsFr = "inviteFriendsFr"
    static let kconfigInviteFriendsEn = "inviteFriendsEn"
    static let kconfigStoriesDuration = "storiesDuration"
    static let kconfigDisabledRewards = "disabledRewards"
    static let kConfigMapboxUrl = "mapboxUrl"

    


}




class StripeCustomer {
    
    private static var stripeCustomer: StripeCustomer?
   
    var stripeAccount : [String:Any]?
    var stripeId : String?

    class func shared() -> StripeCustomer{
        
        if self.stripeCustomer == nil {
            
            self.stripeCustomer = StripeCustomer()
            
            
        }
        
        return self.stripeCustomer!
    }
    
    func refreshStripeAccount(completion: @escaping (_ stripeAccount: [String:Any]?) -> Void) {
        
        if PFUser.current()?.object(forKey: Brain.kUserStripeCustomer) != nil {
            
            let stripeCustomer =  PFUser.current()?.object(forKey: Brain.kUserStripeCustomer) as! PFObject
            
            stripeCustomer.fetchInBackground { (stripeFetched, error) in
                
                
                if stripeFetched != nil {
                    
                    
                    self.stripeId = stripeFetched!.object(forKey: Brain.kStripeCustomerIdStripe) as? String
                    
                    PFCloud.callFunction(inBackground: "RetreivePaymentMethodCustomerAccount", withParameters: ["customerId":self.stripeId!], block: { (object, error) in
                        
                        
                        if object != nil {
                            
                            self.stripeAccount = object! as? [String : Any]
                            completion(self.stripeAccount!)
                            
                        }else{
                            
                            
                            self.stripeAccount = nil
                            completion(nil)
                            
                        }
                        
                        
                    })
                }
               
                
                
            }
        }
    }
   

}



func originYBottomButtonCTA() -> CGFloat {
    
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



class SignupProcess
{
    
    private static var signup: SignupProcess?
    
    class func shared() -> SignupProcess
    {
        if self.signup == nil
        {
            self.signup = SignupProcess()
        }
        
        return self.signup!
    }
    
    var email: String?
    var firstname: String?
    var lastname: String?
    var password: String?
    var phone: String?
    var type:String?
    var profilePicture:PFFile?
    var businessStripeId:String?

    
    func updateIntercomData(){
        
        let userAttributes = ICMUserAttributes()
        
         if (((PFUser.current()?[Brain.kUserFirstName]) != nil)){
            
            userAttributes.name = (PFUser.current()?[Brain.kUserFirstName] as! String)

        }
        
        userAttributes.email = (PFUser.current()?[Brain.kUserEmail] as! String)

        let customDic = NSMutableDictionary()
        
        
        if PFUser.current()?[Brain.kUserFacebookId] != nil{
            
            customDic.setValue(PFUser.current()?[Brain.kUserFacebookId] , forKey: Brain.kUserFacebookId)
        }
        
       
            
        userAttributes.customAttributes = customDic as? [String : Any]
        
        Intercom.updateUser(userAttributes)

    }
   
    
    func nextProcess(navigationController:UINavigationController) {
        
        if ((PFUser.current()) != nil) {
            
            if PFUser.current()?.email == nil{
                
                let emailVC = SignupEmailViewController()
                navigationController.pushViewController(emailVC, animated: true)
                
                
            }else if PFUser.current()?[Brain.kUserPhone] == nil && Brain.kPhoneVerification == true && phone == nil {
                
          
                let phoneNumber = SignupPhone1ViewController()
                navigationController.pushViewController(phoneNumber, animated: true)
                
           
            }else if PFUser.current()?.object(forKey: Brain.kUserType)  == nil {
                
                let typeVC = SignupTypeWorkerViewController()
                navigationController.pushViewController(typeVC, animated: true)
                
            }else if PFUser.current()?.object(forKey: Brain.kUserType) as! String == "worker" && PFUser.current()?.object(forKey: Brain.kUserStripeCustomer) == nil && self.businessStripeId == nil {
                
                let typeVC = SignupAddressViewController(firstname: PFUser.current()?.object(forKey: Brain.kUserFirstName) as! String, lastname:  PFUser.current()?.object(forKey: Brain.kUserLastName) as! String , email:  PFUser.current()?.object(forKey: Brain.kUserEmail) as! String)
                navigationController.pushViewController(typeVC, animated: true)
                
            }else{
                
                
                if navigationController.viewControllers.last?.className == "SignupViewController" {
                    
                    let lastVc = navigationController.viewControllers.last as! SignupViewController
                    lastVc.loginButtonFacebook.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                    
                }else if navigationController.viewControllers.last?.className == "SignupPhone2ViewController" {

                    let lastVc = navigationController.viewControllers.last as! SignupPhone2ViewController
                    lastVc.nextButton.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                 }else if navigationController.viewControllers.last?.className == "SignupEmailViewController" {

                    let lastVc = navigationController.viewControllers.last as! SignupEmailViewController
                    lastVc.nextButton.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                
                }else if navigationController.viewControllers.last?.className == "SignupTypeWorkerViewController" {
                    
                    let lastVc = navigationController.viewControllers.last as! SignupTypeWorkerViewController
                    lastVc.nextButton.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                    
                }else if navigationController.viewControllers.last?.className == "SignupAddressViewController" {
                    
                    let lastVc = navigationController.viewControllers.last as! SignupAddressViewController
                    lastVc.nextButton.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                }

                
           
                if PFUser.current()?.email == nil && email != nil {
                    
                    
                    PFUser.current()?.email = email

                }
                
                
                
                
                
                if PFUser.current()?[Brain.kUserPhone] == nil && phone != nil {
                    

                    do {
                        let phoneNumberKit = PhoneNumberKit()
                        let phoneNumber =  try phoneNumberKit.parse(phone!)
                        PFUser.current()?[Brain.kUserPhone] = phoneNumberKit.format(phoneNumber, toType: .e164)
                    }
                    catch {
                        PFUser.current()?[Brain.kUserPhone] = phone
                    }
                    
                    
                }
                
                
                

                
                            
                
                PFUser.current()?.saveInBackground(block: { (success:Bool, error:Error?) in
                    
                   
                    
                   
                    
                    if let error = error {
                        
                        PFUser.logOut()

                        
                        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        
                       
                        
                        
                        if navigationController.viewControllers.last?.className == "SignupViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupViewController
                           
                            lastVc.loginButtonFacebook.loadingIndicator(false)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            if let popoverController = alert.popoverPresentationController {
                                popoverController.sourceView = lastVc.view
                                popoverController.permittedArrowDirections = []
                                popoverController.sourceRect = CGRect(x: lastVc.view.bounds.midX, y: lastVc.view.bounds.midY, width: 0, height: 0)
                            }
                            lastVc.present(alert, animated: true, completion: nil)
                            
                        }else if navigationController.viewControllers.last?.className == "SignupPhone2ViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupPhone2ViewController
                           
                            lastVc.nextButton.loadingIndicator(false)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            if let popoverController = alert.popoverPresentationController {
                                popoverController.sourceView = lastVc.view
                                popoverController.permittedArrowDirections = []
                                popoverController.sourceRect = CGRect(x: lastVc.view.bounds.midX, y: lastVc.view.bounds.midY, width: 0, height: 0)
                            }
                            lastVc.present(alert, animated: true, completion: nil)
                            
                        }else if navigationController.viewControllers.last?.className == "SignupEmailViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupEmailViewController
                            lastVc.nextButton.loadingIndicator(false)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            if let popoverController = alert.popoverPresentationController {
                                popoverController.sourceView = lastVc.view
                                popoverController.permittedArrowDirections = []
                                popoverController.sourceRect = CGRect(x: lastVc.view.bounds.midX, y: lastVc.view.bounds.midY, width: 0, height: 0)
                            }
                            lastVc.present(alert, animated: true, completion: nil)

                            
                        }else if navigationController.viewControllers.last?.className == "SignupAddressViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupAddressViewController
                            lastVc.nextButton.loadingIndicatorWhite(true)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                            
                        }
                        
                      
                        
                        
                    } else {
                       
                        
                        
                        self.updateInstallation()
                        self.updateIntercomData();
                        
                        
                        


                        
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.addLoadingView()

                            
                            let queryRole = PFRole.query()
                            queryRole?.whereKey("name", equalTo: "User")
                            queryRole?.getFirstObjectInBackground(block: { (object, error) in
                                
                                
                                let role = object as! PFRole
                                
                                role.users.add(PFUser.current()!)
                                role.saveInBackground(block: { (success, error1) in
                                    
                                    if (PFUser.current()?.object(forKey: Brain.kUserStripeCustomer)) == nil {
                                                              
                                                              
                                        PFCloud.callFunction(inBackground: "CreateStripeCustomerAccount", withParameters: ["email":PFUser.current()!.object(forKey: Brain.kUserEmail)!,"name":PFUser.current()?.object(forKey: Brain.kUserFirstName)!]) { (customer, error) in
                                          
                                          
                                          if (customer != nil) {
                                              
                                              let stripeCustomer = PFObject(className: Brain.kStripeCustomerClassName)
                                              
                                              let acl = PFACL()
                                              acl.setReadAccess(true, for: PFUser.current()!)
                                              acl.setWriteAccess(true, for: PFUser.current()!)
                                              
                                              stripeCustomer.acl = acl
                                              
                                            
                                            if self.businessStripeId != nil {
                                                
                                                stripeCustomer.setObject(self.businessStripeId!, forKey: Brain.kStripeWorkerIdStripe)

                                                PFCloud.callFunction(inBackground: "AddFirstSkillsToBusiness", withParameters: [
                                                                                            
                                                     "userId":PFUser.current()?.objectId!

                                                 ]) { (user, error) in
                                                    
                                                   

                                                 }
                                            }
                                            
                                              stripeCustomer.setObject((customer! as! Dictionary)["id"]!, forKey: Brain.kStripeCustomerIdStripe)
                                              stripeCustomer.setObject(PFUser.current()!, forKey: Brain.kStripeCustomerUser)
                                              stripeCustomer.saveInBackground(block: { (success, error) in
                                                  
                                                  
                                                  
                                                  PFUser.current()?.setObject(stripeCustomer, forKey: Brain.kUserStripeCustomer)
                                                  PFUser.current()?.saveInBackground(block: { (success, error3) in
                                                      
                                                      
                                                  })
                                                  
                                                  appDelegate.loginDone(animated: true)
                                                  
                                                  
                                              })
                                              
                                          }
                                          
                                      }
                                      
                                  }else{
                                      
                                     
                                      
                                      appDelegate.loginDone(animated: true)

                                     
                                      
                                      
                                  }
                                    
                                    

                                })
                                
                            })
                        
                        
                        
                        
                            
                        }
                        

            
                    

                    
                    
                    
                    
                })
                
            }
            
            
            
        }else{
            
            if email == nil{
                
                
            
//
                let emailVC = SignupEmailViewController()
                navigationController.pushViewController(emailVC, animated: true)
//                let emailVC = SignupDescriptionViewController()
//                navigationController.pushViewController(emailVC, animated: true)
//

            }else if firstname == nil{
                
                let firstNameVC = SignupFirstNameViewController()
                navigationController.pushViewController(firstNameVC, animated: true)

            }else if password == nil{
                
                let password = SignupPasswordViewController()
                navigationController.pushViewController(password, animated: true)

            }else if phone == nil && Brain.kPhoneVerification == true{
                
                let phoneNumber = SignupPhone1ViewController()
                navigationController.pushViewController(phoneNumber, animated: true)
                
            }else if type == nil{
                
                let typeVC = SignupTypeWorkerViewController()
                navigationController.pushViewController(typeVC, animated: true)

            }else if type == "worker" && self.businessStripeId == nil {
                
                let typeVC = SignupAddressViewController(firstname: firstname!, lastname:  lastname! , email:  email!)
                navigationController.pushViewController(typeVC, animated: true)

            }else{
                
                
                
                
                if navigationController.viewControllers.last?.className == "SignupViewController" {
                    
                    let lastVc = navigationController.viewControllers.last as! SignupViewController
                    lastVc.loginButtonFacebook.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                    
                }else if navigationController.viewControllers.last?.className == "SignupPhone2ViewController" {
                    
                    let lastVc = navigationController.viewControllers.last as! SignupPhone2ViewController
                    lastVc.nextButton.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                }else if navigationController.viewControllers.last?.className == "SignupEmailViewController" {
                    
                    let lastVc = navigationController.viewControllers.last as! SignupEmailViewController
                    lastVc.nextButton.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                    
                }else if navigationController.viewControllers.last?.className == "SignupTypeWorkerViewController" {
                    
                    let lastVc = navigationController.viewControllers.last as! SignupTypeWorkerViewController
                    lastVc.nextButton.loadingIndicatorWhite(true)
                    lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    
                    
                }

              
                
                let user = PFUser()

                
                if email != nil {
                    
                    user.username = email
                    user.email = email
                }
                
                
                user.setObject(0, forKey: Brain.kUserReviewsWorkerNumber)
                user.setObject(0, forKey: Brain.kUserReviewsCustomerNumber)
                user.setObject(5, forKey: Brain.kUserRateWorker)
                user.setObject(5, forKey: Brain.kUserRateCustomer)

                if password != nil {
                    
                    user.password = password
                }
                
                UserDefaults.standard.set(email, forKey: "username")
                UserDefaults.standard.set(password, forKey: "password")

                if firstname != nil {
                    
                    user[Brain.kUserFirstName] = firstname
                }
                
                if lastname != nil {
                    
                    user[Brain.kUserLastName] = lastname
                }
                
                
                user[Brain.kUserType] = type!

                                                                  
                if profilePicture != nil {
                    
                    user[Brain.kUserProfilePicture] = profilePicture!

                }
                
                if phone != nil {
                    
                    
                    do {
                        let phoneNumberKit = PhoneNumberKit()
                        let phoneNumber =  try phoneNumberKit.parse(phone!)
                        user[Brain.kUserPhone] = phoneNumberKit.format(phoneNumber, toType: .e164) // +61236618300
                    }
                    catch {
                        user[Brain.kUserPhone] = phone
                    }
                    
                    
                    
                }
             
               
                user.signUpInBackground(block: { (success:Bool, error:Error?) in
                    
                    if let error = error {
                        
                        PFUser.logOut()
                        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        
                        
                        if navigationController.viewControllers.last?.className == "SignupViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupViewController

                            if let popoverController = alert.popoverPresentationController {
                                popoverController.sourceView = lastVc.view
                                popoverController.permittedArrowDirections = []
                                popoverController.sourceRect = CGRect(x: lastVc.view.bounds.midX, y: lastVc.view.bounds.midY, width: 0, height: 0)
                            }
                            
                            lastVc.loginButtonFacebook.loadingIndicator(false)
                            lastVc.present(alert, animated: true, completion: nil)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

                        }else if navigationController.viewControllers.last?.className == "SignupPhone2ViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupPhone2ViewController

                            if let popoverController = alert.popoverPresentationController {
                                popoverController.sourceView = lastVc.view
                                popoverController.permittedArrowDirections = []
                                popoverController.sourceRect = CGRect(x: lastVc.view.bounds.midX, y: lastVc.view.bounds.midY, width: 0, height: 0)
                            }
                            
                            
                            lastVc.nextButton.loadingIndicator(false)
                            lastVc.present(alert, animated: true, completion: nil)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

                        }else if navigationController.viewControllers.last?.className == "SignupEmailViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupEmailViewController

                            if let popoverController = alert.popoverPresentationController {
                                popoverController.sourceView = lastVc.view
                                popoverController.permittedArrowDirections = []
                                popoverController.sourceRect = CGRect(x: lastVc.view.bounds.midX, y: lastVc.view.bounds.midY, width: 0, height: 0)
                            }
                            
                            
                            lastVc.nextButton.loadingIndicator(false)
                            lastVc.present(alert, animated: true, completion: nil)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

                            
                        }
                        
                       
                        
                    } else {
                        
                        
                        
                        
                        user.acl = PFACL(user: user)
                        user.acl?.setReadAccess(true, forRoleWithName: "User")
                        user.acl?.setReadAccess(true, forRoleWithName: "Administrator")
                        user.acl?.setReadAccess(true, forRoleWithName: "Bar")
                        user.saveInBackground()
                        
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.addLoadingView()

                       
                        if navigationController.viewControllers.last?.className == "SignupViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupViewController
                            lastVc.loginButtonFacebook.loadingIndicator(false)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

                        }else if navigationController.viewControllers.last?.className == "SignupPhone2ViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupPhone2ViewController
                            lastVc.nextButton.loadingIndicator(false)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

                        }else if navigationController.viewControllers.last?.className == "SignupEmailViewController" {
                            
                            let lastVc = navigationController.viewControllers.last as! SignupEmailViewController
                            lastVc.nextButton.loadingIndicator(false)
                            lastVc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

                            
                        }
                        
                        
                        self.updateInstallation();
                        self.updateIntercomData();

                        
                        PFCloud.callFunction(inBackground: "CreateStripeCustomerAccount", withParameters: ["email":PFUser.current()!.object(forKey: Brain.kUserEmail)!,"firstname":self.firstname!, "lastname":self.lastname!]) { (customer, error) in
                            
                            
                            if (customer != nil) {
                                
                           
                                let stripeCustomer = PFObject(className: Brain.kStripeCustomerClassName)
                                
                                let acl = PFACL()
                                acl.setReadAccess(true, for: PFUser.current()!)
                                acl.setWriteAccess(true, for: PFUser.current()!)
                                
                                stripeCustomer.acl = acl
                                
                                stripeCustomer.setObject((customer as! Dictionary)["id"]!, forKey: Brain.kStripeCustomerIdStripe)


                                if self.businessStripeId != nil {
                                                                                                                 
                                    stripeCustomer.setObject(self.businessStripeId!, forKey: Brain.kStripeWorkerIdStripe)
                                    
                                    PFCloud.callFunction(inBackground: "AddFirstSkillsToBusiness", withParameters: [
                                              
                                                   "userId":PFUser.current()?.objectId!

                                               ]) { (user, error) in
                                                  
                                                 

                                               }

                                }
                                                                   
                                stripeCustomer.setObject(PFUser.current()!, forKey: Brain.kStripeCustomerUser)
                                stripeCustomer.saveInBackground(block: { (success, error) in
                                    
                               
                                   
                                    PFUser.current()?.setObject(stripeCustomer, forKey: Brain.kUserStripeCustomer)
                                    PFUser.current()?.saveInBackground(block: { (success, error3) in
                                        
                                        
                                    })
                                    
                                    
                                                           
                                   let queryRole = PFRole.query()
                                   queryRole?.whereKey("name", equalTo: "User")
                                   queryRole?.getFirstObjectInBackground(block: { (object, error) in
                                       
                                       
                                       let role = object as! PFRole
                                       
                                       role.users.add(PFUser.current()!)
                                       role.saveInBackground(block: { (success, error1) in
                                           
                                           appDelegate.loginDone(animated: true)

                                           
                                       })
                                       
                                   })
                                   
                                    

                                    
                                })
                                
                            }
                            
                        }

                        
                        

                       
                    }
               
                })
                
            }
        }
        
    }
    
  
    
    func updateInstallation() {
        
        
        if(PFUser.current() != nil){
            
            let installation = PFInstallation.current()
            let user = PFUser.current()!

            if ((user.object(forKey: Brain.kUserFirstName)) != nil){
                
                installation?.setObject(user.object(forKey: Brain.kUserFirstName)!, forKey: Brain.kUserFirstName)
            }
           
            
            installation?.setObject(PFUser.current()!, forKey: "user")
            installation?.setObject(Locale.preferredLanguages[0], forKey: "language")
            installation?.addUniqueObject("Global", forKey: "channels")
            installation?.saveInBackground()

        }

    }
    
    
   
    
   
}

func heightView(heightView:UIView) ->(CGFloat){
    
    if Device.IS_IPHONE_X {
        
        return heightView.frame.size.height - 30

    }else{
        
        return heightView.frame.size.height
    }
}

func originY() ->(CGFloat){
    
    if Device.IS_IPHONE_X {
        
        return 20
        
    }else{
        
        return 0
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
        
        let attributesTitle = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: titleFontSize)]
        let attributesMessage = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: messageFontSize)]
        let attributedTitleText = NSAttributedString(string: self.title ?? "", attributes: attributesTitle)
        let attributedMessageText = NSAttributedString(string: self.message ?? "", attributes: attributesMessage)
        
        self.setValue(attributedTitleText, forKey: "attributedTitle")
        self.setValue(attributedMessageText, forKey: "attributedMessage")
        
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

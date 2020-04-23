//
//  Brain.swift
//  GoRush
//
//  Created by Julien Levallois on 19-08-23.
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

    static let kInstallationNotifications = "notifications"

    static let kDevise                =    "cad"
    static let kCountry                =    "CA"

    static let kFacebookPermissions = ["public_profile","email"]
    static let kFacebookData = "id, name, first_name, last_name, email,picture.type(large)"

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


    //Parse Classes
    static let kName = "name"
    static let kNameFr = "nameFr"


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
    static let kUserPlatform = "platform"
    static let kUserDebug = "debug"



    //StripeCustomer
    static let kStripeCustomerClassName = "StripeCustomer"
    static let kStripeCustomerIdStripe = "idStripe"
    static let kStripeWorkerIdStripe = "workerIdStripe"
    static let kStripeCustomerUser = "user"


    //User->Mowing
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
    static let kServicesNameFr = "nameFr"
    static let kServiceIcon = "icon"
    static let kServiceComingSoon = "comingSoon"
    static let kServicePrivate = "private"
    static let kServiceMinVersionIOS = "minVersionIOS"
    static let kServiceAvailable = "available"
    static let kServiceCover = "cover"
    static let kServiceOrder = "order"
    static let kServiceFee = "fee"
    static let kServiceCode = "code"
    static let kServiceMaximumTimeInHours = "maximumTimeInHours"
    static let kServiceCancellationFee = "cancellationFee"
    static let kServiceBoost = "boost"
    static let kServiceTaxes = "taxes"

    //Services->Mowing
    static let kServiceFixedPrice = "fixedPrice"
    static let kServiceVariablePrice = "variablePrice"
    static let kServicePercentFactor = "percentFactor"

    //Boost
    static let kBoostFixedPrice = "fixedPrice"
    static let kBoostVariablePrice = "variablePrice"
    static let kBoostName = "name"
    static let kBoostNameFr = "nameFr"
    static let kBoostPrice = "price"


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
    static let kRequestSurface = "surface"
    static let kRequestWorker = "worker"
    static let kRequestRefuseWorkerId = "refuseWorkerId"
    static let kRequestRefuseWorker = "refuseWorker"
    static let kRequestPhotos = "photos"
    static let kRequestBoost = "boost"

    static let kRequestVideoStart = "videoStart"
    static let kRequestPhotoStart = "photoStart"
    static let kRequestTimeStart = "timeStart"
    static let kRequestTimeLimit = "timeLimit"
    static let kRequestTimeEnd = "timeEnd"

    static let kRequestVideoEnd = "videoEnd"
    static let kRequestPhotoEnd = "photoEnd"
    static let kRequestReviewFromCustomer = "reviewFromCustomer"
    static let kRequestReviewFromWorker = "reviewFromWorker"

    static let kRequestDebug = "debug"

    
    
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
    static let kConfigStripe = "stripeKey"
    static let kConfigGoogleMap = "GoogleMapsApiKey"
    static let kConfigIntecomApiKey = "intercomApiKey"
    static let kConfigIntercomAppId = "intercomAppId"
    static let kConfigHideFacebookLogin = "hideFacebookLogin"
    static let kConfigHideFacebookLoginVersion = "version"
    static let kConfigHideFacebookLoginHide = "hide"

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

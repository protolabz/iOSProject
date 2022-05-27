//
//  Constant.swift
//  Xeat
//
//  Created by apple on 16/12/21.
//

import Foundation

struct Constant {
    //https://medium.com/@ankitbansal806/save-and-get-image-from-document-directory-in-swift-5c1280ec17f5
//static let baseURL = "https://phpstack-102119-1800306.cloudwaysapps.com/api/"
//static let baseURL = "https://phpstack-102119-2292222.cloudwaysapps.com/"
static let baseURL = "https://xeat.co.uk/backend/"
    
    static let APITOKEN = "VIBadfsgsdgadfssadf231312323cxfsdf342q43qdswd"
    static let loginAPI = "API/users.php/login"
    static let logoutApi = "API/users.php/logout"
    static let signupAPI = "API/users.php/signup"
    static let forgotPasswordOTP = "API/users.php/otp_send_forgot"
    static let forgotPasswordAPI = "API/users.php/forgot_password"
    static let chnagePasswordAPI = "API/users.php/update_password"
    static let otpSendApi = "API/users.php/otp_send"
    static let topCategoryAPI  = "API/users.php/top_category"
    static let nearByRestarantAPI  = "API/users.php/near_restor"
    static let restaurantDeatil = "API/users.php/Get_restaurant"
    static let restaurantDistanceAPI = "api/checkRestaurant_distance"
    static let menuListAPI = "API/users.php/menu_item"
    static let categoryAPI = "api/rest_category"
    static let profileUpdateApi = "API/users.php/update_profile"
    static let getAddressListApi = "API/users.php/get_address"
    static let addAddressAPI = "API/users.php/add_addres"
    static let savePrimaryAddressAPI = "api/add_primary_address"
    static let getPrimaryAddressAPI = "api/primary_address"
    static let editAddressAPI = "API/users.php/update_addres"
    static let chargeAPI = "api/charge_payment"
    static let cuisineList = "api/cuisine_details"
    static let cuisine_restdetail = "api/cuisine_restdetail"
    static let categoryMenuListAPI = "api/category_menu_list"
    
    
    static let groceryFoodImageAPI = "api/grocery_images"
    
    static let deleteAddressAPI = "API/users.php/delete_addres"
    static let orderHistoryApi = "api/order_history_detail"
    static let addHelpRequestApi = "API/users.php/user_help"
    static let helpRevertApi = "API/users.php/user_help_revert"
    static let helpIssueListAPI = "API/users.php/help_issue"
    static let helpSubmitAPI = "API/users.php/order_help"
   
    static let transactionAPI = "api/user_wallet"
    static let walletAPI = "api/user_total_penny"
    static let orderHelpChatListAPI = "API/users.php/get_order_help"
    static let orderChatMessageListAPI = "API/users.php/get_order_help_chat"
    static let orderChatAPI = "API/users.php/order_help_chat"
    static let uploadImageAPI = "API/users.php/upload_image"
    static let addonListAPI = "api/rest_subitems_list"
    static let addDeleteItemToCartAPI = "api/add_to_cart"
    static let addOnExtraAPI = "api/search_menuitems_categroy"
//    static let addDeleteItemToCartAPI = "api/test_addto_cart"
    static let cartDetailAPI = "api/cart_detail"
    static let removeCartDataAPI = "api/delete_cart"
    static let setPrimaryAddressAPI = "api/add_primary_address"
    static let couponListAPI = "API/users.php/getAllCoupons"
    static let updateAddToCartAPI = "api/update_add_to_cart"
    static let placeOrderAPI = "api/order_placed"
    static let ongoingOrderAPI = "API/users.php/ongoing_order"
    static let ongoingOrderDetailAPI = "api/order_detail"
    static let orderCurrentStatusAPI = "API/users.php/get_status_order"
    static let orderPickUpAPI = "API/users.php/order_picked"
    static let driverDetailAPI = "API/users.php/get_driver_detailes"
    static let cancelOrderAPI = "API/users.php/cancel_Order"
    static let cancelRatingAPI = "API/users.php/cancel_reting"
    static let orderRatingDetail = "API/users.php/get_rating"
    static let doRatingAPI = "API/users.php/do_rating"
    static let searchMenuAPI = "api/search_menulist"
    static let createCardAPI = "api/create_card"
    static let cardListingAPI = "api/listof_cards"
    static let cardPayment = "api/card_payment"
    static let promotionList = "api/promotion_listcoupon"

    static let searchAPI = "API/users.php/search"
    static let topCategoryItemAPI = "API/users.php/top_cat_res"

    static let IS_LOGGEDIN = "0"
    
    static let EMAIL = "email"
    static let NAME = "name"
    static let CONTACT_NO = "CONTACT_NO"
    static let AADHAR = "AADHAR"
    static let PROFILE_PICTURE = "profile_picture"
    static let USER_UNIQUE_ID = "-1212"
    static let API_TOKEN = "api_token"
    static let deviceToken = "token"
    static let USERLATITUDE = "USERLATITUDE"
    static let USERLONGITUDE = "USERLONGITUDE"
    static let USERADDRESS = "USERADDRESS"
    static let USERADDRESSID = "USERADDRESSID"
    static let RUN_ORDERSTATUS = "run_orderstatusAPI"
    static let ONGOING_ORDERAPIHIT = "ONGOING_ORDERAPIHIT"
    static let LOCATIONSCREEN = "locationscreen"

}

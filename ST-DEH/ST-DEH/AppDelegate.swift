import UIKit
import CoreLocation

var locationManager = CLLocationManager()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var mainVC: ViewController?

    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {


      //開啟定位
        loadLocation()

     return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds) //initial
        mainVC = ViewController()
        window?.rootViewController = mainVC!
        //viewController.view.backgroundColor = UIColor.grayColor()
        
        window!.makeKeyAndVisible() // ! => unpacketed, makekeyandvisible => show the image
        
        //window!.backgroundColor = UIColor.gray//Color()//  change background color
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}


extension AppDelegate: CLLocationManagerDelegate
{
    
//開啟定位
func loadLocation()
{

    ST_DEH.locationManager.delegate = self
    //定位方式
    ST_DEH.locationManager.desiredAccuracy = kCLLocationAccuracyBest

     //iOS8.0以上才可以使用
    if(UIDevice.current.systemVersion >= "8.0"){
        //始終允許訪問位置資訊
        ST_DEH.locationManager.requestAlwaysAuthorization()
        //使用應用程式期間允許訪問位置資料
        ST_DEH.locationManager.requestWhenInUseAuthorization()
    }
    //開啟定位
    ST_DEH.locationManager.startUpdatingLocation()
}



//獲取定位資訊
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    //取得locations陣列的最後一個
    let location:CLLocation = locations[locations.count-1]
    //currLocation = locations.last!
    //判斷是否為空
    if(location.horizontalAccuracy > 0){
        let lat = Double(String(format: "%.1f", location.coordinate.latitude))
        let long = Double(String(format: "%.1f", location.coordinate.longitude))
        print("緯度:\(long!)")
        print("經度:\(lat!)")
        //LonLatToCity()
        //停止定位
        ST_DEH.locationManager.stopUpdatingLocation()
    }

}

//出現錯誤
    private func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
    print(error as Any)
}
/*
///將經緯度轉換為城市名
func LonLatToCity() {
    let geocoder: CLGeocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in

        if(error == nil)
        {
            let array = placemark! as NSArray
            let mark = array.firstObject as! CLPlacemark
            //城市
            var city: String = (mark.addressDictionary! as NSDictionary).valueForKey("City") as! String
            //國家
            let country: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("Country") as! NSString
            //國家編碼
            let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("CountryCode") as! NSString
            //街道位置
            let FormattedAddressLines: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("FormattedAddressLines")?.firstObject as! NSString
            //具體位置
            let Name: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("Name") as! NSString
            //省
            var State: String = (mark.addressDictionary! as NSDictionary).valueForKey("State") as! String
            //區
            let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("SubLocality") as! NSString


            //如果需要去掉“市”和“省”字眼

            State = State.stringByReplacingOccurrencesOfString("省", withString: "")
            let citynameStr = city.stringByReplacingOccurrencesOfString("市", withString: "")




        }
        else
        {
            print(error)
        }
    }


}*/

}

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var photo_location: [Double] = [0.0, 0.0, 0.0]
    var photo_date: String = ""
    var photo_orient: Double = 0.0
    var positionValue:String = ""
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
                //TODO:Set up the location manager here.
                locationManager.delegate = self  //宣告自己 (current VC)為 locationManager 的代理
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //定位所在地的精確程度(一般來說，精準程度越高，定位時間越長，所耗費的電力也因此更多)
                //to ask the user for location
                locationManager.requestWhenInUseAuthorization()  //for not destroying the user's battery
                locationManager.startUpdatingLocation() //this method will start navigating the location. And once this is done, it will send a msg to this ViewController
                locationManager.startUpdatingHeading()
        
        self.view.backgroundColor = UIColor.white
        
        // 生成圖片顯示框
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(x: self.view.frame.size.width / 4 / 2, y: 64, width: self.view.frame.size.width / 4 * 3, height: self.view.frame.size.height / 4 * 2)
        self.imageView.image = UIImage(named: "profile")
        
        // 生成相機按鈕
        let cameraBtn: UIButton = UIButton()
        cameraBtn.frame = CGRect(x: self.view.frame.size.width / 4 / 2, y: 30 + self.imageView.frame.origin.y + self.imageView.frame.size.height, width: self.view.frame.size.width / 4 * 3, height: 50)
        cameraBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        cameraBtn.setTitle("相機", for: .normal)
        cameraBtn.setTitleColor(UIColor.white, for: .normal)
        cameraBtn.layer.cornerRadius = 10
        cameraBtn.backgroundColor = UIColor.darkGray
        cameraBtn.addTarget(self, action: #selector(ViewController.onCameraBtnAction(_:)), for: UIControl.Event.touchUpInside)
        
        // 生成相簿按鈕
        let photoBtn: UIButton = UIButton()
        photoBtn.frame = CGRect(x: self.view.frame.size.width / 4 / 2, y: 30 + cameraBtn.frame.origin.y + cameraBtn.frame.size.height, width: self.view.frame.size.width / 4 * 3, height: 50)
        photoBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        photoBtn.setTitle("相簿", for: .normal)
        photoBtn.setTitleColor(UIColor.white, for: .normal)
        photoBtn.layer.cornerRadius = 10
        photoBtn.backgroundColor = UIColor.darkGray
        photoBtn.addTarget(self, action: #selector(ViewController.onPhotoBtnAction(_:)), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.imageView)
        self.view.addSubview(cameraBtn)
        self.view.addSubview(photoBtn)
    }

    
    /// 開啟相機或相簿
    ///
    /// - Parameter kind: 1=相機,2=相簿
    func callGetPhoneWithKind(_ kind: Int) {
        let picker: UIImagePickerController = UIImagePickerController()
        switch kind {
        case 1:
            // 開啟相機
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.allowsEditing = true // 可對照片作編輯
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("沒有相機鏡頭...") // 用alertView.show
            }
        default:
            // 開啟相簿
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                picker.allowsEditing = true // 可對照片作編輯
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
        
    // MARK: - CallBack & listener
    // ---------------------------------------------------------------------
    // 相機
    @objc func onCameraBtnAction(_ sender: UIButton) {
        self.callGetPhoneWithKind(1)
    }
    
    // 相簿
    @objc func onPhotoBtnAction(_ sender: UIButton) {
        self.callGetPhoneWithKind(2)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            print("latitude: \(photo_location[0])\n", "longtitude: \(photo_location[1])\n", "altitude: \(photo_location[2])\n", "date: \(photo_date)\n", "orientation: \(positionValue) \(photo_orient)\n")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Delegate
    // ---------------------------------------------------------------------
    /// 取得選取後的照片
    ///
    /// - Parameters:
    ///   - picker: pivker
    ///   - info: info
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil) // 關掉
        self.imageView.image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage // 從Dictionary取出原始圖檔
    }
    
    // 圖片picker控制器任務結束回呼
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //由於我們的 "startUpdatingLocation()" 會回傳一個陣列的 CLLocation ，而最後回傳的會是最接近於我們當前位置的 CLLocation 。 因此我們要娶的就是這個 CLLocation
        let location = locations[locations.count - 1]  //the method "startUpdatingLocation()" is gonna grab a set of locations that are getting more & more accurate. So we'd want the last location in this array
        //簡單檢查一下取得的值
         if location.horizontalAccuracy > 0 {  //this line will check if the location is available
         // 由於定位功能十分耗電，我們既然已經取得了位置，就該速速把它關掉
           //locationManager.stopUpdatingLocation()
            photo_location[0]=location.coordinate.latitude
            photo_location[1]=location.coordinate.longitude
            photo_location[2]=location.altitude
            photo_date=location.timestamp.description
            //print("latitude: \(location.coordinate.latitude), longtitude: \(location.coordinate.longitude)")
            }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading orientation: CLHeading ) {
        
        photo_orient = orientation.magneticHeading
        
        if(photo_orient >= 0 && photo_orient < 90){
            positionValue = "北"
        }else if(photo_orient >= 90 && photo_orient < 180){
            positionValue = "東"
        }else if(photo_orient >= 180 && photo_orient < 270){
            positionValue = "南"
        }else if(photo_orient >= 270 && photo_orient < 360){
            positionValue = "西"
        }
    }
}

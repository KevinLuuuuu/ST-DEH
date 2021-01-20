import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON
//#import "DEH-Bridging-Header.h";

public var label_labels: Array<String> = []
public var label_bool: Array<Bool> = []
public var landmark_labels: Array<String> = []
public var landmark_bool: Array<Bool> = []


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    /*var ftpupload = FTPUpload(baseUrl: "140.116.82.135", userName: "MMLAB", password: "2080362", directoryPath: "C:/User/mmlab/DEH_Photo")*/
    @IBOutlet weak var Choose_Label: UIButton!
    let locationManager = CLLocationManager()
    var photo_location: [Double] = [0.0, 0.0, 0.0]
    var photo_date: String = ""
    var photo_orient: Double = 0.0
    var positionValue:String = ""
    var photo_location_temp: [Double] = [0.0, 0.0, 0.0]
    var photo_date_temp: String = ""
    var photo_orient_temp: Double = 0.0
    var positionValue_temp:String = ""
    
    var Category = ["ALL", "古蹟", "歷史建築", "紀念建築", "考古遺址", "史蹟", "文化景觀", "自然景觀", "傳統表演藝術", "傳統工藝", "口述傳統", "民俗", "民俗及有關文物", "傳統知識與實踐", "一般景觀含建築：人工地景與自然地景", "植物", "動物", "生物", "食衣住行育樂", "其他"]
    var Priority = ["⭐️", "⭐️⭐️", "⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️⭐️"]
    var star_count = -1
    
    var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let session = URLSession.shared
    

    
    var googleAPIKey = "AIzaSyAfumZAske4fWObPXEUW-eg04FFBmsq1qA"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    @IBOutlet weak var title_text: UITextField!
    @IBOutlet weak var keyword_text: UITextField!
    @IBOutlet weak var description_text: UITextField!
    @IBOutlet weak var reference_text: UITextField!
    @IBOutlet weak var reason_text: UITextField!
    @IBOutlet weak var companion_text: UITextField!
    @IBOutlet weak var Cate_text: UITextField!
    @IBOutlet weak var priority_text: UITextField!
    var picker = UIPickerView()
    var picker_p = UIPickerView()
    override func viewDidLoad() {
           
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        picker_p.dataSource = self
        picker_p.delegate = self
        picker.tag = 1
        picker_p.tag = 2
        
        Cate_text?.inputView = picker
        priority_text?.inputView = picker_p
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
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
        cameraBtn.frame = CGRect(x: self.view.frame.size.width / 8, y:self.imageView.frame.origin.y + self.imageView.frame.size.height + 150, width: 100, height: 100)
        cameraBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        //cameraBtn.setTitle("相機", for: .normal)
        cameraBtn.setImage(UIImage(named: "camera.jpg"), for: .normal)
        cameraBtn.setTitleColor(UIColor.white, for: .normal)
        cameraBtn.layer.cornerRadius = 10
        cameraBtn.backgroundColor = UIColor.darkGray
        cameraBtn.addTarget(self, action: #selector(ViewController.onCameraBtnAction(_:)), for: UIControl.Event.touchUpInside)
        
        // 生成相簿按鈕
        let photoBtn: UIButton = UIButton()
        photoBtn.frame = CGRect(x: self.view.frame.size.width / 8 * 7 - 100, y: 150 + self.imageView.frame.origin.y + self.imageView.frame.size.height, width: 100, height: 100)
        photoBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        //photoBtn.setTitle("相簿", for: .normal)
        photoBtn.setImage(UIImage(named: "album.png"), for: .normal)
        photoBtn.setTitleColor(UIColor.white, for: .normal)
        photoBtn.layer.cornerRadius = 10
        photoBtn.backgroundColor = UIColor.darkGray
        photoBtn.addTarget(self, action: #selector(ViewController.onPhotoBtnAction(_:)), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.imageView)
        self.view.addSubview(cameraBtn)
        self.view.addSubview(photoBtn)
    }
    
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longtitude: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var orientation: UILabel!
    
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
        
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
            // Use SwiftyJSON to parse results
        do{
            let json = try JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
            /*self.spinner.stopAnimating()
            self.imageView.isHidden = true
            self.labelResults.isHidden = false*/
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                print(json)
                let responses: JSON = json["responses"][0]
                
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = "Labels found: "
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                        label_labels.append(label)
                        label_bool.append(false)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                    print(labelResultsText)
                } else {
                    print("No labels found")
                }
                
                let landmarkAnnotations: JSON = responses["landmarkAnnotations"]
                let numLandmarks: Int = landmarkAnnotations.count
                labels = []
                if numLandmarks > 0 {
                    var landmarkResultsText:String = "Landmarks found: "
                    for index in 0..<numLandmarks {
                        let label = landmarkAnnotations[index]["description"].stringValue
                        labels.append(label)
                        landmark_labels.append(label)
                        landmark_bool.append(false)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            landmarkResultsText += "\(label), "
                        } else {
                            landmarkResultsText += "\(label)"
                        }
                    }
                    print(landmarkResultsText)
                } else {
                    print("No Landmarks found")
                }
            }
        }
        catch {
            print("error")
        }
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        
        // Run the request on a background thread
        //DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
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
            
            photo_location_temp[0] = photo_location[0]
            photo_location_temp[1] = photo_location[1]
            photo_location_temp[2] = photo_location[2]
            photo_date_temp = photo_date
            photo_orient_temp = photo_orient
            positionValue_temp = positionValue
            
            
            print("latitude: \(photo_location[0])\n", "longtitude: \(photo_location[1])\n", "altitude: \(photo_location[2])\n", "date: \(photo_date)\n", "orientation: \(positionValue) \(photo_orient)\n")
            

                latitude.textColor = UIColor.red
                latitude.text = "latitude: \(photo_location_temp[0])"
                longtitude.textColor = UIColor.red
                longtitude.text = "longtitude: \(photo_location_temp[1])"
                altitude.textColor = UIColor.red
                altitude.text = "altitude: \(photo_location_temp[2])"
                date.textColor = UIColor.red
                date.text = "date: \(photo_date_temp)"
                orientation.textColor = UIColor.red
                orientation.text = "orientation: \(positionValue_temp) \(photo_orient_temp)"
            
            AF.upload(multipartFormData: { (data) in
                  data.append(image.jpegData(compressionQuality: 1)!, withName: "image_file", fileName: "photo.jpg", mimeType: "image/jpeg")
                        
            },to: "http://140.116.82.135:8000/photo_server/")
            .response{resp in print(resp)}
            
            let imageBase64 = base64EncodeImage(image)
            
            var request = URLRequest(url: googleURL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
            
            // Build our API request
            let jsonRequest = [
                "requests": [
                    "image": [
                        "content": imageBase64
                    ],
                    "features": [
                        [
                            "type": "LABEL_DETECTION",
                            "maxResults": 31
                        ],
                        [
                            "type": "LANDMARK_DETECTION",
                            "maxResults": 6
                        ]
                    ]
                ]
            ]
            let jsonObject = JSON(jsonRequest)
            
            // Serialize the JSON
            guard let data = try? jsonObject.rawData() else {
                return
            }
            
            request.httpBody = data
            
            let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                self.analyzeResults(data)
            }
            
            task.resume()
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func done(_ sender: Any) {
        var vision_json: [String : Any] = [:]
        for i in 0...30{
            vision_json["label" + String(i)] = "NULL"
        }
        for i in 0...5{
            vision_json["landmark" + String(i)] = "NULL"
        }
        if(label_labels.count != 0) {
            for i in 0...label_labels.count - 1 {
                if(label_bool[i]) {
                    vision_json["label" + String(i)] = label_labels[i]
                }
            }
        }
        if(landmark_labels.count != 0) {
            for i in 0...landmark_labels.count - 1 {
                if(landmark_bool[i]) {
                    vision_json["landmark" + String(i)] = landmark_labels[i]
                }
            }
        }
        
        var ti = (title_text.text == "") ? "NULL" : title_text.text
        var cat = (Cate_text.text == "") ? "NULL" : Cate_text.text
        var k = (keyword_text.text == "") ? "NULL" : keyword_text.text
        var d = (description_text.text == "") ? "NULL" : description_text.text
        var ref = (reference_text.text == "") ? "NULL" : reference_text.text
        var rea = (reason_text.text == "") ? "NULL" : reason_text.text
        var c = (companion_text.text == "") ? "NULL" : companion_text.text
        var p = (priority_text.text == "") ? 1 : star_count + 1
        
        
        var send_json: [String : Any] =
                    ["title" : ti,
                     "date" : photo_date_temp,
                     "latitude" : photo_location_temp[0],
                     "longitude" : photo_location_temp[1],
                     "altitude" : photo_location_temp[2],
                     "orientation" : positionValue_temp,
                     "azimuth" : photo_orient_temp,
                     "weather" : "sunny",   //un
                     "speed" : "0",         //un
                     "address" : "0",        //un
                     "era" : "0",            //un
                     "category" : cat,
                     "keyword" : k,
                     "description" : d,
                     "reference" : ref,
                     "reason" : rea,
                     "companion" : c,
                     "priority" : p,
                     "contributor" : "0",
                     "url" : "0",
                     "vision_api" : vision_json
                    ]
        AF.request("http://192.168.32.15:6868", method: .post, parameters: send_json, encoding: JSONEncoding.default, headers: nil).responseString{
            response in
            switch response.result{
            case .success:
                print(response)
                break
            case .failure(let error):
                print(Error.self)
            }
        }
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
        
        if(photo_orient >= 348.75 && photo_orient < 11.25){
            positionValue = "北"
        }else if(photo_orient >= 11.25 && photo_orient < 33.75){
            positionValue = "北北東"
        }else if(photo_orient >= 33.75 && photo_orient < 56.25){
            positionValue = "東北"
        }else if(photo_orient >= 56.25 && photo_orient < 78.75){
            positionValue = "東北東"
        }else if(photo_orient >= 78.75 && photo_orient < 101.25){
            positionValue = "東"
        }else if(photo_orient >= 101.25 && photo_orient < 123.75){
            positionValue = "東南東"
        }else if(photo_orient >= 123.75 && photo_orient < 146.25){
            positionValue = "東南"
        }else if(photo_orient >= 146.25 && photo_orient < 168.75){
            positionValue = "南南東"
        }else if(photo_orient >= 168.75 && photo_orient < 191.25){
            positionValue = "南"
        }else if(photo_orient >= 191.25 && photo_orient < 213.75){
            positionValue = "南南西"
        }else if(photo_orient >= 213.75 && photo_orient < 236.25){
            positionValue = "西南"
        }else if(photo_orient >= 236.25 && photo_orient < 258.75){
            positionValue = "西南西"
        }else if(photo_orient >= 258.75 && photo_orient < 281.25){
            positionValue = "西"
        }else if(photo_orient >= 281.25 && photo_orient < 303.75){
            positionValue = "西北西"
        }else if(photo_orient >= 303.75 && photo_orient < 326.25){
            positionValue = "西北"
        }else if(photo_orient >= 326.25 && photo_orient < 348.75){
            positionValue = "北北西"
        }
    }
}

extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return Category.count
        }
        else{
            return Priority.count
        }
    }
}

extension ViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            return Category[row]
        }
        else{
            return Priority[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            Cate_text.text = Category[row]
        }
        else{
            priority_text.text = Priority[row]
            star_count = row
        }
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs! < lhs!
    }
}

//
//  PharmacyDetailsVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 01/10/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

extension PharmacyDetailsVC {
    static func instantiate() -> PharmacyDetailsVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: PharmacyDetailsVC.self)) as! PharmacyDetailsVC
    }
}

class PharmacyDetailsVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var uiViewPharmacyLogoBorder: UIView!
    @IBOutlet weak var uiViewLogoImageContainer: UIView!
    @IBOutlet weak var imageViewPharmacyLogo: UIImageView!
    
    @IBOutlet weak var textfieldPharmacyName: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldLatitude: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldLongitude: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldCountry: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldState: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldCity: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldPincode: SkyFloatingLabelTextField!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    @IBOutlet weak var stackViewDeliveryQue: UIStackView!
    @IBOutlet var btnDeliveryYesNo: [UIButton]!
    @IBOutlet weak var textfieldRangeOfDelivery: SkyFloatingLabelTextField!
    
    @IBOutlet weak var textfieldMinimumDiscount: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldMaximumDiscount: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldTermsAndCondition: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldShopOpenTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldShopCloseTime: SkyFloatingLabelTextField!
    
    @IBOutlet var btnTakingRegularLunchYesNo: [UIButton]!
    @IBOutlet weak var stackViewTakingRegularLunch: UIStackView!
    @IBOutlet weak var textfieldTakingRegularLunchOpenTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldTakingRegularLunchCloseTime: SkyFloatingLabelTextField!
    
    @IBOutlet var btnOpenOnSundayYesNo: [UIButton]!
    @IBOutlet weak var stackViewSundayOpenCloseTimeOption: UIStackView!
    @IBOutlet var btnSundayTimingOption: [UIButton]!
    @IBOutlet weak var stackViewSundayTiming: UIStackView!
    @IBOutlet weak var stackSundaySpecificTimings: UIStackView!
    @IBOutlet weak var textfieldSundayShopOpenTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldSundayShopClosingTime: SkyFloatingLabelTextField!
    
    @IBOutlet var btnSundayLunchYesNo: [UIButton]!
    @IBOutlet weak var stackViewSundayLunchTiming: UIStackView!
    @IBOutlet weak var textfieldSundayLunchOpenTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldSundayLunchCloseTime: SkyFloatingLabelTextField!
    
    var loginResponse: LoginDataApiResponse?
    
    let locationManager = CLLocationManager()
    
    var logoData: MediaData?
    var countryData: [CountryListDataApiResponse] = []
    var stateData: [StateListDataApiResponse] = []
    var cityData: [CityListDataApiResponse] = []
    var pincodeData: [PincodeListDataApiResponse] = []
    
    var selectedCountryId: Int = 0
    var selectedStateId: Int = 0
    var selectedCityId: Int = 0
    var selectedPincodeId: Int = 0
    
    let countryDropDown = DropDown()
    let stateDropDown = DropDown()
    let cityDropDown = DropDown()
    let pincodeDropDown = DropDown()
    
    var selectedProvideInternalDelivery = 0
    var selectedTakingRegularLunch = 1
    var selectedOpenOnSunday = 1
    var selectedSundayTimingOption = 0
    var selectedSundayLunchTime = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    private func setUpView() {
        uiViewToolBar.labelTitle.text = "Pharmacy Details"
        uiViewToolBar.btnSearch.isHidden = true
        
        uiViewPharmacyLogoBorder.addLineDashedStroke(
            pattern: [2,2],
            radius: 8,
            color: .appColor.fontColor
        )
        
        setUpMap()
        setUpDelegates()
        setupDropDown()
        getCountryList()
    }
    
    private func setupDropDown() {
        
        countryDropDown.anchorView = textfieldCountry
        countryDropDown.backgroundColor = .white
        countryDropDown.cornerRadius = 4
        
        countryDropDown.bottomOffset = CGPoint(
            x: 0,
            y: countryDropDown.anchorView!.plainView.bounds.height
        )
        
        countryDropDown.topOffset = CGPoint(
            x: 0,
            y: -countryDropDown.anchorView!.plainView.bounds.height
        )
        
        countryDropDown.selectionAction = { [self] (index, title) in
            textfieldCountry.text = title
            selectedCountryId = countryData[index].id!
            
            selectedStateId = 0
            selectedCityId = 0
            selectedPincodeId = 0
            
            textfieldState.text = nil
            textfieldCity.text = nil
            textfieldPincode.text = nil
            
            stateData.removeAll()
            cityData.removeAll()
            pincodeData.removeAll()
            
            getStateList()
        }
        
        // ============
        
        stateDropDown.anchorView = textfieldState
        stateDropDown.backgroundColor = .white
        stateDropDown.cornerRadius = 4
        
        stateDropDown.bottomOffset = CGPoint(x: 0, y:(stateDropDown.anchorView?.plainView.bounds.height)!)
        stateDropDown.topOffset = CGPoint(x: 0, y:-(stateDropDown.anchorView?.plainView.bounds.height)!)
        
        stateDropDown.selectionAction = { [self] (index, title) in
            textfieldState.text = title
            selectedStateId = stateData[index].id!
            
            selectedCityId = 0
            selectedPincodeId = 0
        
            textfieldCity.text = nil
            textfieldPincode.text = nil
            
            cityData.removeAll()
            pincodeData.removeAll()
            
            getCityList()
        }
        
        // =============
        
        cityDropDown.anchorView = textfieldCity
        cityDropDown.backgroundColor = .white
        cityDropDown.cornerRadius = 4
        
        cityDropDown.bottomOffset = CGPoint(
            x: 0,
            y:(cityDropDown.anchorView?.plainView.bounds.height)!
        )
        cityDropDown.topOffset = CGPoint(
            x: 0,
            y:-(cityDropDown.anchorView?.plainView.bounds.height)!
        )
        
        cityDropDown.selectionAction = { [self] (index, title) in
            textfieldCity.text = title
            selectedCityId = cityData[index].id!
            self.getActiveModules(cityId: selectedCityId)
            selectedPincodeId = 0
            textfieldPincode.text = nil
            pincodeData.removeAll()
            setupDeliveryRangeViews()
            getPincodeList()
        }
        
        // =========
        
        pincodeDropDown.anchorView = textfieldPincode
        pincodeDropDown.backgroundColor = .white
        pincodeDropDown.cornerRadius = 4
        pincodeDropDown.bottomOffset = CGPoint(x: 0, y:(pincodeDropDown.anchorView?.plainView.bounds.height)!)
        pincodeDropDown.topOffset = CGPoint(x: 0, y:-(pincodeDropDown.anchorView?.plainView.bounds.height)!)
        
        pincodeDropDown.selectionAction = { [self] (index, title) in
            textfieldPincode.text = title
            selectedPincodeId = pincodeData[index].id!
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getActiveModules(cityId:Int) {
        
        let param = [
            Parameter.cityId: cityId
        ] as [String : Any]
        
        Networking.requestNew(
            url: Urls.getActiveModules,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                
            case .success(let data):
                
                guard let jsonData = data else {
                    AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                    return
                }
                
                guard let rsResponse = self.convertToDictionary(text: String(data:jsonData, encoding:.utf8)!) else {
                    AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                    return
                }
                
                print(rsResponse["status"] as! Int)
                
                if rsResponse["status"] as! Int == StatusCode.success.rawValue {
                    
                    let cityArray = rsResponse["data"] as! NSArray
                    print(cityArray)
                    
                    let cityModule = cityArray[0] as! NSDictionary
                    
                    Parameter.is_pharmacy_manual_order_allow = cityModule["is_pharmacy_manual_order_allow"] as! Int == 1 ? true : false
                    Parameter.is_ledger_statement_allow = cityModule["is_ledger_statement_allow"] as! Int == 1 ? true : false
                    Parameter.deliveryTypeboth = cityModule["deliveryType"] as! String
                    Parameter.is_agreement = cityModule["is_agreement_allow"] as! Int == 1 ? true : false
                    Parameter.module_city_id = cityModule["city_id"] as! Int
                    
                } else if rsResponse["status"] as! Int == StatusCode.notFound.rawValue {
                    present(UpdatePopup.instantiate(), animated: true, completion: nil)
                    
                } else {
                    present(UpdatePopup.instantiate(), animated: true, completion: nil)
                    //                        AlertHelper.shared.showAlert(message: rsResponse.message!)
                }
                
            case .failure(let error):
                AlertHelper.shared.showAlert(message: error.localizedDescription)
                Log.e(error.localizedDescription)
                Helper.shared.setLogout()
                
            }
        }
    }
    
    private func setUpDelegates() {
        textfieldRangeOfDelivery.keyboardType = .decimalPad
        uiViewToolBar.delegate = self
    }
    
    private func setUpMap() {
        
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
        mapView.delegate = self
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.isMyLocationEnabled = true
        
        
        if let lat = locationManager.location?.coordinate.latitude ,let lng = locationManager.location?.coordinate.longitude {
            print("Lat and long",lat,lng)
            let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 17)
            mapView.animate(to: camera)
            // checkForTheUserLocationStatus()
        } else {
            let camera = GMSCameraPosition.camera(
                withLatitude: 22.298506092214073,
                longitude: 70.80180102845586,
                zoom: 5
            )
            mapView.animate(to: camera)
        }
        
    }
    
    @IBAction func btnUploadLogoPressed(_ sender: UIButton) {
        MediaPicker.shared.chooseOptionForMediaType(delegate: self)
    }
    
    @IBAction func btnFullScreenImagePressed(_ sender: UIButton) {
        if let img = logoData?.image {
            let vc = FullScreenVC.instantiate()
            vc.image = img
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        imageViewPharmacyLogo.image = nil
        uiViewLogoImageContainer.isHidden = true
        uiViewPharmacyLogoBorder.isHidden = false
    }
    
    @IBAction func btnInternalDeliveryYesNoPressed(_ sender: UIButton) {
        
        selectedProvideInternalDelivery = sender.tag
        
        for btns in btnDeliveryYesNo {
            if btns.tag == selectedProvideInternalDelivery {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedProvideInternalDelivery == 0 {
            textfieldRangeOfDelivery.isHidden = true
        } else {
            textfieldRangeOfDelivery.isHidden = false
        }
    }
    
    @IBAction func btnTakingRegularLunchYesNo(_ sender: UIButton) {
        
        selectedTakingRegularLunch = sender.tag
        
        for btns in btnTakingRegularLunchYesNo {
            if btns.tag == selectedTakingRegularLunch {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedTakingRegularLunch == 1 {
            stackViewTakingRegularLunch.isHidden = true
        } else {
            stackViewTakingRegularLunch.isHidden = false
        }
        
    }
    
    @IBAction func btnOpenOnSundayYesNoPressed(_ sender: UIButton) {
        
        selectedOpenOnSunday = sender.tag
        
        for btns in btnOpenOnSundayYesNo {
            if btns.tag == selectedOpenOnSunday {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedOpenOnSunday == 1 {
            stackViewSundayTiming.isHidden = true
        } else {
            stackViewSundayTiming.isHidden = false
        }
        
    }
    
    @IBAction func btnSundayTimingOptionPressed(_ sender: UIButton) {
        
        selectedSundayTimingOption = sender.tag
        
        for btns in btnSundayTimingOption {
            if btns.tag == selectedSundayTimingOption {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedSundayTimingOption == 0 {
            stackSundaySpecificTimings.isHidden = true
            //
        } else {
            stackSundaySpecificTimings.isHidden = false
        }
        
    }
    
    @IBAction func btnSundayLunchYesNoPressed(_ sender: UIButton) {
        
        selectedSundayLunchTime = sender.tag
        
        for btns in btnSundayLunchYesNo {
            if btns.tag == selectedSundayLunchTime {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedSundayLunchTime == 1 {
            stackViewSundayLunchTiming.isHidden = true
        } else {
            stackViewSundayLunchTiming.isHidden = false
        }
        
    }
    
    @IBAction func btnNextPressed(_ sender: HalfCornerButton) {
        validateForm()
    }
    
    @IBAction func btnSearchPressed(_ sender: Any) {
        let autoCompleteViewController = GMSAutocompleteViewController()
        autoCompleteViewController.delegate = self
        self.present(autoCompleteViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnRegularShopOpenTime(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldShopOpenTime.text = timeString
            },
            NoAction: nil
        )
    
    }
    
    @IBAction func btnShopCloseTime(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldShopCloseTime.text = timeString
            },
            NoAction: nil
        )
    
    }
    
    @IBAction func btnRegularLunchOpenTime(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldTakingRegularLunchOpenTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnRegularLunchCloseTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldTakingRegularLunchCloseTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnSundayShopOpenTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldSundayShopOpenTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnSundayShopCloseTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldSundayShopClosingTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnSundayLunchOpenTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldSundayLunchOpenTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnSundayLunchCloseTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldSundayLunchCloseTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnCountryListPressed(_ sender: UIButton) {
        if !countryData.isEmpty {
            countryDropDown.dataSource = countryData.map({ $0.countryName ?? "" })
            countryDropDown.show()
        }
    }
    
    @IBAction func btnStateListPressed(_ sender: UIButton) {
        if !stateData.isEmpty {
            stateDropDown.dataSource = stateData.map({ $0.stateName ?? "" })
            stateDropDown.show()
        }
    }
    
    @IBAction func btnCityListPressed(_ sender: UIButton) {
        if !cityData.isEmpty {
            cityDropDown.dataSource = cityData.map({ $0.cityname ?? "" })
            cityDropDown.show()
        }
    }
    
    @IBAction func btnPincodeListPressed(_ sender: UIButton) {
        if !pincodeData.isEmpty {
            pincodeDropDown.dataSource = pincodeData.map({ "\($0.pinCode!)"})
            pincodeDropDown.show()
        }
    }
    
    private func checkForTheUserLocationStatus() {
        
        switch(CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                
                if let lat = mapView.myLocation?.coordinate.latitude,
                   let lng = mapView.myLocation?.coordinate.longitude {
                    let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 17)
                    mapView.animate(to: camera)
                }
                print("Authorize.")
                
            case .notDetermined, .restricted, .denied:
                
                goToTheSettingsForLocation()
            @unknown default:
                break
        }
    }
    
    private func goToTheSettingsForLocation() {
        // initialise a pop up for using later
        let alertController = UIAlertController(title: "", message: "Please go to Settings and turn on the Location", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: Strings.cancelOption, style: .default) { (_) in
            //            let camera = GMSCameraPosition.camera(withLatitude: 28.7041 ,longitude: 77.1025, zoom: 1)
            //            self.mapView.animate(to: camera)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupDeliveryRangeViews() {
        
        guard !cityData.isEmpty else { return }
        
        for city in cityData {
            if city.id! == selectedCityId {
                
                switch city.deliveryType ?? "" {
                        
                    case DeliveryType.internald.serverString:
                        stackViewDeliveryQue.isHidden = true
                        textfieldRangeOfDelivery.isHidden = false
                    case DeliveryType.external.serverString:
                        stackViewDeliveryQue.isHidden = true
                        textfieldRangeOfDelivery.isHidden = true
                    case DeliveryType.both.serverString:
                        stackViewDeliveryQue.isHidden = false
                    default:
                        stackViewDeliveryQue.isHidden = true
                        textfieldRangeOfDelivery.isHidden = true
                }
       
                break
            }
        }
        
    }
    
}

extension PharmacyDetailsVC : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        textfieldLatitude.text = String(position.target.latitude)
        textfieldLongitude.text = String(position.target.longitude)
        
        let geoCoder = GMSGeocoder()
        
        geoCoder.reverseGeocodeCoordinate(position.target) { (places, error) in
            
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
                
            }
            var combineAddress = ""
            
            //            if let _ = places ,let _ = places?.firstResult() ,let _ = places?.firstResult()?.lines {
            //
            //                for address in (places!.firstResult()!.lines)! {
            //                    if address == places?.firstResult()?.lines?.last {
            //                        combineAddress += "\(address)"
            //                    } else {
            //                        combineAddress += "\(address), "
            //                    }
            //                }
            //            }
            
            if let place = places, let result = place.results() {
                
                if result.indices.contains(1) {
                    
                    for address in result[1].lines ?? [] {
                        if address == result[1].lines!.last {
                            combineAddress += "\(address)"
                        } else {
                            combineAddress += "\(address), "
                        }
                    }
                    
                } else {
                    
                    for address in result[0].lines ?? [] {
                        if address == result[0].lines!.last {
                            combineAddress += "\(address)"
                        } else {
                            combineAddress += "\(address), "
                        }
                    }
                    
                }
                
            }
            
            print("Lines:",places?.firstResult()!.lines as Any)
            print("SubLocality:",places?.firstResult()!.subLocality as Any)
            
            if places?.firstResult()?.subLocality != nil {
                //self.locality = places?.firstResult()?.subLocality
            } else if places?.firstResult()?.locality != nil {
                //self.locality = places?.firstResult()?.locality
            } else {
                //self.locality = ""
            }
//            self.labelLocality.text = self.locality
            //self.textfieldAddress.text = combineAddress
        }
        
    }
}

extension PharmacyDetailsVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Name : \(place.name ?? "")")
        print("Latitude : \(place.coordinate.latitude)")
        print("Longitude : \(place.coordinate.longitude)")
        
        let lat = place.coordinate.latitude
        let lng = place.coordinate.longitude
        
        dismiss(animated: true) {
            let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 17)
            self.mapView.animate(to: camera)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error : \(error.localizedDescription)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension PharmacyDetailsVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                
                if let lat = locationManager.location?.coordinate.latitude,
                   let lng = locationManager.location?.coordinate.longitude {
                    
                    let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 17)
                    mapView.animate(to: camera)
                }
            
                print("Authorize.")
                
            case .notDetermined, .restricted, .denied:
                
                //22.298506092214073, 70.80180102845586 // Default lat long
                
                print("Location Denied")
                let camera = GMSCameraPosition.camera(withLatitude: 22.298506092214073 ,longitude: 70.80180102845586, zoom: 5)
                mapView.animate(to: camera)
                
            @unknown default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView?.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
}




extension PharmacyDetailsVC: ToolBarDelegate, MediaPickerDelegate {
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func mediaPicked(media: MediaData) {
        logoData = media
        imageViewPharmacyLogo.image = media.image
        uiViewPharmacyLogoBorder.isHidden = true
        uiViewLogoImageContainer.isHidden = false
    }
    
}

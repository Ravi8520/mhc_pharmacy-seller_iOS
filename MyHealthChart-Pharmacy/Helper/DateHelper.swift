//
//  DateHelper.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

class DateHelper: NSObject {
    
    static let shared = DateHelper()
    
    struct DateStrings {
        
        static let monthFormat = "MM"
        static let stringMonthFormat = "MMMM"
        static let yearFormat = "yyyy"
        static let dayFormat = "dd"
        static let fullHourFormat = "HH"
        static let minuteFormate = "mm"
        
        static let serverTimeFormat = "HH:mm"
        static let serverDateFormat = "yyyy-MM-dd"
        static let appTimeFormat = "hh:mm a"
        static let appDateFormat  = "dd-MM-yyyy"
        static let serverDateFormat24 = "yyyy-MM-dd HH:mm"
        static let appOrderDateFormate = "dd-MM-yyyy, hh:mm a"
        static let appLongDateFormat = "hh:mm a, dd-MM-yyyy"
        
    }
    
    private var currentUnixTime: TimeInterval {
        get {
            Date().timeIntervalSince1970
        }
    }
    
    func getNextValidUptoYears() -> [String] {
        
        var years: [String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "\(DateStrings.yearFormat)"
        
        for i in 0...4 {
            let nextYearDate = Calendar.current.date(byAdding: .year, value: i, to: Date())!
            years.append(formatter.string(from: nextYearDate))
        }
        
        return years
    }
    
    func get24HourTime(fromTime time: String) -> String {
        
        if time.isEmpty {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.appTimeFormat
        let date = formatter.date(from: time)
        formatter.dateFormat = DateStrings.serverTimeFormat
        return formatter.string(from: date!)
    }
    
    func getFullTime(fromTime time: String) -> String {
        
        if time.isEmpty {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.serverTimeFormat
        let date = formatter.date(from: time)
        formatter.dateFormat = DateStrings.appTimeFormat
        return formatter.string(from: date!)
    }
    
    func getFullTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.appTimeFormat
        return formatter.string(from: date)
    }
    
    func convertServerDate(oldDate: String?) -> String? {
        
        guard let oldDate = oldDate else { return "" }
        
        if oldDate.isEmpty { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.appDateFormat
        let date = formatter.date(from: oldDate)
        formatter.dateFormat = DateStrings.serverDateFormat
        return formatter.string(from: date!)
    }
    
    func convertAppDate(oldDate: String?) -> String? {
        
        guard let oldDate = oldDate else { return " - " }
        
        if oldDate.isEmpty { return " - " }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.serverDateFormat24
        let date = formatter.date(from: oldDate)
        formatter.dateFormat = DateStrings.appLongDateFormat
        return formatter.string(from: date!)
    }
    
    func convertAppDate(oldDate24: String?) -> String? {
        
        guard let oldDate = oldDate24 else { return " - " }
        
        if oldDate.isEmpty { return " - " }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.serverDateFormat24
        let date = formatter.date(from: oldDate24!)
        formatter.dateFormat = DateStrings.appDateFormat
        return formatter.string(from: date!)
    }
    
    func convertAppLongDate(serverDate24: String?) -> String? {
        
        guard let oldDate = serverDate24 else { return " - " }
        
        if oldDate.isEmpty { return " - " }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.serverDateFormat24
        let date = formatter.date(from: oldDate)
        formatter.dateFormat = DateStrings.appLongDateFormat
        return formatter.string(from: date!)
    }
    
    func getCurrentServerFormatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.serverDateFormat
        return formatter.string(from: Date())
    }
    
    func getCurrentMonthServerDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "\(DateStrings.yearFormat)-\(DateStrings.monthFormat)-\(DateStrings.dayFormat)"
        return formatter.string(from: Date())
    }
    
    func convertServerTime(appTime: String?) -> String? {
        
        guard let oldtime = appTime else { return "" }
        
        if oldtime.isEmpty { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.appTimeFormat
        let date = formatter.date(from: oldtime)
        formatter.dateFormat = DateStrings.serverTimeFormat
        return formatter.string(from: date!)
    }
    
    func getOrderFormateDate(serverDate: String?) -> String {
        
        guard let olddate = serverDate else { return "" }
        
        if olddate.isEmpty { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.serverDateFormat24
        let date = formatter.date(from: olddate)
        formatter.dateFormat = DateStrings.appOrderDateFormate
        return formatter.string(from: date!)
    }
    
    func convertAppTime(serverTime: String?) -> String? {
        
        guard let oldtime = serverTime else { return " - " }
        
        if oldtime.isEmpty { return " - " }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.serverTimeFormat
        let date = formatter.date(from: oldtime)
        formatter.dateFormat = DateStrings.appTimeFormat
        return formatter.string(from: date!)
    }
    
    func getTime(date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy - hh:mm:ss a"
        return dateFormater.string(from: date)
    }
    
    func getMonthYearFrom(date: String?) -> (year: String, month: String) {
        
        guard let oldtime = date else { return ("","") }
        
        if oldtime.isEmpty { return ("","") }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStrings.serverDateFormat
        let date = formatter.date(from: oldtime)
        formatter.dateFormat = DateStrings.yearFormat
        let year = formatter.string(from: date!)
        formatter.dateFormat = DateStrings.stringMonthFormat
        let month = formatter.string(from: date!)
        return (year, month)
        
    }
    
    // MARK: - Date & Time Picker -
    
    func openDatePicker(
        Message msg: String,
        Format format: String,
        Mode mode: UIDatePicker.Mode,
        YesActionTitle: String = Strings.doneButtonTitle,
        NoActionTitle: String = Strings.cancelOption,
        minimumDate: Date?,
        maximumDate: Date?,
        YesAction:@escaping ((String) -> Void),
        NoAction: ((UIAlertAction) -> Void)?
        
    ) {
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = mode
        
        if let _ = minimumDate {
            datePicker.minimumDate = minimumDate!
        }
        
        if let _ = maximumDate {
            datePicker.maximumDate = maximumDate!
        }
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        let dateChooserAlert = UIAlertController(title: "\(msg)", message: nil, preferredStyle: .alert)
        
        dateChooserAlert.view.addSubview(datePicker)
        
        dateChooserAlert.addAction(UIAlertAction(title: YesActionTitle, style: .default, handler: { action in
            YesAction(formatter.string(from: datePicker.date))
            
        }))
        
        dateChooserAlert.addAction(UIAlertAction(title: NoActionTitle, style: .cancel, handler: NoAction ))
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: dateChooserAlert.view.topAnchor, constant: 35).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: dateChooserAlert.view.bottomAnchor, constant: -50).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: dateChooserAlert.view.leadingAnchor, constant: 50).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: dateChooserAlert.view.trailingAnchor, constant: -50).isActive = true
        dateChooserAlert.view.addConstraint(height)
        
        let vc = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sc = vc?.delegate as? SceneDelegate
        sc?.window?.rootViewController?.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    
}

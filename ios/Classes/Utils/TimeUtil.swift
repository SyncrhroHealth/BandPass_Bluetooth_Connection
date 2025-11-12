//
//  TimeUtil.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 8/3/25.
//

import Foundation
// import TrueTime  // Not currently used - code is commented out

let DAY_DATE_FORMAT = "yyyy-MM-dd"
let FULL_DATE_FORMAT = "yyyy-MM-dd HH:mm:ss"
let DAY_FORMAT = "-dd."
let WEEK_FORMAT = "yyyy. MMM. dd"
let MONTH_FORMAT = "yyyy. MMMM"
let YEAR_FORMAT = "yyyy."

public class TimeUtil {
  public static let ENABLE_DEBUG_LOG = false
  public static let ENABLE_CLOUD_LOG = false
  
  static func getTimezoneLocalInMinutes()->Int{
    let timezoneLocalInMinutes = TimeZone.current.offsetMinutes()
    return timezoneLocalInMinutes
  }
  
  static func getEpochTimeInSec() -> Int64 {
    return Date().millisecondsSince1970 / 1000
  }
  
  static func getEpochTimeInMillis() -> Int64 {
    return Date().millisecondsSince1970
  }
  
  static func getEpochStartOfDay(minus: Int = 0) -> Int64 {
    let date = Calendar.current.date(byAdding: .day, value: minus, to: Date().startOfDay)!
    return date.millisecondsSince1970 + Int64(TimeZone.current.offsetSeconds() * 1000)
  }
  
  static func convertTimeInDay(secs: Int64) -> Int64 {
    return Date(milliseconds:secs * 1000).startOfDay.millisecondsSince1970 / 1000
  }
  
  static func convertTimeInMonth(secs: Int64) -> Int64 {
    return Date(milliseconds:secs * 1000).startOfMonth.millisecondsSince1970 / 1000
  }
  
  static func formatDate(millis: Int64) -> String {
    let date = Date(milliseconds: millis)
    let format = DateFormatter()
    format.dateFormat = "MM-dd-yyyy-HH-mm-ss.SSS"
    return format.string(from: date)
  }
  
  static func formatTimeFileLog(millis: Int64) -> String {
    let epoch = millis - Int64(TimeZone.current.offsetSeconds() * 1000)
    let date = Date(milliseconds: epoch)
    let format = DateFormatter()
    format.dateFormat = "yyyyMMdd_HHmmss"
    format.timeZone = TimeZone.current
    return format.string(from: date)
  }
    
    static func formatTimeMMddHHmm(millis: Int64) -> String {
      let date = Date(milliseconds: millis)
      let format = DateFormatter()
      format.dateFormat = "MMdd:HH:mm"
      format.timeZone = TimeZone.current
      return format.string(from: date)
    }
  
  static func getUTCTrueTime(time: @escaping(Int64)->()) {
    let utcTrueTime = Date().millisecondsSince1970/1000
    time(utcTrueTime)
    //        // At an opportune time (e.g. app start):
    //        let client = TrueTimeClient.sharedInstance
    //
    //        // To block waiting for fetch, use the following:
    //        client.fetchIfNeeded { result in
    //            switch result {
    //            case .success(_):
    //                do {
    //                    let utcTrueDate = try result.get().now()
    //                    print("utc:", utcTrueDate.timeIntervalSince1970)
    //                    utcTrueTime = Int64(utcTrueDate.timeIntervalSince1970)
    //                } catch {
    //                    print("parse trueTime result error")
    //                }
    //                time(utcTrueTime)
    //            case .failure(_):
    //                time(utcTrueTime)
    //            }
    //        }
  }
}

extension Date {
  var startOfDay : Date {
    let calendar = Calendar.current
    let unitFlags = Set<Calendar.Component>([.year, .month, .day])
    let components = calendar.dateComponents(unitFlags, from: self)
    return calendar.date(from: components)!
  }
  
  var endOfDay : Date {
    var components = DateComponents()
    components.day = 1
    let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
    return (date?.addingTimeInterval(-1))!
  }
  
  var startOfMonth : Date {
    let calendar = Calendar.current
    let unitFlags = Set<Calendar.Component>([.year, .month])
    let components = calendar.dateComponents(unitFlags, from: self)
    return calendar.date(from: components)!
  }
  
  var endOfMonth : Date {
    var components = DateComponents()
    components.month = 1
    let date = Calendar.current.date(byAdding: components, to: self.startOfMonth)
    return (date?.addingTimeInterval(-1))!
  }
}



extension Date {
    
    func getWeekDates() -> (thisWeek:[Date],nextWeek:[Date]) {
        var tuple: (thisWeek:[Date],nextWeek:[Date])
        var arrThisWeek: [Date] = []
        for i in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        var arrNextWeek: [Date] = []
        for i in 1...7 {
            arrNextWeek.append(Calendar.current.date(byAdding: .day, value: i, to: arrThisWeek.last!)!)
        }
        tuple = (thisWeek: arrThisWeek,nextWeek: arrNextWeek)
        return tuple
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
    }
    
    func toDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
    
    static let dayAbbrMap: [String: String] = [
        "7": NSLocalizedString("vasárnap", comment: "sunday"),
        "1": NSLocalizedString("hétfő", comment: "monday"),
        "2": NSLocalizedString("kedd", comment: "tuesday"),
        "3": NSLocalizedString("szerda", comment: "wednesday"),
        "4": NSLocalizedString("csütörtök", comment: "thursday"),
        "5": NSLocalizedString("péntek", comment: "friday"),
        "6": NSLocalizedString("szombat", comment: "saturday")
    ]
    
    static let monthAbbrMap: [String: String] = [
        "01": NSLocalizedString("január", comment: "january"),
        "02": NSLocalizedString("február", comment: "february"),
        "03": NSLocalizedString("március", comment: "march"),
        "04": NSLocalizedString("április", comment: "april"),
        "05": NSLocalizedString("május", comment: "may"),
        "06": NSLocalizedString("június", comment: "june"),
        "07": NSLocalizedString("július", comment: "july"),
        "08": NSLocalizedString("augusztus", comment: "august"),
        "09": NSLocalizedString("szeptember", comment: "september"),
        "10": NSLocalizedString("október", comment: "october"),
        "11": NSLocalizedString("november", comment: "november"),
        "12": NSLocalizedString("december", comment: "december")
    ]
    
    func yearsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date: Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date: Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
       dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    func toDayFormat(dateAsString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let dateAsDate = dateFormatter.date(from: dateAsString) {
            if Calendar.current.isDateInToday(dateAsDate) {
                return "today, \(dateAsDate.toDate(format: "hh:mm a"))"
            } else if Calendar.current.isDateInYesterday(dateAsDate) {
                return "yesterday, \(dateAsDate.toDate(format: "hh:mm"))"
            } else {
                return dateAsDate.toDate(format: "MMMM d, yyyy")
            }
        }
        return dateAsString
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

//
//  Utils.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2019/12/13.
//

import Foundation

public class Utils {
    @available(OSX 10.12, *)
    public static func timeRangeSlice(interval: DateInterval, days: Int) -> [DateInterval] {
        var slice: [DateInterval] = []
        
        
        var start: Date = interval.start
        let end:   Date = interval.end
        
        let daysHour = 24 * days
        
        var next: Date = nextTime(from: start, by: daysHour)!
        var compare = next.compare(end)
        while compare == .orderedAscending {
            // next < end
            // slice.append( [startDate, nextTenDays] )
            slice.append(DateInterval(start: start, end: next))
            
            // start = next + 1 hour
            start = nextTime(from: next,  by: 1)!
            next  = nextTime(from: start, by: daysHour)!
            compare = next.compare(end)
        }
        
        // slice.append( [startDate, endDate] )
        slice.append(DateInterval(start: start, end: end))
        
        return slice
    }
    
    public static func nextTime(from baseTime: Date, by addHours: Int) -> Date? {
        var dateComp = DateComponents()
        dateComp.hour = addHours
        
        let next: Date? = Calendar.current.date(byAdding: dateComp, to: baseTime)

        return next
    }
}

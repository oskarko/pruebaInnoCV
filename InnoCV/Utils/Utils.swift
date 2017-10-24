//
//  Utils.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 23/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import Foundation


class Utils {
    
    static func fromDateToString(date: Date) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    
    static func fromStringToDate(date: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:date)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        print(calendar.date(from:components)!)
        return calendar.date(from:components)!
    }

}

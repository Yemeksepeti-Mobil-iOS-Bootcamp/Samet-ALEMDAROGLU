//
//  String+Ext.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 20.07.2021.
//

import Foundation

extension String {
    
    func dateToTRFormat() -> String {
        let dateFormatterGet = DateFormatter()
        let dateFormatterPrint = DateFormatter()
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        

        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        }
        return ""
    }
    
    func stripHTMLTags() -> String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}

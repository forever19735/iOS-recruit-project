//
//  String + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import Foundation

extension String {
    func daysUntil(to targetDate: String, with format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let fromDate = dateFormatter.date(from: self),
              let toDate = dateFormatter.date(from: targetDate) else {
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return components.day
    }
}

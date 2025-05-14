//
//

import Foundation

extension Date {
    func isInSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func addingMinutes(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func minutesSince(_ date: Date) -> Int {
        let diff = self.timeIntervalSince(date)
        return Int(diff / 60)
    }
}

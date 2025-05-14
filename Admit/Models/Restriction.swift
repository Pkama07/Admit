//
//
//

import Foundation

struct Restriction: Identifiable, Codable {
    var id = UUID()
    var appName: String
    var timeLimit: Int // Time limit in minutes
    var cooldownTime: Int // Cooldown time in minutes (5-15)
    
    var usedTime: Int = 0 // Time used in minutes
    var lastUsed: Date? = nil
    var inCooldown: Bool = false
    var cooldownEndTime: Date? = nil
    
    static func validateCooldownTime(_ time: Int) -> Bool {
        return time >= 5 && time <= 15
    }
    
    var isOverLimit: Bool {
        return usedTime >= timeLimit
    }
    
    var formattedUsedTime: String {
        return "\(usedTime) minutes used today"
    }
    
    var remainingTime: Int {
        return max(0, timeLimit - usedTime)
    }
    
    var formattedRemainingTime: String {
        return "\(remainingTime) minutes remaining"
    }
}

extension Restriction {
    private static let restrictionsKey = "savedRestrictions"
    
    static func saveRestrictions(_ restrictions: [Restriction]) {
        if let encoded = try? JSONEncoder().encode(restrictions) {
            UserDefaults.standard.set(encoded, forKey: restrictionsKey)
        }
    }
    
    static func loadRestrictions() -> [Restriction] {
        if let savedRestrictions = UserDefaults.standard.data(forKey: restrictionsKey),
           let decodedRestrictions = try? JSONDecoder().decode([Restriction].self, from: savedRestrictions) {
            return decodedRestrictions
        }
        return []
    }
}

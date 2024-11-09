import SwiftUI

@main
struct CustomMacTopBarAppApp: App {
    @StateObject private var dateProvider = DateProvider()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(dateProvider: dateProvider)
        } label: {
            HStack {
                Text(dateProvider.currentDateInfo) // Show WoY, DoY, and W x/y info
                Image(systemName: "calendar") // Optional calendar icon
            }
        }
        .menuBarExtraStyle(.window)
    }
}

class DateProvider: ObservableObject {
    @Published var currentDateInfo: String = ""
    
    @Published var referenceStartDate: Date {
        didSet {
            UserDefaults.standard.set(referenceStartDate, forKey: "referenceStartDate")
            updateDateInfo()
        }
    }
    
    @Published var referenceEndDate: Date {
        didSet {
            UserDefaults.standard.set(referenceEndDate, forKey: "referenceEndDate")
            updateDateInfo()
        }
    }
    
    private var timer: Timer?
    
    init() {
        let defaultStartDate = Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 10))!
        let defaultEndDate = Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 10))!
        
        referenceStartDate = UserDefaults.standard.object(forKey: "referenceStartDate") as? Date ?? defaultStartDate
        referenceEndDate = UserDefaults.standard.object(forKey: "referenceEndDate") as? Date ?? defaultEndDate
        
        updateDateInfo()
        startUpdatingDateInfo()
    }
    
    private func startUpdatingDateInfo() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.updateDateInfo()
        }
    }
    
    private func updateDateInfo() {
        let calendar = Calendar.current
        let currentWeek = calendar.component(.weekOfYear, from: Date())
        let totalWeeks = calendar.range(of: .weekOfYear, in: .yearForWeekOfYear, for: Date())?.count ?? 52
        
        let currentDay = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let totalDays = calendar.range(of: .day, in: .year, for: Date())?.count ?? 365
        
        let weeksSinceStart = calendar.dateComponents([.weekOfYear], from: referenceStartDate, to: Date()).weekOfYear ?? 0
        let totalWeeksBetween = calendar.dateComponents([.weekOfYear], from: referenceStartDate, to: referenceEndDate).weekOfYear ?? 0
        
        DispatchQueue.main.async {
            self.currentDateInfo = "WoY \(currentWeek)/\(totalWeeks); DoY \(currentDay)/\(totalDays); W \(weeksSinceStart)/\(totalWeeksBetween)"
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

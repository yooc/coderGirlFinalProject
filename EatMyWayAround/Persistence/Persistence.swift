import Foundation

struct Persistence {
    private let baseFileName = "AppData.json"
    
    var documentsUrl: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    //    func readUserList(for user: String) -> [String: Any]? {
    //        let fileManager = FileManager.default
    //        let fileName = "\(user)-\(baseFileName)"
    //
    //        guard let documentsDirectory = documentsUrl else {
    //            print("Could not read documents directory")
    //            return nil
    //        }
    //
    //        let appDataUrlPath = documentsDirectory.appendingPathComponent(fileName, isDirectory: false).path
    //
    //        guard fileManager.fileExists(atPath: appDataUrlPath) else {
    //            print("No saved data")
    //            return nil
    //        }
    //
    //        guard fileManager.isReadableFile(atPath: appDataUrlPath) else {
    //            print("Unreadable file")
    //            return nil
    //        }
    //
    //        guard let appData = fileManager.contents(atPath: appDataUrlPath) else {
    //            print("App data contents empty")
    //            return nil
    //        }
    //
    //        guard let appDataJson = try? JSONSerialization.jsonObject(with: appData, options: .allowFragments) else {
    //            print("Could not serialize app data")
    //            return nil
    //        }
    //
    //        guard let appDataDictionary = appDataJson as? [String: Any] else {
    //            print("App data in wrong format")
    //            return nil
    //        }
    //
    //        return appDataDictionary
    //    }
    
    func readUserList(for user: String) -> Data? {
        do {
            let fileName = "\(user)-\(baseFileName)"
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = documentDirectory.appendingPathComponent(fileName)
            let data = try Data(contentsOf: fileUrl)
            
            return data
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func writeToUserList(appData: Data, user: String) -> Bool {
        guard let documentsDirectory = documentsUrl else {
            print("Could not read documents directory")
            return false
        }
        
        let fileName = "\(user)-\(baseFileName)"
        
        let writeUrl = documentsDirectory.appendingPathComponent(fileName, isDirectory: false)
        print("\(writeUrl)")
        
        do {
            try appData.write(to: writeUrl)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}


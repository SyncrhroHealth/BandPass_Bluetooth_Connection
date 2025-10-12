//
//  FileUtils.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 8/3/25.
//

import Foundation
import SwiftyJSON

class FileUtils {
  
    private static func getPathFolder(sub: String = "") -> URL? {
        let docFolder =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return docFolder?.appendingPathComponent("deviceLogs/\(sub)", isDirectory: true)
    }
  
    static func createFolder(sub: String = "")  {
        if let folder = getPathFolder(sub: sub) {
            if !FileManager.default.fileExists(atPath: folder.path) {
                try? FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            }
        }
    }
  
    static func getFullPath(fileName: String, sub: String = "") -> URL? {
        let folder = getPathFolder(sub: sub)
        return folder?.appendingPathComponent("\(fileName)")
    }
  
    public static func writeData(data: Data, time: Int64, sub: String = "", file: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            var fileName = "\(TimeUtil.formatTimeFileLog(millis: time)).log"
            
            guard let fileUrl = getFullPath(fileName: fileName, sub: sub) else {
                file(nil)
                return
            }
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                createFolder(sub: sub)
            }
            do{
                print("WRITETO \(fileUrl.path)")
                try data.write(to: fileUrl, options: .atomic)
                file(fileName)
            }catch {
                file(nil)
                print("Unable to write new file.\(error)")
            }
        }
    }
  
    public static func writeMetaData(data: JSON, time: Int64, sub: String = "", file: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            let millis = TimeUtil.getEpochTimeInMillis()
            let fileName = "\(millis)_\(TimeUtil.formatDate(millis: time))-meta.json"
            guard let fileUrl = getFullPath(fileName: fileName, sub: sub) else {
                file(nil)
                return
            }
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                createFolder(sub: sub)
            }
            do{
                print("WRITE writeMetaData TO \(fileUrl.path)")
                try data.rawString()?.write(to: fileUrl, atomically: true, encoding: .utf8)
                file(fileName)
            }catch {
                file(nil)
                print("Unable to write in new file.\(error)")
            }
        }
    }
  
    public static func readDocByFileName(name: String, sub: String = "") -> Data? {
        guard let fullPath = getFullPath(fileName: name, sub: sub) else {
            return nil
        }
        let data =  try? Data(contentsOf: fullPath)
        print("readDocByFileName \(fullPath.path) \(data?.count)")
        return data
    }
  
    public static func deleteFile(name: String, sub: String = "") {
        guard let fullPath = getFullPath(fileName: name, sub: sub) else {
            return
        }
        if FileManager.default.fileExists(atPath: fullPath.path) {
            do{
                try FileManager.default.removeItem(atPath: fullPath.path)
                print(" deleteFile success \(fullPath.path)")
            }catch {
                print("Unable to deleteFile \(error)")
            }
        }
    }
}

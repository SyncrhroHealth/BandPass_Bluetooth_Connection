//
//  FileLogger.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 8/3/25.
//

import Foundation
import UIKit

class FileLogger {
    private static let limitSize = 10 * 1024 * 1024 //10mb
    private static func generateFile() -> URL? {
        let time = TimeUtil.getEpochStartOfDay(minus: 0)
        let name = TimeUtil.formatTimeFileLog(millis: time) + ".txt"
        let deviceName = UIDevice.modelName
        guard let fileUrl = FileUtils.getFullPath(fileName: name, sub: deviceName) else {
            return nil
        }
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileUtils.createFolder(sub: deviceName)
            generateHeader(fileUrl)
        }
        
        return fileUrl
    }
    
    static func log(_ text:  String) {
        let content = "[\(formatTime(millis: TimeUtil.getEpochTimeInMillis()))]: \(text)\n"
        guard let data = content.data(using: String.Encoding.utf8) else { return }
        guard let logFile =  generateFile() else { return }
        if (logFile.fileSize > limitSize) {return}
        if let fileHandle = try? FileHandle(forWritingTo: logFile) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        }
    }
    
    private static func generateHeader(_ logFile: URL) {
        let header =
      """
      =============================================================================
      =============================================================================
      GENERATED ON: \(formatTimeHeader(millis: TimeUtil.getEpochTimeInMillis()))
      APP VERSION: \(AppInfoManager.shared.getBuildVersion())
      DEVICE MODEL: \(UIDevice.current.model)
      DEVICE NAME: \(UIDevice.modelName)
      DEVICE VERSION RELEASE: \(UIDevice.current.systemVersion)
      DEVICE VERSION NAME: \(UIDevice.current.systemName)
      DEVICE IDENTIFIER: \(UIDevice.current.identifierForVendor?.uuidString ?? "iOS")
      =============================================================================\n
    """
        
        guard let data = header.data(using: String.Encoding.utf8) else { return }
        try? data.write(to: logFile, options: .atomic)
    }
    
    
    private static func formatTime(millis: Int64) -> String {
        let date = Date(milliseconds: millis)
        let format = DateFormatter()
        format.dateFormat = "yyMMdd:HHmmss.SSS"
        return format.string(from: date)
    }
    
    private static func formatTimeHeader(millis: Int64) -> String {
        let date = Date(milliseconds: millis)
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return format.string(from: date)
    }
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}

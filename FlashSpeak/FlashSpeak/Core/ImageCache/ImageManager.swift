//
//  ImageManager.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 01.06.2023.
//

import Foundation
import UIKit.UIImage

public final class ImageManager {
    public static let shared = ImageManager()
    static let compressionQuality = 0.5
    
    func saveImage(image: UIImage, name: String) {
        saveJPG(image, name: name)
    }
    
    func getImage(by url: URL) -> UIImage? {
        let fileManager = FileManager.default
        guard
            let url = documentDirectoryPath()?.appendingPathComponent(url.lastPathComponent)
        else { return nil }

        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
            return nil
        }
    }
    
    func urlForFile(by name: String) -> URL? {
        return documentDirectoryPath()?
            .appendingPathComponent("\(name).jpg")
    }
    
    private func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return path.first
    }
    
    private func saveJPG(_ image: UIImage, name: String) {
        if let jpgData = image.jpegData(compressionQuality: ImageManager.compressionQuality),
           let path = documentDirectoryPath()?.appendingPathComponent("\(name).jpg") {
            try? jpgData.write(to: path)
        }
    }
}

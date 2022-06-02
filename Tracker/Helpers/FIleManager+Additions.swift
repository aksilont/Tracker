//
//  FIleManager+Additions.swift
//  Tracker
//
//  Created by Aksilont on 02.06.2022.
//

import UIKit

extension FileManager {
    
    func saveSelfie(image: UIImage) {
        let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = folderURL.appendingPathComponent("avatar").appendingPathExtension("png")
        let data = image.pngData() ?? Data()
        do {
            try data.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getSelfie() -> UIImage? {
        let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = folderURL.appendingPathComponent("avatar").appendingPathExtension("png")
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            let image = UIImage(data: imageData)
            return image
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

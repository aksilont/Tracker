//
//  SelfieDelegate.swift
//  Tracker
//
//  Created by Aksilont on 01.06.2022.
//

import UIKit

class SelfieDelegate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var onTakePicture: ((UIImage) -> Void)?
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let image = self?.extractImage(from: info) else { return }
            self?.onTakePicture?(image)
        }
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[.editedImage] as? UIImage {
            return image
        } else if let image = info[.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
}

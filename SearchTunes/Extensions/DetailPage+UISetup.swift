//
//  DetailPage+UISetup.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 14.06.2023.
//

import UIKit

extension DetailViewController {
    
    func setupImageViews() {
        coverImageView.layer.cornerRadius = 16.0
        coverImageView.layer.masksToBounds = true
        coverImageView.contentMode = .scaleAspectFit
    }
    
    func setGradient(image: UIImage) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            image.averageColor?.cgColor as Any,  // Top color (light gray)
            image.averageColor?.cgColor as Any    // Bottom color (darker gray)
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = UIScreen.main.bounds  // Set the frame based on the screen's bounds
        myView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupGesture() {
        let tapFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        favoriteButtonImageView.isUserInteractionEnabled = true
        favoriteButtonImageView.addGestureRecognizer(tapFavoriteGesture)
        
        let tapPlayGesture = UITapGestureRecognizer(target: self, action: #selector(playButtonTapped))
        playButtonImageView.isUserInteractionEnabled = true
        playButtonImageView.addGestureRecognizer(tapPlayGesture)
        
        let tapForwardGesture = UITapGestureRecognizer(target: self, action: #selector(forwardButtonTapped))
        forwardButton.isUserInteractionEnabled = true
        forwardButton.addGestureRecognizer(tapForwardGesture)
        
        let tapBackGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(tapBackGesture)
        
        let tapShareGesture = UITapGestureRecognizer(target: self, action: #selector(shareButtonTapped))
        shareButtonImageView.isUserInteractionEnabled = true
        shareButtonImageView.addGestureRecognizer(tapShareGesture)
    }
    
    func setupSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor).isActive = true
        
        musicSlider.value = 0
        
        playButtonSpinner.translatesAutoresizingMaskIntoConstraints = false
        playButtonImageView.addSubview(playButtonSpinner)
        playButtonSpinner.centerXAnchor.constraint(equalTo: playButtonImageView.centerXAnchor).isActive = true
        playButtonSpinner.centerYAnchor.constraint(equalTo: playButtonImageView.centerYAnchor).isActive = true
        spinner.color = .white
        playButtonSpinner.color = .white
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        let red = CGFloat(bitmap[0]) / 255
        let green = CGFloat(bitmap[1]) / 255
        let blue = CGFloat(bitmap[2]) / 255
        let alpha = CGFloat(bitmap[3]) / 255
        
        // Darken the color by multiplying the RGB values by a factor less than 1
        let darkenFactor: CGFloat = 0.8
        let darkenedColor = UIColor(red: red * darkenFactor, green: green * darkenFactor, blue: blue * darkenFactor, alpha: alpha)
        
        return darkenedColor
    }
}

//
//  TabbarViewController.swift
//  Week-4
//
//  Created by Kerim Caglar on 10.07.2021.
//

import UIKit

class TabbarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabbarConfig()
    }

    private func tabbarConfig() {
        guard let tabbar = tabBarController?.tabBar else { return }
        
        tabbar.barTintColor = .darkText
        tabbar.tintColor = .white
        tabbar.unselectedItemTintColor = .darkGray
        
//        tabbar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //MARK: Clipsto ve mask to bound nedir? nasıl ne zaman kullanılır?
        
        // maskToBounds: Any sublayers of the layer that extend outside its boundaries will be clipped to those boundaries.
        // secilen katmanin disina tasan alt katmanlari katmanin sinirlariyla kirpar.
        
        // clipToBounds: The use case for clipsToBounds is more for subviews which are partially outside the main view.
        // Cogunlukla ana view disindaki alt viewlar icin kullanilir
        
        //MARK: tabbar için orta butonu biraz ön plana çıkarınız
        //        tabbar.layer.masksToBounds = true
    }

}

extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}

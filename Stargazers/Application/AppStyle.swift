//
//  AppStyle.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation

import UIKit

enum AppStyle {
    static var darkMode = true
    
    static var isDarkMode: Bool {
        UITraitCollection.current.userInterfaceStyle == .dark
    }
}

extension UIColor {
    static var error: UIColor {
        UIColor(named: "Error")!
    }
    
    static var warning: UIColor {
        UIColor(named: "Warning")!
    }
    
    static var success: UIColor {
        UIColor(named: "Success")!
    }
    
    static var info: UIColor {
        UIColor(named: "Info")!
    }
    
    static var grayDark: UIColor {
        UIColor(named: "GrayDark")!
    }
    
    enum Primary {
        static var normal: UIColor {
            UIColor(named: "Primary")!
        }
        
        static var light: UIColor {
            UIColor(named: "PrimaryLight")!
        }
        
        static var dark: UIColor {
            UIColor(named: "PrimaryDark")!
        }
    }

    enum Secondary {
        static var normal: UIColor {
            UIColor(named: "Secondary")!
        }
        
        static var light: UIColor {
            UIColor(named: "SecondaryLight")!
        }
        
        static var dark: UIColor {
            UIColor(named: "SecondaryDark")!
        }
        
    }
    
    enum Text {
        static var onPrimary: UIColor {
            UIColor(named: "TextOnPrimary")!
        }
        
        static var onSecondary: UIColor {
            UIColor(named: "TextOnSecondary")!
        }
    }
}

extension UIFont {
    // MARK: App Fonts - ApexNew
    
    /// HelveticaNeue
    enum HelveticaNeue {
        private static var fontName: String = "HelveticaNeue"
        
        /// Font size 40
        static let h1: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h1)
        }()
        
        /// Font size 24
        static let h2: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h2)
        }()
        
        /// Font size 22
        static let h3: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h3)
        }()
        
        /// Font size 20
        static let h4: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h4)
        }()
        
        /// Font size 18
        static let body: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.body)
        }()
        
        /// Font size 14
        static let footer: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.footer)
        }()
        
        /// Font size 12
        static let caption: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.caption)
        }()
        
        static func custom(_ size: CGFloat) -> UIFont {
            return UIFont.getFont(named: fontName, size: size)
        }
    }
    
    /// HelveticaNeue-Light
    enum HelveticaNeueLight {
        private static var fontName: String = "HelveticaNeue-Light"
        
        /// Font size 40
        static let h1: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h1)
        }()
        
        /// Font size 24
        static let h2: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h2)
        }()
        
        /// Font size 22
        static let h3: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h3)
        }()
        
        /// Font size 20
        static let h4: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h4)
        }()
        
        /// Font size 18
        static let body: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.body)
        }()
        
        /// Font size 14
        static let footer: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.footer)
        }()
        
        /// Font size 12
        static let caption: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.caption)
        }()
        
        static func custom(_ size: CGFloat) -> UIFont {
            return UIFont.getFont(named: fontName, size: size)
        }
    }
    
    /// HelveticaNeue-Medium
    enum HelveticaNeueMedium {
        
        private static var fontName: String = "HelveticaNeue-Medium"
        
        /// Font size 40
        static let h1: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h1)
        }()
        
        /// Font size 24
        static let h2: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h2)
        }()
        
        /// Font size 22
        static let h3: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h3)
        }()
        
        /// Font size 20
        static let h4: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h4)
        }()
        
        /// Font size 18
        static let body: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.body)
        }()
        
        /// Font size 14
        static let footer: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.footer)
        }()
        
        /// Font size 12
        static let caption: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.caption)
        }()
        
        static func custom(_ size: CGFloat) -> UIFont {
            return UIFont.getFont(named: fontName, size: size)
        }
    }
    
    /// HelveticaNeue-MediumItalic
    enum HelveticaNeueMediumItalic {
        
        private static var fontName: String = "HelveticaNeue-MediumItalic"
        
        /// Font size 40
        static let h1: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h1)
        }()
        
        /// Font size 24
        static let h2: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h2)
        }()
        
        /// Font size 22
        static let h3: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h3)
        }()
        
        /// Font size 20
        static let h4: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h4)
        }()
        
        /// Font size 18
        static let body: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.body)
        }()
        
        /// Font size 14
        static let footer: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.footer)
        }()
        
        /// Font size 12
        static let caption: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.caption)
        }()
        
        static func custom(_ size: CGFloat) -> UIFont {
            return UIFont.getFont(named: fontName, size: size)
        }
    }
    
    /// HelveticaNeue-Bold
    enum HelveticaNeueBold {
        
        private static var fontName: String = "HelveticaNeue-Bold"
        
        /// Font size 40
        static let h1: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h1)
        }()
        
        /// Font size 24
        static let h2: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h2)
        }()
        
        /// Font size 22
        static let h3: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h3)
        }()
        
        /// Font size 20
        static let h4: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.h4)
        }()
        
        /// Font size 18
        static let body: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.body)
        }()
        
        /// Font size 14
        static let footer: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.footer)
        }()
        
        /// Font size 12
        static let caption: UIFont = {
            return UIFont.getFont(named: fontName, size: FontSize.caption)
        }()
        
        static func custom(_ size: CGFloat) -> UIFont {
            return UIFont.getFont(named: fontName, size: size)
        }
    }
    
    // MARK: - App Font Height
    
    enum FontSize {
        /// 40
        static let h1: CGFloat = 40
        /// 24
        static let h2: CGFloat = 24
        /// 22
        static let h3: CGFloat = 22
        /// 20
        static let h4: CGFloat = 20
        /// 18
        static let body: CGFloat = 18
        /// 14
        static let footer: CGFloat = 14
        /// 12
        static let caption: CGFloat = 12
    }
}

extension UIFont {
    static func getFont(named: String, size: CGFloat) -> UIFont {
        return UIFont(name: named, size: size)!
    }
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        /// size 0 means keep the size as it is
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

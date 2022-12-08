#if canImport(UIKit)
import UIKit
#endif
import SwiftUI


@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11, *)
public extension Color {
    init(r: Double, g: Double, b: Double, a: Double) {
        self.init(.sRGB, red: r / 255, green: g / 255, blue: b / 255, opacity: a)
    }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11, *)
public extension Color {
    ///Initialize SwiftUI Color with hex **number**,
    /// - Parameter hex: Color value in hex; use Swift 0x prefix for numbers.
    ///
    ///### Example ###
    ///````
    ///let black = Color(hex: 0x000000)
    ///````
    init(hex: UInt, alpha: Double = 1) {
        self.init(
                .sRGB,
                red: Double((hex >> 16) & 0xff) / 255,
                green: Double((hex >> 08) & 0xff) / 255,
                blue: Double((hex >> 00) & 0xff) / 255,
                opacity: alpha
        )
    }
}

#if canImport(UIKit)
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11, *)
public extension UIColor {
    
    /// Initializes a color that reacts dynamically to changes in interface style and accessibility contrast settings.
    static func dynamicColor(
        light: UIColor,
        lightHC: UIColor? = nil,
        dark: UIColor,
        darkHC: UIColor? = nil
    ) -> UIColor {
        let dynamicColor = { (traits: UITraitCollection) -> UIColor in
            if traits.userInterfaceStyle == .dark {
                if traits.accessibilityContrast == .high {
                    // dark high contrast
                    return darkHC != nil ? darkHC! : dark
                } else {
                    // dark normal contrast
                    return dark
                }
            } else {
                if traits.accessibilityContrast == .high {
                    // light high contrast
                    return lightHC != nil ? lightHC! : light
                } else {
                    // light normal contrast
                    return light
                }
            }
        }
        
        return UIColor(dynamicProvider: dynamicColor)
    }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11, *)
public extension UIColor {
    
    /// Initializes a background color that reacts dynamically to elevated context in dark mode, similar to systemBackgroundColor
    static func dynamicBackground(
        light: UIColor,
        darkBase: UIColor,
        darkElevated: UIColor
    ) -> UIColor {
        let dynamicColor = { (traits: UITraitCollection) -> UIColor in
            if traits.userInterfaceStyle == .light {
                // light mode
                return light
            }
            
            // dark mode
            if traits.userInterfaceLevel == .elevated {
                // elevated (background in modal sheet etc.)
                return darkElevated
            }
            return darkBase
        }

        return UIColor(dynamicProvider: dynamicColor)
    }
}


public extension Color {
    
    /// Initializes a background color that reacts dynamically to elevated context in dark mode, similar to systemBackgroundColor
    init(
        light: UIColor,
        darkBase: UIColor,
        darkElevated: UIColor
    ) {
        self.init(
            UIColor.dynamicBackground(
                light: light,
                darkBase: darkBase,
                darkElevated: darkElevated
            )
        )
    }
}

/// Initializes a color that reacts dynamically to changes in interface style and accessibility contrast settings.
public extension Color {
    init(light: UIColor,
         lightHC: UIColor? = nil,
         dark: UIColor,
         darkHC: UIColor? = nil
    ) {
        self.init(
            UIColor.dynamicColor(
                light: light,
                lightHC: lightHC,
                dark: dark, darkHC: darkHC
            )
        )
    }
}


public extension UIColor {
    ///Initialize UIColor  with hex **number**,
    /// - Parameter hex: Color value in hex; use Swift 0x prefix for numbers.
    ///
    ///### Example ###
    ///````
    ///let black = Color(hex: 0x000000)
    ///````
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(red: CGFloat((hex >> 16) & 0xff) / 255,
                green: CGFloat((hex >> 08) & 0xff) / 255,
                blue: CGFloat((hex >> 00) & 0xff) / 255,
                alpha: alpha)
    }
}
#endif

import SwiftUI

struct Device: EnvironmentKey {
   static var defaultValue: UIDevice = UIDevice.current
}

public extension EnvironmentValues {
   var device: UIDevice {
      self[Device.self]
   }
}

public extension UIDevice {

   /// Currently only implements cases for iPhones.
   /// Recognition logic is based on UIScreen.main.bounds.height
   var iPhoneFamily: iPhoneFamily {
      switch max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)  {
      case 568:
         return .V
      case 667:
         return .VI
      case 736:
         return .VI_Plus
      case 693:
         return .X_Zoom
      case 812:
         return .X
      case 896:
         return .XI
      case 844:
         return .XII
      case 926:
         return .XII_Max
      default:
         return .undefined
      }
   }

   enum iPhoneFamily: Int {
      /// 5, 5s, SE1 || VI-Family with Display Zoom enabled
      case V = 568

      /// 6, 6S, 7, 8, SE2
      case VI = 667

      /// 6 Plus, 6S Plus. 7 Plus, 8 Plus
      case VI_Plus = 736

      /// X-Family with Display Zoom enabled
      case X_Zoom = 693

      /// X, XS, 11 Pro, 12 Mini, 13 Mini  || XI-Family with Display Zoom enabled
      case X = 812

      /// XS MAX, 11 Pro Max, XR, 11
      case XI = 896

      /// 12, 12 Pro, 13, 13 Pro
      case XII = 844

      /// 12 Pro Max, 13 Pro Max
      case XII_Max = 926

      case undefined = 0

      
   }
}

public extension UIDevice.iPhoneFamily {
    var sizeClass: SizeClass {
        switch self {
        case .V:
            return .extraSmall

        case .VI, .X_Zoom:
            return .small

        case .VI_Plus, .X, .XI, .XII:
            return .large

        case .XII_Max:
            return .extraLarge

        case .undefined:
            return .undefined
              
        }
    }
}

public extension UIDevice.iPhoneFamily {
    enum SizeClass {
        case extraSmall
        case small
        case large
        case extraLarge
        case undefined
    }
}


extension UIDevice.iPhoneFamily: CustomStringConvertible {
    public var description: String {
       switch self {
       case .V:
          return "Device Family V: 5, 5s, SE1 || VI-Family with Display Zoom enabled"

       case .VI:
          return "Device Family VI: 6, 6S, 7, 8, SE2 || VI_Plus-Family with Display Zoom enabled"

       case .VI_Plus:
          return "Device Family VI_Plus: 6 Plus, 6S Plus. 7 Plus, 8 Plus"

       case .X_Zoom:
          return
             "Device Family X_Zoom: X-Family with Display Zoom enabled"

       case .X:
          return
             "Device Family X: X, XS, 11 Pro, 12 Mini, 12s(13) Mini  || XI-Family with Display Zoom enabled"

       case .XI:
          return "Device Family XI: XS MAX, 11 Pro Max, XR, 11"

       case .XII:
          return "Device Family XII: 12, 12 Pro || XII_Max-Family with Display Zoom enabled"

       case .XII_Max:
          return "Device Family XII_Max: 12 Pro Max, 12s(13) Pro Max"

       case .undefined:
          return
             "Device Family undefined: undefined model, likely a new iPhone or some other device (e.g. iPad, Mac)"
       }
    }
}

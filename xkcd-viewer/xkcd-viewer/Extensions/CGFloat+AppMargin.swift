import Foundation
import UIKit

public typealias AppMargin = CGFloat

public extension AppMargin {

    static var none: AppMargin {
        return 0.0
    }

    static var single: AppMargin {
        return 8.0
    }
    
    static var half: AppMargin {
        return single/2
    }
    
    static var double: AppMargin {
        return single*2
    }
    
    static var triple: AppMargin {
        return single*3
    }
    
}

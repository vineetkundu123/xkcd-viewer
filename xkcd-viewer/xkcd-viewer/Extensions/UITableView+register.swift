import UIKit
import Foundation

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableCell {}

extension UITableViewHeaderFooterView: ReusableCell {}

extension UITableView {
    
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath) as? T else {
            fatalError("cellForItemAt: unknown cell type")
        }
        return cell
    }
    
    func cellForRow<T>(_ cellClass: T.Type, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = cellForRow(at: indexPath) as? T else {
            fatalError("cellForRowAt: unknown cell type")
        }
        return cell
    }
    
    public func registerHeaderFooter(_ cellClass: UITableViewHeaderFooterView.Type) {
        register(cellClass.self, forHeaderFooterViewReuseIdentifier: cellClass.identifier)
    }
    
    public func registerHeaderFooterNib(_ cellClass: UITableViewHeaderFooterView.Type) {
        register(UINib(nibName: String(describing: cellClass), bundle: nil), forHeaderFooterViewReuseIdentifier: cellClass.identifier)
    }
    
    func dequeue<T>(_ cellClass: T.Type) -> T where T: UITableViewHeaderFooterView {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: cellClass.identifier) as? T else {
            fatalError("unknown header footer view type")
        }
        return cell
    }
}

import UIKit
import FancyGradient

enum CellStyle {
    case blue
    case gray
    
    func color(for example: Example) -> UIColor {
        
        switch self {
        case .blue:
            return UIColor.white.withAlphaComponent(1)
        case .gray:
            return UIColor.white.withAlphaComponent(0.7)
        }
    }
    
    func insets(for example: Example) -> UIEdgeInsets {
        switch example {
        case .chatMessage: return UIEdgeInsets(top: 5, left: self == .blue ? 80 : 5, bottom: -5, right: self == .blue ? -5 : -80)
        case .photosCollection: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .barGraph: return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
}

class Cell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "Cell"
    
    lazy var top: NSLayoutConstraint = self.background.topAnchor.constraint(equalTo: self.contentView.topAnchor)
    lazy var left: NSLayoutConstraint = self.background.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
    lazy var bottom: NSLayoutConstraint = self.background.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    lazy var right: NSLayoutConstraint = self.background.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
    
    func setCell(style: CellStyle, example: Example) {
        background.backgroundColor = style.color(for: example)
        let insets = style.insets(for: example)
        
        top.constant = insets.top
        left.constant = insets.left
        bottom.constant = insets.bottom
        right.constant = insets.right
        
    }
    
    let fancyView = FancyGradientView(colors: [UIColor.white, UIColor.lightGray],
                                      direction: .down,
                                      type: .axial)
    
    lazy var background: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.addSubview(fancyView)
        
        fancyView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: fancyView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: fancyView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: fancyView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100).isActive = true
            NSLayoutConstraint(item: fancyView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        fancyView.frame = view.frame
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = nil
        contentView.addSubview(background)
        
        NSLayoutConstraint.activate([top, left, bottom, right])
        
        
    }
}

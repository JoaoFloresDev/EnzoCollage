import UIKit
import BouncyLayout
import FancyGradient

class ViewController: UIViewController {
    
    let numberOfItems = 680
    var randomCellStyle: CellStyle { return arc4random_uniform(10) % 2 == 0 ? .blue : .gray }
    
    lazy var style: [CellStyle] = { (0..<self.numberOfItems).map { _ in self.randomCellStyle } }()
    lazy var topOffset: [CGFloat] = { (0..<self.numberOfItems).map { _ in CGFloat(arc4random_uniform(250)) } }()
    
    let mySegmentedControl: UISegmentedControl = {
        let view = UISegmentedControl (items: ["Todas","Faltantes","Repetidas"])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var sizes: [CGSize] = {
        
        return (0..<self.numberOfItems).map { _ in
            switch example {
            case .chatMessage: return CGSize(width: UIScreen.main.bounds.width - 20, height: 40)
            case .photosCollection: return CGSize(width: floor((UIScreen.main.bounds.width - (5 * 10)) / 4), height: floor((UIScreen.main.bounds.width - (7 * 10)) / 6))
            case .barGraph: return CGSize(width: 40, height: 400)
            }
        }
    }()
    
    var insets: UIEdgeInsets {
        switch example {
        case .chatMessage: return UIEdgeInsets(top: 200, left: 0, bottom: 200, right: 0)
        case .photosCollection: return UIEdgeInsets(top: 200, left: 0, bottom: 200, right: 0)
        case .barGraph: return UIEdgeInsets(top: 0, left: 200, bottom: 0, right: 200)
        }
    }
    
    var additionalInsets: UIEdgeInsets {
        switch example {
        case .chatMessage: return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        case .photosCollection: return UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        case .barGraph: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }
    
    lazy var layout = BouncyLayout(style: .regular)
    
    lazy var collectionView: UICollectionView = {
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        view.backgroundColor = .systemGray5//UIColor(named: "placeholder")
        return view
    }()
    
    var example: Example = .photosCollection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = example.title
        view.clipsToBounds = true
        
        collectionView.contentInset = UIEdgeInsets(top: insets.top + additionalInsets.top, left: insets.left + additionalInsets.left, bottom: insets.bottom + additionalInsets.bottom, right: insets.right + additionalInsets.right)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
        view.addSubview(collectionView)
//        view.addSubview(mySegmentedControl)
        
        NSLayoutConstraint.activate([
//            mySegmentedControl.heightAnchor.constraint(equalToConstant: 100),
//            mySegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top),
//            mySegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left),
//            mySegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right)
            ])
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        let logoutBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.logoutUser));
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    @objc func logoutUser() {
        print("oi")
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell
        cell?.titleLabel.text = "\(indexPath.row)"
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        cell.setCell(style: style[indexPath.row], example: example)
        
        if example == .barGraph {
            cell.top.constant = topOffset[indexPath.row]
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? Cell
        let greenColor = UIColor(named: "darkGreen") ?? UIColor.systemGreen
        cell?.fancyView.animate(newColors: [greenColor, UIColor.green], duration: 0.7)
        cell?.fancyView.direction = .left
        cell?.fancyView.animate(newDirection: .down, duration: 0.5)
        cell?.titleLabel.textColor = .systemGray5
        print("Click \(indexPath)")
    }
}


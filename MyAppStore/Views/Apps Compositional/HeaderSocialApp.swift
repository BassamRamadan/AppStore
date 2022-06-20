

import UIKit

class HeaderSocialApp: UICollectionViewCell{
    
    @IBOutlet var title: UILabel!
    @IBOutlet var btn: UIButton!
    @IBOutlet var banarImage: UIImageView!
}

class appCell: UICollectionViewCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var primaryName: UILabel!
}
class CategoryCell: UICollectionReusableView{
    let CategoryName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        CategoryName.font = .boldSystemFont(ofSize: 22)
        addSubview(CategoryName)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CategoryName.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

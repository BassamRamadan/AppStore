

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!

    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var primaryName: UILabel!
    @IBOutlet var rate: UILabel!

    var ResultCell : Result!{
        didSet{
            name.text = ResultCell.trackName
            primaryName.text = ResultCell.primaryGenreName
            icon.sd_setImage(with: URL(string: ResultCell.artworkUrl512), completed: nil)
            
            
            if ResultCell.screenshotUrls.count > 0{
                image1.sd_setImage(with: URL(string: ResultCell.screenshotUrls[0]), completed: nil)
            }
            if ResultCell.screenshotUrls.count > 1{
                image2.sd_setImage(with: URL(string: ResultCell.screenshotUrls[1]), completed: nil)
            }
            if ResultCell.screenshotUrls.count > 2{
                image3.sd_setImage(with: URL(string: ResultCell.screenshotUrls[2]), completed: nil)
            }
        }
    }
  
}

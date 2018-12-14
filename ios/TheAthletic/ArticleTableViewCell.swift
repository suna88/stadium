//
//  ArticleTableViewCell.swift
//  
//
//  Created by Suna on 2018/12/12.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    var bgImgView = UIImageView()
    var cellMaskView = UIView()
    var titleLabel = UILabel()
    var authorLabel = UILabel()
    var updatedLabel = UILabel()
   
    let normalFont = "HiraMinProN-W3"
    let titleFont = "HiraMinProN-W6"
    let sideMargin = CGFloat(20)
    let titleLineSpacing = CGFloat(10)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.font = UIFont(name: titleFont, size:22)
        authorLabel.font = UIFont(name: titleFont, size:12)
        updatedLabel.font = UIFont(name: titleFont, size:12)
        
        titleLabel.textColor = .white
        authorLabel.textColor = .white
        updatedLabel.textColor = .white
        
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.lineSpacing = titleLineSpacing
        let attributes = [NSAttributedStringKey.paragraphStyle : titleStyle]
        titleLabel.attributedText = NSAttributedString(string: titleLabel.text!, attributes: attributes)
        
        cellMaskView.frame = contentView.frame
        let transparentBlackColor = UIColor.black.withAlphaComponent(0.4)
        cellMaskView.backgroundColor = transparentBlackColor
        bgImgView.frame = contentView.frame

        let metaInfoY = contentView.frame.origin.y + contentView.frame.size.height - 40
        authorLabel.frame.origin = CGPoint(x:sideMargin, y:metaInfoY)
        updatedLabel.frame.origin = CGPoint(x:authorLabel.frame.origin.x + authorLabel.frame.width + 10 , y:metaInfoY )
        
        
        contentView.addSubview(bgImgView)
        contentView.addSubview(cellMaskView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(updatedLabel)
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -(sideMargin)).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        titleLabel.numberOfLines = 0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bgImgView.image = nil
    }

    static let paddingBottom : CGFloat = 5
    static let height : CGFloat = 250 + paddingBottom
    
    class func getHeight() -> CGFloat {
        return height
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.height -=  ArticleTableViewCell.paddingBottom
            super.frame = frame
        }
    }
}

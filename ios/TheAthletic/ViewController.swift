//
//  ViewController.swift
//  TheAthletic
//
//  Created by Suna on 2018/12/10.
//  Copyright © 2018年 角南佑季. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var articleId: String?
    var dbKey: String?
    var content: String?
    var titleName: String?
    var authorName: String?
    var updatedAt: String?
    var bgImg: UIImage?
    let sideMargin = CGFloat(20)
    let normalFont = "HiraMinProN-W3"
    let titleFont = "HiraMinProN-W6"
    
    let titleMargin = CGFloat(25)
    let titleLineSpacing = CGFloat(10)
    
    let metaFontSize = CGFloat(10)
    let metaInfoSpacing = CGFloat(10)
    let metaInfoHeight = CGFloat(30)
    
    let contentMargin = CGFloat(25)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //　行間の設定
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.lineSpacing = titleLineSpacing
        let attributes = [NSAttributedStringKey.paragraphStyle : titleStyle]

        // スクロールビューの設定
        let scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width:self.view.frame.width, height: self.view.frame.height)
        
        // 画像の設定
        let imageView = UIImageView()
        setBGImg(articleId: self.articleId!, imageView: imageView)
        imageView.frame = CGRect(x:0,y:0,width:scrollView.frame.width, height: 250)

        // タイトルの設定
        let titleLabel = UILabel(frame: CGRect(x:sideMargin,y:imageView.frame.height + titleMargin, width:scrollView.frame.width - 2 * sideMargin, height:140))
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: titleFont, size:22.0)
        titleLabel.text = self.titleName
        titleLabel.attributedText = NSAttributedString(string: titleLabel.text!, attributes: attributes)
        titleLabel.sizeToFit()

        // 記事メタ情報の設定
        let metaInfoY = titleLabel.frame.origin.y + titleLabel.frame.height + titleMargin
        
        let authorImgView = UIImageView(image: UIImage(named:"kawaji.jpeg"))
        authorImgView.frame.origin = CGPoint(x:sideMargin, y:metaInfoY)
        authorImgView.frame.size = CGSize(width: metaInfoHeight, height: metaInfoHeight)
        
        let authorNameLabel = UILabel()
        authorNameLabel.frame.origin = CGPoint(x:authorImgView.frame.origin.x + authorImgView.frame.width + metaInfoSpacing, y: metaInfoY)
        authorNameLabel.font = UIFont(name: normalFont, size: metaFontSize)
        authorNameLabel.text = self.authorName
        authorNameLabel.sizeToFit()
        authorNameLabel.frame.size.height = metaInfoHeight
        
        let updatedAt = UILabel(frame: CGRect(x:authorNameLabel.frame.origin.x + authorNameLabel.frame.width + metaInfoSpacing, y:metaInfoY,  width:80, height: metaInfoHeight))
        updatedAt.font = UIFont(name: normalFont, size:metaFontSize)
        updatedAt.text = self.updatedAt

        // 本文テキストの設定
        let textView = UITextView(frame: CGRect(x: sideMargin ,y: authorImgView.frame.origin.y + authorImgView.frame.height + contentMargin, width:scrollView.frame.width - 2 * sideMargin, height:CGFloat(300)))
        textView.isScrollEnabled = false

        // データの取得
        let ref = Database.database().reference()
        ref.child("articles").child(self.dbKey!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.content = value?["content"] as? String ?? ""
            textView.text = self.content
            // 行間の設定
            textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
            textView.font = UIFont(name:self.normalFont, size:16)
            textView.sizeToFit()
            scrollView.contentSize.height = textView.frame.origin.y + textView.frame.height + 50
        })

        scrollView.addSubview(titleLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(authorImgView)
        scrollView.addSubview(authorNameLabel)
        scrollView.addSubview(updatedAt)
        scrollView.addSubview(textView)
       
        self.view.addSubview(scrollView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setBGImg(articleId:String, imageView:UIImageView) {
        let ref = Storage.storage().reference()
        let path = "articles/" + articleId + "/" + articleId + "_bg.jpg"
        let imgRef = ref.child(path)
        // Load the image using SDWebImage
        imageView.sd_setImage(with: imgRef, placeholderImage: nil)
    }

}


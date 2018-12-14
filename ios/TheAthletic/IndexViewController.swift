//
//  IndexViewController.swift
//  TheAthletic
//
//  Created by Suna on 2018/12/12.
//  Copyright © 2018年 角南佑季. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI

class IndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private let refreshCtl = UIRefreshControl()

    var articles = [Article]()
    var articleBox = Article()
    var selectedNumber = 0
    
    let normalFont = "HiraMinProN-W3"
    let titleFont = "HiraMinProN-W6"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(IndexViewController.refresh(sender:)), for: .valueChanged)
        // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        
        //　ナビゲーションバーの背景色
        self.navigationController?.navigationBar.barTintColor = .black
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        self.navigationController?.navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white,
            .font: UIFont(name: titleFont, size: 22)!
        ]
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        // ここが引っ張られるたびに呼び出される
        fetchArticles()
        // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        refreshCtl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ArticleTableViewCell.getHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as? ArticleTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let article = self.articles[indexPath.row]
        // 背景画像の設定
        setBGImg(articleId: article.id!, imageView: cell.bgImgView)
        cell.titleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.updatedLabel.text = article.updatedAt

        cell.titleLabel.sizeToFit()
        cell.authorLabel.sizeToFit()
        cell.updatedLabel.sizeToFit()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNumber = indexPath.row
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        performSegue(withIdentifier: "ArticleDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArticleDetail" {
           let articleVC = segue.destination as! ViewController
            articleVC.articleId = self.articles[selectedNumber].id
            articleVC.authorName = self.articles[selectedNumber].author
            articleVC.titleName = self.articles[selectedNumber].title
            articleVC.dbKey = self.articles[selectedNumber].dbKey
            articleVC.updatedAt = self.articles[selectedNumber].updatedAt
        }
    }

    
    private func fetchArticles() {
        self.articles = [Article]()
        self.articleBox = Article()
        
        let ref = Database.database().reference()
        ref.child("articles").queryLimited(toLast: 10).observeSingleEvent(of: .value){
        (snap, error) in
            let articlesSnap = snap.value as? [String:NSDictionary]
            
            if articlesSnap == nil {
                return
            }
            
            self.articles = [Article]()
            
            for (dbKey, article) in articlesSnap!{
                let oneArticle = Article()
                if let title = article["title"] as? String, let author = article["author"] as? String, let id = article["id"] as? Int {
                    oneArticle.title = title
                    oneArticle.author = author
                    oneArticle.id = String(id)
                    oneArticle.dbKey = dbKey
                    oneArticle.updatedAt = "2時間前"
                }
                self.articles.append(oneArticle)
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    private func setBGImg(articleId:String, imageView:UIImageView) {
        let ref = Storage.storage().reference()
        let path = "articles/" + articleId + "/" + articleId + "_bg.jpg"
        let imgRef = ref.child(path)
        // Load the image using SDWebImage
        imageView.sd_setImage(with: imgRef, placeholderImage: nil)
    }

}

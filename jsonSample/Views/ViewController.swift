//
//  ViewController.swift
//  jsonSample
//
//  Created by 松丸真 on 2020/04/20.
//  Copyright © 2020 松丸真. All rights reserved.
//

import UIKit
import SDWebImage

struct SampleModel: Decodable {
  
  struct Sample: Decodable {
    let name: String?
    let image: String?
  }
  let userInfo: [Sample]?
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  var items: [SampleModel.Sample]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadJsonFile()
      
    tableView.dataSource = self
    tableView.delegate = self

  }
  
  func loadJsonFile() {
    // パスの取得
    guard let path = Bundle.main.path(forResource: "sample", ofType: "json") else { return }
    // URLの取得
    let url = URL(fileURLWithPath: path)

    do {
      // JSONファイルを読み込みDataオブジェクトに格納する
      let data = try Data(contentsOf: url)
//      print(data) // byte数が表示される

      // Dataオブジェクトをモデルオブジェクトにパースする
      let samples = try
        JSONDecoder().decode(SampleModel.self, from: data)

      self.items = samples.userInfo
      

    } catch  {
      print(error)

    }
  
    print(items ?? "nil")
  }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    
    let imageView = cell?.contentView.viewWithTag(1) as! UIImageView
    let nameLabel = cell?.contentView.viewWithTag(2) as! UILabel
    
    let imageUrl = URL(string: (items?[indexPath.row].image)!)
    
    imageView.sd_setImage(with: imageUrl)
    nameLabel.text = items?[indexPath.row].name
    
    imageView.layer.cornerRadius = 35.0
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

}

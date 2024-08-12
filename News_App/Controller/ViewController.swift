//
//  ViewController.swift
//  News_App
//
//  Created by Pushpendra on 26/07/24.
//

import UIKit
import Kingfisher
class ViewController: UIViewController, UITextFieldDelegate {
    
    var sideMenuTableView = UITableView()
    var sideView = UIView()
    let showSearchView:UIView = {
        let showSearchView = UIView()
        showSearchView.translatesAutoresizingMaskIntoConstraints = false
        showSearchView.backgroundColor = UIColor.yellow
        showSearchView.layer.borderWidth = 2
        showSearchView.layer.cornerRadius = 10
        return showSearchView
    }()
    let searchTxtField:UITextField = {
        let searchTxtField = UITextField()
        searchTxtField.translatesAutoresizingMaskIntoConstraints = false
        searchTxtField.backgroundColor = UIColor.white
        searchTxtField.layer.borderWidth = 1
        searchTxtField.layer.cornerRadius = 10
        searchTxtField.placeholder = "Search here"
        //  padding for searchTxtField
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchTxtField.frame.height))
        searchTxtField.leftView = paddingView
        searchTxtField.leftViewMode = .always
        return searchTxtField
    }()
    var sideMenuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "menu-burger.png"), for: .normal)
        return button
    }()
    //Main table News
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = UIColor.blue
        tableView.sectionHeaderTopPadding = 0 // for removing the default padding of table cell
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        return tableView
    }()
    
    var arr = [NewsModel]()
    //sideMenu List
    enum Category: String {
        case Sports = "sports"
        case Technology = "technology"
        case Entertainment = "entertainment"
        case Political = "politics"
        case Health = "health"
    }
    var categoryArray: [Category] = [.Sports, .Technology, .Entertainment, .Political, .Health]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuButton.addTarget(self, action: #selector(toggleSideMenu), for: .touchUpInside)
        searchTxtField.delegate = self
        setUpOnView()
        setUpConstraint()
        fetchNews()
    }
    
    //text search on textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTxtField {
            textField.resignFirstResponder()
            fetchNews(keyword: textField.text ?? "")
        }
        return true
    }
    
    //apiCall
    func fetchNews(category: Category? = nil, keyword: String? = nil) {
        var urlString: String = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=722d7bcee45740f48db732dde6d7a420"
        let apiKey = "722d7bcee45740f48db732dde6d7a420"
        
        if let category = category {
            urlString = "https://newsapi.org/v2/top-headlines?category=\(category.rawValue)&apiKey=\(apiKey)"
        } else if let keyword = keyword, !keyword.isEmpty {
            let txtKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString = "https://newsapi.org/v2/everything?q=\(txtKeyword)&apiKey=\(apiKey)"
        }
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Some error")
                return
            }
            
            do {
                // Attempt to parse JSON data
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Print the entire JSON response for debugging purposes
                    print("JSON Response: \(jsonData)")
                    
                    // Extract articles
                    let articles = jsonData["articles"] as? [[String: Any]] ?? []
                    
                    DispatchQueue.main.async {
                        self.arr = articles.map { NewsModel(dicData: $0) }
                        self.tableView.reloadData()
                    }
                } else {
                    print("JSON parsing failed.")
                }
            } catch {
                // Print any error during JSON parsing
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
    //All setup
    func setUpOnView() {
        self.view.addSubview(tableView)
        self.view.addSubview(showSearchView)
        showSearchView.addSubview(searchTxtField)
        self.view.addSubview(sideMenuButton)
    }
    
    //sidemenu action
    @objc func toggleSideMenu() {
        //Fram Constraint fot view
        sideView.frame = view.bounds
        sideView.backgroundColor = .black
        sideView.alpha = 0.5
        view.addSubview(sideView)
        
        let sideMenuWidth = view.frame.width - 200
        sideMenuTableView = UITableView(frame: CGRect(x: view.frame.width, y: 0, width: sideMenuWidth, height: view.frame.height), style: .grouped)
        sideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SideMenuCell")
        sideMenuTableView.rowHeight = UITableView.automaticDimension
        sideMenuTableView.backgroundColor = .lightGray
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        view.addSubview(sideMenuTableView)
        
        UIView.animate(withDuration: 0.3) {
            self.sideMenuTableView.frame.origin.x = self.view.frame.width - sideMenuWidth
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        sideView.addGestureRecognizer(tapGesture)
    }
    
    // tap selector method
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let sideMenuWidth = view.frame.width - 200
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuTableView.frame.origin.x = self.view.frame.width
            self.sideView.alpha = 0
        }) { _ in
            self.sideMenuTableView.removeFromSuperview()
            self.sideView.removeFromSuperview()
        }
    }
    
    func setUpConstraint() {
        // showSearchView
        NSLayoutConstraint.activate([
            showSearchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            showSearchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            showSearchView.heightAnchor.constraint(equalToConstant: 50),
            showSearchView.trailingAnchor.constraint(equalTo: sideMenuButton.leadingAnchor, constant: -2) // space between searchView and sideMenuButton
        ])
        // Search View
        NSLayoutConstraint.activate([
            searchTxtField.topAnchor.constraint(equalTo: showSearchView.topAnchor),
            searchTxtField.leadingAnchor.constraint(equalTo: showSearchView.leadingAnchor),
            searchTxtField.heightAnchor.constraint(equalTo: showSearchView.heightAnchor),
            searchTxtField.trailingAnchor.constraint(equalTo: showSearchView.trailingAnchor)
        ])
        // sideMenuButton
        NSLayoutConstraint.activate([
            sideMenuButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            sideMenuButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            sideMenuButton.widthAnchor.constraint(equalToConstant: 60),
            sideMenuButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        // tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.searchTxtField.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sideMenuTableView {
            return categoryArray.count + 1 //  for the "Clear" button
        } else {
            return arr.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == sideMenuTableView {
            return 1
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sideMenuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath)
            
            if indexPath.row == categoryArray.count{
                
                // Configure "Clear" button cell
                cell.textLabel?.text = "Clear"
                cell.textLabel?.textColor = .red
                cell.textLabel?.textAlignment = .center
                fetchNews()
            } else {
                //  category cell
                cell.textLabel?.text = categoryArray[indexPath.row].rawValue.capitalized
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            let data = arr[indexPath.row]
            
            // Load the image using Kingfisher
            
            if let imageUrl = URL(string: data.image) {
                print("Image URL: \(imageUrl)")
                let image = UIImage(named: "1.png")
                cell.imageViewThumbnail.kf.setImage(with: imageUrl, placeholder: image)
                //for loading image loader
                cell.imageViewThumbnail.kf.indicatorType = .activity
                //cell.imageViewThumbnail.kf.setImage(with: imageUrl) // only for image kingfisher
            }
            
            cell.titleLabel.text = " \(data.title )"
            cell.descriptionLabel.text = "Description - \(data.description)"
            cell.authorLabel.text = "By: \(data.author)"
            cell.timeLabel.text = "Published At: \(data.time)"
            // for webViewController on image click
            cell.callBack = {
                let webVC = WebViewController()
                webVC.url = URL(string: data.website)
                self.present(webVC, animated: true)
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sideMenuTableView {
            if indexPath.row == categoryArray.count {
                // Clear selected, show all news
                fetchNews()
            } else {
                // Fetch news based on the selected category
                let selectedCategory = categoryArray[indexPath.row]
                fetchNews(category: selectedCategory)
            }
        }
        // Close the side menu after selection
        handleTapGesture(UITapGestureRecognizer())
    }
    
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == sideMenuTableView {
            let headerView = UIView()
            headerView.backgroundColor = .blue
            let headerLabel = UILabel()
            headerLabel.text = "Categories"
            headerLabel.textColor = .white
            headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addSubview(headerLabel)
            
            NSLayoutConstraint.activate([
                headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            ])
            
            return headerView
        } else {
            let headerView = UIView()
            headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            // #colorLiteral(red: 0.1333333333, green: 0.1843137255, blue: 0.2470588235, alpha: 1)
            let headerLabel = UILabel()
            headerLabel.text = "Top Stories"
            headerLabel.textColor = .red
            headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addSubview(headerLabel)
            
            NSLayoutConstraint.activate([
                headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16)
            ])
            
            return headerView
        }
    }
}


import UIKit
import WebKit

class WebViewController: UIViewController {
    var url: URL?
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}




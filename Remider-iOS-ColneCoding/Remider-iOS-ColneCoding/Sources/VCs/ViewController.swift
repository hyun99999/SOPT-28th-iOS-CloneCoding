//
//  ViewController.swift
//  Remider-iOS-ColneCoding
//
//  Created by kimhyungyu on 2021/04/12.
//

import UIKit


class ViewController: UIViewController {

    //MARK: - Properties
    
    var tableContents = ["ㅊㅊ","ㅍ","ㅊㅊ","ㅍ","ㅊㅊ","ㅍ","ㅊㅊ","ㅍ","ㅊㅊ","ㅍ"]
    let sections = ["나의 목록"]
    
    //MARK: - @IBOutlet Properties
    
    @IBOutlet weak var tableEditBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var allView: UIView!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //이걸로 위에 테이블뷰 안에 테이블뷰를 넣고 거기에 커스텀 셀을 넣어볼까
        let nibName = UINib(nibName: "FirstCustomCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FirstCustomCell")
        
        // UISearchControloler initialize
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        
        //view cornerRadius
        
        scheduleView.layer.cornerRadius = 13
        todayView.layer.cornerRadius = 13
        allView.layer.cornerRadius = 13

        //UIView touch event
        
//        let concern1Gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedconcern1(_:)))
//        scheduleView.addGestureRecognizer(concern1Gesture)
    }
    
//    // MARK: - Methods
//
//    @objc func tappedconcern1(_ gesture: UITapGestureRecognizer) {
//            let storyboard: UIStoryboard = UIStoryboard(name: "ViewController", bundle: nil)
//            let viewcontroller = storyboard.instantiateViewController(withIdentifier: "ScheduleListVC")
//            present(viewcontroller, animated: true)
//        }
    
    //MARK: - @IBAction Properties
    
    @IBAction func touchEditBtn(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing {
            sender.title = "편집"
            sender.style = .plain
            tableView.setEditing(false, animated: true)
            
            //able searchBar
            
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.placeholder = "검색"
            searchController.searchBar.isUserInteractionEnabled = true
            searchController.searchBar.alpha = 1
            navigationItem.searchController = searchController
            
        } else {
            sender.title = "완료"
            sender.style = .done
            tableView.setEditing(true, animated: true)
            
            // hide label
            
            
            //enable searchBar
            
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.placeholder = "검색"
            searchController.searchBar.isUserInteractionEnabled = false
            searchController.searchBar.alpha = 0.5
            navigationItem.searchController = searchController
        }
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    //cell text. section 0 으로 설정한 상태
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        if indexPath.section == 0 {
            cell.textLabel?.text = tableContents[indexPath.row]
            cell.imageView?.image = UIImage(systemName: "calendar.circle.fill")
            cell.imageView?.tintColor = UIColor.purple
            
            return cell
        } else { return UITableViewCell() }
    }
    
    //cell height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //moveRowAt
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //tableContents.remove(at: sourceIndexPath.row)
    }
    
    //remove row
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            tableContents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let info = UIContextualAction(style: .normal, title: "") { action, view, completion in
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AddListViewController") as? AddListViewController else {
                    return
                }
            //modally
            
            self.present(nextVC, animated: true, completion: nil)
            
            //swipe hide
            
        
        }
        let delete = UIContextualAction(style: .destructive, title: "") { action, view, completion in
            self.tableContents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        info.image = UIImage(systemName: "info.circle.fill")
        delete.image = UIImage(systemName: "trash.fill")

        return UISwipeActionsConfiguration(actions: [delete, info])
    }
    
    //editingstyle 이라서 여기에 체크가 있을줄알았는데 없었다.
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if indexPath.row == 0 {
//            return .none
//        } else {
//            return .delete
//        }
//    }
    
    //MARK: - Section func
    
    //section title
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    //section header fontsize
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
            myLabel.frame = CGRect(x: 8, y: 0, width: 250, height: 20)
            myLabel.font = UIFont.boldSystemFont(ofSize: 24)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

            let headerView = UIView()
            headerView.addSubview(myLabel)

            return headerView
    }
    
    //section header height
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
    
//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return tableContents.count
        } else { return 0 }
    }
}

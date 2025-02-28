//
//  ViewController.swift
//  MemoApp
//
//  Created by 최규현 on 2/26/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    let defaults = UserDefaults.standard
    var memo: [String] = []
    
    func loadMemo() {
        let defaultsMemo = defaults.array(forKey: "defaultsMemo") as? [String] ?? []
        memo = defaultsMemo
    }
    
    func saveMemo() {
        defaults.set(memo, forKey: "defaultsMemo")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadMemo()
        table.delegate = self
        table.dataSource = self
    }
    
    // 스와이프 액션
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") {(_, _, success: @escaping (Bool) -> Void) in
            self.memo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveMemo()
            success(true)
    }
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    // 추가버튼 클릭
    @IBAction func clickAddButton(_ sender: Any) {
        // alert 추가
        let alert = UIAlertController(title: "MEMO", message: "메모를 입력하세요. ", preferredStyle: .alert)

        // 텍스트 필드 추가
        alert.addTextField { textField in
            textField.placeholder = "MEMO"  // 텍스트 필드가 공백일 때 표시될 내용
        }
        
        // 추가버튼 추가
        let addButton = UIAlertAction(title: "추가", style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty {
                self.memo.append(text)  // 텍스트 필드에 입력한 값을 memo 배열에 저장
                self.table.reloadData() // TableView의 데이터를 리로드
                self.saveMemo()
            }
        }
        
        // 취소버튼 추가
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        // alert에 추가, 취소버튼 입력
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        
        // alert 표시
        present(alert, animated: true, completion: nil)
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memo.count
    }
    
    // 셀의 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = memo[indexPath.row]
        
        return cell
    }
}

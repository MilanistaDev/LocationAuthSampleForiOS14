//
//  SettingsViewController.swift
//  LocationAuthSample
//
//  Created by Takuya Aso on 2020/10/26.
//

import UIKit

final class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var lm: LocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "位置情報設定"
        self.lm = LocationManager.sharedInstance
        self.setUpTableView()
        self.notification()
    }

    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    private func notification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotified(_:)), name: NSNotification.Name(rawValue: "NotifyChange"), object: nil)
    }

    @objc private func onNotified(_ notification: NSNotification) {
        self.tableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "位置情報設定"
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "detail")!
                cell.textLabel?.text = "正確な位置情報許可状態"
                cell.detailTextLabel?.text = self.lm.isReducedAccuracy() ? "OFF": "ON"
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = UITableViewCell()
                cell.textLabel?.text = "正確な位置情報 1度だけ許可"
                cell.textLabel?.textColor = .systemBlue
                return cell
            }
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [: ], completionHandler: nil)
            }
        } else {
            if indexPath.row == 1 {
                // 位置情報精度を上げるように促す
                self.lm.requestFullAccuracy()
            }
        }
    }
}

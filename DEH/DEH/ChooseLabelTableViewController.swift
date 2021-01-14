//
//  ChooseLabelTableViewController.swift
//  DEH
//
//  Created by DEH on 2021/1/11.
//

import UIKit
//import ViewController

class ChooseLabelTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            //ViewController.label_labels
            //return 5
            return label_labels.count
        }
        else{
            return landmark_labels.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        // Configure the cell...
        if(indexPath.section == 0) {
            //cell.textLabel?.text = "rrr"
            cell.textLabel?.text = "\(label_labels[indexPath.row])"
        }
        else {
            cell.textLabel?.text = "\(landmark_labels[indexPath.row])"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Labels"
        }
        else {
            return "Landmarks"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.accessoryType == UITableViewCell.AccessoryType.none) {
            if(indexPath.section == 0) {
                label_bool[indexPath.row] = true
                print(label_bool[indexPath.row])
            }
            else {
                landmark_bool[indexPath.row] = true
            }
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else {
            if(indexPath.section == 0) {
                label_bool[indexPath.row] = false
                print(label_bool[indexPath.row])
            }
            else {
                landmark_bool[indexPath.row] = false
            }
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
        /*if label_labels[indexPath.row].done == false {
            cell?.accessoryType = .checkmark
            label_labels[indexPath.row].done = true
        }*/
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//
//  ViewController.swift
//  Delegate
//
//  Created by ChengLu on 2021/6/11.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NoteViewControllerDelegate {

    
   
    
//    var data: [Note] = []
    var data = [Note]()
    @IBOutlet weak var tableView: UITableView!
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.queryFromDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Do any additional setup after loading the view.
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
//        self.tableView.setEditing(editing, animated: true)
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @IBAction func add(_ sender: Any) {
        //Core Data
        let moc = CoreDataHelper.shared.managedObjectContext()
        let note = Note(context: moc)
        note.text = "New One"
        CoreDataHelper.shared.saveContext()
        
        
        self.data.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func queryFromDB() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        moc.performAndWait {
            do{
            let result = try moc.fetch(fetchRequest)
                self.data = result
            } catch {
                print("查詢時有錯誤\(error)")
                self.data = []
            }
        }
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = data[indexPath.row]
        cell.textLabel?.text = note.text
        cell.imageView?.image = note.image()
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = self.data.remove(at: indexPath.row)
        let moc = CoreDataHelper.shared.managedObjectContext()
        moc.performAndWait {
            moc.delete(note)//dele from table
        }
        CoreDataHelper.shared.saveContext()// commit
        
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteSegue" {
            if let noteVC = segue.destination as? NoteViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let note = data[indexPath.row]
                noteVC.currentNote = note
                noteVC.delegate = self
            }
        }
    }
    //MARK: - NoteViewControllerDelegate
    func didFinishUpdate(note: Note) {
        //MARK: - Coredata ~~~~~~~~~~~~~~~~~~~10
        CoreDataHelper.shared.saveContext()//~~~~~~~~~~~~~~~~10  儲存照片區
        if let index = data.firstIndex(of: note) {
            let indexPath = IndexPath(item: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


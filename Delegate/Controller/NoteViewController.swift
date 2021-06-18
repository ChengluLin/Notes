//
//  NoteViewController.swift
//  Delegate
//
//  Created by ChengLu on 2021/6/11.
//

import UIKit

protocol NoteViewControllerDelegate: AnyObject {
    func didFinishUpdate (note: Note)
}

class NoteViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var currentNote : Note!
    weak var delegate : NoteViewControllerDelegate?
//    let delegate:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = self.currentNote.text
        self.imageView.image = self.currentNote.image()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func done(_ sender: Any) {
        self.currentNote.text = self.textView.text
        
        if let image = self.imageView.image {
            let home = URL(fileURLWithPath: NSHomeDirectory())
            let doc = home.appendingPathComponent("Documents")
            let filePath = doc.appendingPathComponent("\(self.currentNote.noteID!).jpg")
            if let imageData = image.jpegData(compressionQuality: 1) {
                do{
                try imageData.write(to: filePath, options: .atomic)
                    self.currentNote.imageName = "\(self.currentNote.noteID!).jpg"
                }catch{
                    print("寫入照片時有誤\(error)")
                }
            }
        }
        
        
        self.delegate?.didFinishUpdate(note: self.currentNote)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func camera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .savedPhotosAlbum //圖庫 最近拍的
//        pickerController.sourceType = .photoLibrary //相簿
//        pickerController.sourceType = .camera //相機功能
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)//從下面往上秀出來
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

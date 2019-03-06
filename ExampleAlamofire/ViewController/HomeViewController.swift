import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tfUserId: UITextField!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnInsert: UIButton!
    
    private var afRepo: AlamofireRepo!
    private var mUserList: [User] = []
    private var isSwitch = true
    private var mPosition = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home Screen"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.afRepo = AlamofireRepo.newInstance()
        getUserList()
    }
    
    @IBAction func insertUser(_ sender: Any) {
        guard let txtUserId = tfUserId.text else {
            return
        }
        guard let id = Int(txtUserId) else {
            print("Id can not be blank!")
            return
        }
        guard let title = tfUserName.text else {
            print("Name can not be blank!")
            return
        }
        let user = User(id: id, title: title)
        if isSwitch {
            addUser(user)
        } else{
            self.btnInsert.setTitle("Update", for: .normal)
            updateUser(user)
        }
        tfUserId.text = ""
        tfUserName.text = ""
        tfUserId.becomeFirstResponder()
    }
    
    private func addUser(_ user: User) {
        afRepo.makeRequestAddUser(user: user, onSucces: { () in
            self.mUserList.insert(user, at: 0)
            self.tableView.reloadData()
        }, onError: { error in
            print(error)
        })
    }
    
    private func updateUser(_ user: User) {
        self.btnInsert.setTitle("Insert", for: .normal)
        self.isSwitch = true
        afRepo.makeRequestAddUser(user: user, onSucces: { () in
            self.mUserList[self.mPosition] = user
            self.tableView.reloadData()
        }, onError: { error in
            print(error)
        })
    }
    
    private func deleteUser(_ user: User,_ pos: Int) {
        afRepo.makeRequestDeleteUser(user: user, onSuccess: { () in
            self.mUserList.remove(at: pos)
            self.tableView.reloadData()
        }, onError: { error in
            print(error)
        })
    }
    
    private func getUserList() {
        afRepo.makeRequestGetUserList(onSuccess:  { response in
            self.mUserList = response!
            self.tableView.reloadData()
        }, onError: { error in
            print("\(error!)")
        })
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.mUserList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! HomeTableViewCell
        cell.setUser(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.mUserList[indexPath.row]
        self.mPosition = indexPath.row
        self.tfUserId.text = String(user.id)
        self.tfUserName.text = user.title
        self.tfUserId.becomeFirstResponder()
        self.isSwitch = false
        self.btnInsert.setTitle("Update", for: .normal)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let user = self.mUserList[indexPath.row]
        if editingStyle == .delete {
            self.deleteUser(user, indexPath.row)
        }
    }
}

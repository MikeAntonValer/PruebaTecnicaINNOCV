//
//  ViewController.swift
//  PruebaDeAcceso
//
//  Created by Miguel Angel Anton Valer on 22/11/22.
//

import UIKit

class ListadoUsuario: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tabla:UITableView!
    @IBOutlet weak var searcher: UISearchBar!
    
    var refrescar=UIRefreshControl()
    var usuarioFiltrados:[User]=[]
    var searching:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.dataSource=self
        tabla.delegate=self
        searcher.delegate=self
        
        searcher.frame=CGRect.init(x: 0, y: 90, width: view.frame.width, height: searcher.frame.height)
        tabla.frame=CGRect.init(x: 0, y: searcher.frame.maxY+5, width: view.frame.width, height: view.frame.height-searcher.frame.maxY+5)
        tabla.estimatedRowHeight=90
        
        refrescar.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tabla.addSubview(refrescar)
        
        async{
            usuarios=await obtenerUsers()
            DispatchQueue.main.async {
                self.tabla.reloadData()
                print(usuarios.count)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(sender: UIRefreshControl){
        DispatchQueue.main.async {
            self.tabla.reloadData()
            self.refrescar.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return usuarioFiltrados.count
        }
        else{
            return usuarios.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda=tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as! ListadoUsersCelda
        
        celda.frame=CGRect.init(x: 0, y: 90*indexPath.row, width: Int(view.frame.width), height: 90)
    
        if searching{
            celda.labelId.text="\(usuarioFiltrados[indexPath.row].id)"
            celda.labelName.text=usuarioFiltrados[indexPath.row].name
            celda.labelBirth.text=usuarioFiltrados[indexPath.row].birthdate
        }
        else{
            celda.labelId.text="\(usuarios[indexPath.row].id)"
            celda.labelName.text=usuarios[indexPath.row].name
            celda.labelBirth.text=usuarios[indexPath.row].birthdate
        }
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc=storyboard?.instantiateViewController(withIdentifier: "ModificarUsuario")as?ModificarUsuario{
            vc.user=usuarios[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            eliminarUsuario(usuario: usuarios[indexPath.row])
            usuarios.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        usuarioFiltrados=usuarios.filter({$0.name?.prefix(searchText.count) ?? "nil"==searchText})
        usuarioFiltrados.append(contentsOf: usuarios.filter({$0.birthdate.prefix(searchText.count)==searchText}))
        usuarioFiltrados.append(contentsOf: usuarios.filter({$0.id==Int(searchText)}))
        usuarioFiltrados=Array(Set(usuarioFiltrados))
        
        searching=true
        if(searchText==""){
            searching=false
        }
        tabla.reloadData()
    }

    @IBAction func insertarElemento(_ sender: Any) {
        if let vc=storyboard?.instantiateViewController(withIdentifier: "InsertarUsuario")as?RegisterForm{
            self.navigationController?.pushViewController(vc, animated: true)
            tabla.reloadData()
        }
    }
}
    

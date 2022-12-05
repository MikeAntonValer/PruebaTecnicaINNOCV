//
//  User.swift
//  PruebaDeAcceso
//
//  Created by Miguel Angel Anton Valer on 24/11/22.
//

import Foundation

struct User:Decodable, Hashable{
    var name:String?
    var birthdate:String
    var id:Int
    
}

var usuarios: [User]=[]

func obtenerUsers() async->[User]{
    var usuarios:[User]=[]
    
    guard let url=URL(string:"https://hello-world.innocv.com/api/User") else {return []}
    do{
        let (data,_)=try await URLSession.shared.data(from: url)
        let decoder=JSONDecoder()
        usuarios=try decoder.decode([User].self, from: data)
        return usuarios
    }
    catch{
        print(error)
        return []
    }
}

func insertarUsers(user:User){
    guard let url=URL(string:"https://hello-world.innocv.com/api/User") else {return print("error")}
    var request=URLRequest(url: url)
    request.httpMethod="POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body:[String:Any]=[
        "name":user.name!,
        "birthdate":user.birthdate,
        "id": 0
    ]
    request.httpBody=try! JSONSerialization.data(withJSONObject: body)
    
    let comunicacion=URLSession.shared.dataTask(with: request) { data, response, error in
        guard (data != nil), error==nil else {
            return
        }
        do{
            print(response ?? "Error")
        }
    }
    comunicacion.resume()
    usuarios.append(user)
}

func modificarUsers(user:User){
    guard let url=URL(string:"https://hello-world.innocv.com/api/User") else {return print("error")}
    var request=URLRequest(url: url)
    request.httpMethod="PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body:[String:Any]=[
        "name":user.name!,
        "birthdate":user.birthdate,
        "id": user.id
    ]
    request.httpBody=try! JSONSerialization.data(withJSONObject: body)
    
    let comunicacion=URLSession.shared.dataTask(with: request) { data, response, error in
        guard (data != nil), error==nil else {
            return
        }
        do{
            print(response ?? "Error")
        }
    }
    comunicacion.resume()
    let posicion=usuarios.firstIndex(where:({$0.id==user.id}))
    usuarios[posicion!]=user
}

func eliminarUsuario(usuario:User){
    guard let url=URL(string:"https://hello-world.innocv.com/api/User/\(usuario.id)") else {return print("error")}
    var request=URLRequest(url: url)
    request.httpMethod="DELETE"
    
    let comunicacion=URLSession.shared.dataTask(with: request) { data, response, error in
        guard (data != nil), error==nil else {
            return
        }
        do{
            print(response ?? "Error")
        }
    }
    comunicacion.resume()
}

func transformacionFecha(fecha:String, formato:Int)->Date{
    let fechaFormateada = DateFormatter()
    
    switch formato{
    case 0:
        fechaFormateada.dateFormat="yyyy-MM-dd'T'HH:mm:ss"
    default:
        fechaFormateada.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSS"
    }
    
    if fechaFormateada.date(from: fecha)==nil {
        return transformacionFecha(fecha: fecha, formato: formato+1)
    }
    else{
        return fechaFormateada.date(from: fecha)!
    }
}


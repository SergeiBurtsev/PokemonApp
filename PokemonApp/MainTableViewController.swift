//
//  MainTableViewController.swift
//  PokemonApp
//
//  Created by Serj on 16.06.2023.
//

import UIKit

class MainTableViewController: UITableViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var pokemons: [Pokemon] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:"pokemoncell")
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        
   
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemoncell", for: indexPath)
        let pokemon = pokemons[indexPath.row]
        cell.textLabel?.text = pokemon.name
        cell.selectionStyle = .gray
        return cell
    }
    
    
    
    private func fetchPokemons(count: Int) {
        let apiRecurce = "https://pokeapi.co/api/v2/pokemon/?limit=\(count)"
        guard let url = URL(string: apiRecurce) else {return}
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            URLSession.shared.dataTask(with: url) { data, _ , error in
                if error != nil {
                    print("Error occured:\(error?.localizedDescription ?? "")")
                }
                
                guard let data,
                      let pokemons = try? JSONDecoder().decode(Result.self, from: data).results else {return}
                DispatchQueue.main.async {
                    self.pokemons = pokemons
                    self.activityIndicator.stopAnimating()
                }
            }.resume()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: nil,
                                      message: "Выберите количество загружаемых покемонов",
                                      preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.placeholder = "Введите количество"
        let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let tf = alert.textFields?.first,
                  tf.text?.isEmpty == false,
                  let count = Int(tf.text ?? "") else { return }
            self?.fetchPokemons(count: count)
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

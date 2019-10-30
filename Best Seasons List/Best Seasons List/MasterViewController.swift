//
//  MasterViewController.swift
//  Best Seasons List
//
//  Created by Andy Almanza on 9/24/18.
//  Copyright © 2018 Andy Almanza. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Series]()

    let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/tv-shows/top-tv-seasons/all/10/explicit.json")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        downloadJson()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = segue.destination as! DetailViewController
                controller.detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Series Cell", for: indexPath) as! SeriesCell

        let object = objects[indexPath.row]
        cell.nameLabel!.text = object.name
        cell.releaseDateLabel!.text = object.releaseDate
        
        //EXTRA CREDIT
        ImageProvider.sharedInstance.imageWithURLString(urlString: object.artworkUrl100) {
            image in
            cell.artworkView.image =  image
            
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // JSON
    func downloadJson()
    {
        weak var weakSelf = self

        let task = URLSession.shared.dataTask(with: url!)
        {
            (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse!.statusCode != 200 {
                // Perform some error handling
                print("Error - invalid status code")
            } else if (data == nil && error != nil) {
                // Perform some error handling
                print("Error - no data downloaded")
            } else {
                // Download succeeded, attempt to decode JSON
                do {
                    let seriesData = try JSONDecoder().decode(Feed.self, from: data!)
                    let dataSource = seriesData.feed.results
                    
                    for series in dataSource {
                        let name = series.name
                        let artistName = series.artistName
                        let release = series.releaseDate
                        let kind = series.kind
                        let artwork = series.artworkUrl100
                        
                        weakSelf!.objects.append(Series(artistName: artistName, name: name, releaseDate: release, kind: kind, artworkUrl100: artwork))
                    }
                } catch let error as NSError {
                    print("Error - JSON not decoded \(error), \(error.userInfo)")
                }
                
                DispatchQueue.main.async
                    {
                        weakSelf!.tableView.reloadData()
                }
            }
        }
        task.resume()
        
    }//end function

}


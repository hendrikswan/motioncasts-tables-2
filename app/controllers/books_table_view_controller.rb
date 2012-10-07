class BooksTableViewController < UITableViewController
  def viewDidLoad
    super

    self.navigationItem.rightBarButtonItem = self.editButtonItem
  end

  def bind_with_books(author)
    @author = author
    self.navigationItem.title = author['name']
    view.reloadData
  end

  def viewDidUnload
    super
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end


  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @author ? @author['books'].length : 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cellIdentifier = self.class.name
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cellIdentifier)
      cell
    end

    book = @author['books'][indexPath.row]
    cell.textLabel.text = book
    cell
  end


end

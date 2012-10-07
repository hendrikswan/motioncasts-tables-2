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
    nr = @author ? @author['books'].length : 0
    nr += 1 if tableView.isEditing
    nr
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

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      book = @author[:books][indexPath.row]
      @author[:books].delete(book)
      view.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
    end
  end

  def setEditing(isEditing, animated:animated)
    super(isEditing, animated:animated)

    last_index_path = [NSIndexPath.indexPathForRow(@author[:books].length, inSection:0)]

    if (isEditing)
        tableView.insertRowsAtIndexPaths(last_index_path, withRowAnimation:UITableViewRowAnimationBottom)
    end
  end

end

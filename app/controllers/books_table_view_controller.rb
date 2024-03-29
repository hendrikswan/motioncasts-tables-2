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
    return add_cell if indexPath.row == @author[:books].length


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
    else
      tableView.deleteRowsAtIndexPaths(last_index_path, withRowAnimation:UITableViewRowAnimationBottom)
      if (@input && @input.text != '')
          @author[:books] << @input.text
          view.reloadData
      end
    end
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    if indexPath.row == @author[:books].length
      return UITableViewCellEditingStyleInsert
    else
      return UITableViewCellEditingStyleDelete
    end
  end

  def add_cell
    cellIdentifier = "new_book"
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cellIdentifier)
      left_padding = 40
      padding = 10

      @input = UITextField.alloc.initWithFrame([[left_padding, padding],[cell.size.width - left_padding - padding, cell.size.height - (padding * 2)]])
      @input.borderStyle = UITextBorderStyleRoundedRect
      cell.addSubview(@input)

      cell
    end

    @input.text = ''
    @input.placeholder = "new book"

    cell
  end

  def tableView(tableView, canMoveRowAtIndexPath:indexPath)
    indexPath.row < @author[:books].length
  end

  def tableView(tableView, moveRowAtIndexPath:fromIndexPath, toIndexPath:toIndexPath)
    book = @author[:books].delete_at(fromIndexPath.row)
    if(toIndexPath.row < fromIndexPath.row)
      @author[:books].insert(toIndexPath.row, book.dup)
    else
      @author[:books].insert(toIndexPath.row -1, book.dup)
    end
  end

end

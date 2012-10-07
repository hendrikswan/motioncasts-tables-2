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

  def setEditing(isEditing, animated:animated)
    @editInitialized = false
    super(isEditing, animated:animated)

    top_index_path = [NSIndexPath.indexPathForRow(0, inSection:0)]

    puts "self.isEditing? #{isEditing}"

    if (isEditing)
        @editInitialized = true
        tableView.insertRowsAtIndexPaths(top_index_path, withRowAnimation:UITableViewRowAnimationBottom)
    else
        tableView.deleteRowsAtIndexPaths(top_index_path, withRowAnimation:UITableViewRowAnimationBottom)
        if (@input.text != '')
          Dispatch::Queue.concurrent('mc-data').after(1) {
            @author[:books] << @input.text
            view.reloadData
          }
        end
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    return add_cell if indexPath.row == 0 && isEditing

    book_index = isEditing ? indexPath.row - 1 : indexPath.row

    cellIdentifier = self.class.name
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cellIdentifier)
      cell
    end

    cell.textLabel.text = @author[:books][book_index]
    cell
  end



  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    if @editInitialized && indexPath.row == 0
      return UITableViewCellEditingStyleInsert
    else
      return UITableViewCellEditingStyleDelete
    end
  end


  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      book = @author[:books][indexPath.row]
      @author[:books].delete(book)
      view.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
    end
  end

end

import Artist from "./Artist.contract.cdc"

// From W1Q1
pub fun display(canvas: Artist.Canvas) {
  // Get width in pixels as Int
  let width = Int(canvas.width)
  // Get height in lines as Int minus 1 (because zero-index)
  let height = Int(canvas.height) - 1
  // Counts the lines
  var lineCounter = 0
  // Counts the columns
  var columnCounter = 0
  // The horizontal border string, start with a corner
  var horizontalBorder = "+"
  
  // Add top border dashes for the whole width
  while columnCounter < width {
    horizontalBorder = horizontalBorder.concat("-")
    columnCounter = columnCounter + 1
  }

  // Add the final corner for the border
  horizontalBorder = horizontalBorder.concat("+")

  // Log the top border
  log(horizontalBorder)

  while lineCounter <= height {
    // Get the string index to start the slice
    let from = lineCounter * width
    // Get the index in the string where to end the slice. 
    // Check that we're not out of bounds
    let upTo = from + width <= canvas.pixels.length ? 
      from + width : 
      canvas.pixels.length

    // Build the line string
    let lineString = 
      "|"
      .concat(canvas.pixels.slice(from: from, upTo: upTo))
      .concat("|")

    // And log it
    log(lineString)

    // Go to next line
    lineCounter = lineCounter + 1
  }

  // Log the bottom border
  log(horizontalBorder)
}

pub fun main(account: Address): [Artist.Canvas] {
  let pictureCollection = getAccount(account).getCapability<&Artist.Collection{Artist.CollectionReader}>(/public/PicturesCollection).borrow() ?? panic("Could not find picture collection!")

  var canvases:[Artist.Canvas] = []

  for id in pictureCollection.getIds() {
    let picture = pictureCollection.borrowPicture(id: id)
    display(canvas: picture.canvas)
    canvases.append(picture.canvas)
  }

  return canvases
}

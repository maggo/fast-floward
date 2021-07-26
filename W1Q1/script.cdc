// Provided Code

pub struct Canvas {

  pub let width: UInt8
  pub let height: UInt8
  pub let pixels: String

  init(width: UInt8, height: UInt8, pixels: String) {
    self.width = width
    self.height = height
    // The following pixels
    // 123
    // 456
    // 789
    // should be serialized as
    // 123456789
    self.pixels = pixels
  }
}

pub fun serializeStringArray(_ lines: [String]): String {
  var buffer = ""
  for line in lines {
    buffer = buffer.concat(line)
  }

  return buffer
}

pub resource Picture {

  pub let canvas: Canvas
  
  init(canvas: Canvas) {
    self.canvas = canvas
  }
}

// Provided Code End

pub fun display(canvas: Canvas) {
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

pub fun main() {

  let pixelsX = [
    "*   *",
    " * * ",
    "  *  ",
    " * * ",
    "*   *"
  ]

  let myCanvas = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )

  let myPicture <- create Picture(canvas: myCanvas)

  // Display the canvas
  display(canvas: myPicture.canvas)

  destroy myPicture
}

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

pub resource Printer {
  // We keep an array of pixels to check for uniqueness
  access(self) var printedPixels: [String]

  init() {
    self.printedPixels = []
  }

  pub fun print(canvas: Canvas): @Picture? {
    // We return nil if the canvas' pixels have been printed already
    if self.printedPixels.contains(canvas.pixels) {
      return nil
    }

    // Add the new pixels to the array
    self.printedPixels.append(canvas.pixels)

    // Print the picture to console! :)
    display(canvas: canvas)
    
    // Return a new Picture resource
    return <- create Picture(canvas: canvas)
  }
}

pub fun main() {

  // Initialize 3 different canvases
  let canvas1 = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray([
      "*   *",
      " * * ",
      "  *  ",
      " * * ",
      "*   *"
    ])
  )

  let canvas2 = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray([
      "*****",
      "*   *",
      "* * *",
      "*   *",
      "*****"
    ])
  )

  let canvas3 = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray([
      "* * *",
      " * * ",
      "* * *",
      " * * ",
      "* * *"
    ])
  )

  // Create the printer
  let myPrinter <- create Printer();

  // Print every pictures' canvas twice, 
  // but it should only log the three different canvases once each
  if let picture1 <- myPrinter.print(canvas: canvas1) { 
    log(picture1.canvas)
    destroy picture1
  }

  if let picture2 <- myPrinter.print(canvas: canvas2) { 
    log(picture2.canvas)
    destroy picture2
  }

  if let picture3 <- myPrinter.print(canvas: canvas3) { 
    log(picture3.canvas)
    destroy picture3
  }

  // Repeat (these will not be logged)
  if let picture1 <- myPrinter.print(canvas: canvas1) { 
    log(picture1.canvas)
    destroy picture1
  }

  if let picture2 <- myPrinter.print(canvas: canvas2) { 
    log(picture2.canvas)
    destroy picture2
  }

  if let picture3 <- myPrinter.print(canvas: canvas3) { 
    log(picture3.canvas)
    destroy picture3
  }

  destroy myPrinter
}

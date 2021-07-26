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
      "* * * ",
      " * * *",
      "* * * ",
      " * * *",
      "* * * "
    ])
  )

  // Create the printer
  let myPrinter <- create Printer();

  // Print every pictures' canvas twice, 
  // but it should only log the three canvases once each
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

  // Repeat
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

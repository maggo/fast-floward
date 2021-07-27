import Artist from "./Artist.contract.cdc"

transaction(pixels: String) {

  let picture: @Artist.Picture?
  let picturesCollectionCapability: Capability<&Artist.Collection>

  prepare(account: AuthAccount) {
    let printerRef = getAccount(0xf8d6e0586b0a20c7)
      .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
      .borrow()
      ?? panic("Couldn't borrow printer reference.")

    let pixelLength = Int(printerRef.width * printerRef.height)

    assert(pixels.length == pixelLength, message: "Pixels string need to be ".concat(pixelLength.toString()).concat(" characters long"))
    
    let canvas = Artist.Canvas(
      width: printerRef.width,
      height: printerRef.height,
      pixels: pixels
    )
    
    self.picture <- printerRef.print(canvas: canvas)

    // Added code
    // 1. Get the Collection capability from the account
    // 2. If it doesn't exist, create and link it

    self.picturesCollectionCapability = account.getCapability<&Artist.Collection>(/private/PicturesCollection)
    
    if (!self.picturesCollectionCapability.check()) {
      account.save(
        <- Artist.createCollection(),
        to: /storage/PicturesCollection
      )

      // Public read capability
      account.link<&Artist.Collection{Artist.CollectionReader}>(
        /public/PicturesCollection,
        target: /storage/PicturesCollection
      )

      // Private read/write capability
      account.link<&Artist.Collection>(
        /private/PicturesCollection,
        target: /storage/PicturesCollection
      )
    }
    
  }

  execute {
    if (self.picture == nil) {
      log("Picture with ".concat(pixels).concat(" already exists!"))

      destroy self.picture
    } else {
      log("Picture printed!")

      self.picturesCollectionCapability.borrow()!.deposit(picture: <- self.picture!)
      log("Picture saved!")
    }
  }
}

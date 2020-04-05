// externalFile.js
var imageURLs = [
  "https://via.placeholder.com/400x600.png",
  "https://via.placeholder.com/600x400.png"
]
module.exports = (req, res, next) => {
  if (Object.keys(req.query).length === 1) {
    var unix = Math.round(+new Date() / 1000);
    var url = imageURLs[Math.floor(Math.random() * imageURLs.length)]
    var redirectURL = url + "?" + unix

    console.log("Redirecting to " + redirectURL)

    res.redirect(redirectURL)
  } else {
    next()
  }
}
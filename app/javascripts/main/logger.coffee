module.exports = {
  log: (message) =>
    console.log "[#{module.exports.time()}]: #{message}"

  error: (mesage) =>
  time: =>
    date = new Date()
    date.toTimeString()

}

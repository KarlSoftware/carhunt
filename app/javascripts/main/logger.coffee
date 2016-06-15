path = require('path')
chalk = require('chalk')

stackReg = /at\s+(.*)\s+\((.*):(\d*):(\d*)\)/i
stackReg2 = /at\s+()(.*):(\d*):(\d*)/i

module.exports = {
  log: (message, data = null) =>
    args = ["[#{chalk.dim(module.exports.time())}] (#{chalk.yellow(module.exports.file())}): #{chalk.blue(message)}"]
    args.push(data) if data
    console.log.apply(console, args)

  file: =>
    s = (new Error()).stack.split('\n')[5]
    stackInfo = stackReg.exec(s) || stackReg2.exec(s)
    "#{path.basename(stackInfo[2])}:#{stackInfo[3]}"

  time: =>
    date = new Date()
    date.toLocaleTimeString()

}

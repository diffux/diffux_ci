const areImagesEqual = require('./areImagesEqual');
const getImageFromStream = require('./getImageFromStream');
const getImageFromPath = require('./getImageFromPath');
const getImageFromDataURI = require('./getImageFromDataURI');
const getLastResultSummary = require('./getLastResultSummary');
const pathToSnapshot = require('./pathToSnapshot');
const RunResult = require('./RunResult');
const constructUrl = require('./constructUrl');
const saveResultsToFile = require('./saveResultsToFile');
const Constants = require('./Constants');
const config = require('./config');

module.exports = {
  config,
  areImagesEqual,
  getImageFromStream,
  getImageFromPath,
  getImageFromDataURI,
  getLastResultSummary,
  pathToSnapshot,
  RunResult,
  constructUrl,
  saveResultsToFile,
  Constants,
};

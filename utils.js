import fs from 'fs';

/**
 * Tries writing to a file by making multiple fs.writeFile calls until one works
 * @param {string} path Filepath
 * @param {string} data Data to be written
 * @param {function(err, message)} callback Callback function
 * @param {number} attempts Maximum amount of writeFile calls before error
 * @param {number} delay Delay between writeFile calls in ms
 * @param {number} c Current iteration variable - dont set
*/
function insistentWriteFile(path, data, callback = () => {}, attempts = 5, delay = 3, c = 0) {
    fs.writeFile(path, data.trim() + '\r\n', (err) => {
        c++;
        if (err) {
            if (c == attempts) {
                callback(err, `Failed to write after ${c} attempts`);
            } else {
                setTimeout(() => {
                    insistentWriteFile(path, data, callback, attempts, c);
                }, delay);
            }
        } else {
            if (c > 1) {
                console.log('Write', c);
            }
            callback(null, `File written after ${c} attempts`);
        }
    });
}

/**
 * Tries reading a file by making multiple fs.readFile calls until one works
 * @param {string} path Filepath
 * @param {function(err, data, message)} callback Callback function
 * @param {number} attempts Maximum amount of writeFile calls before error
 * @param {number} delay Delay between writeFile calls in ms
 * @param {number} c Current iteration variable - dont set
*/
function insistentReadFile(path, callback = () => {}, attempts = 5, delay = 3, c = 0) {
    fs.readFile(path, 'utf8', (err, data) => {
        c++;
        if (err) {
            if (err.code == 'ENOENT') {
                callback(err, null, `No file, so stopped retrying after ${c} attempt ${err}`);
            } else if (c == attempts) {
                callback(err, null, `Failed to read after ${c} attempts`);
            } else {
                setTimeout(() => {
                    insistentReadFile(path, callback, attempts, c);
                }, delay);
            }
        } else {
            if (c > 1) {
                console.log('Read', c);
            }
            callback(null, data, `File read after ${c} attempts`);
        }
    });
}

/**
 * Tries appending to a file by first reading and then concatinating the given data and writing.
 * @param {string} path Filepath
 * @param {function(err, message)} callback Callback function
 * @param {number} attempts Maximum amount of writeFile calls before error
 * @param {number} delay Delay between writeFile calls in ms
 */
function insistentAppend(path, data, callback = () => {}, attempts = 5, delay = 3) {
    insistentReadFile(path, (err, readData, message) => {
        if (err) {
            callback(err, `Append failed due to: ${message}`)
        } else {
            insistentWriteFile(path, (readData + data).trim(), (err, message) => {
                if (err) {
                    callback(err, `Append failed due to: ${message}`)
                } else {
                    callback(null, `Append success`);
                }
            }, attempts, delay);
        }
    }, attempts, delay);
}

/**
 * Tries reading a file, removing all the lines that start with the lineStart value, the overwrites 
 * @param {string} path Filepath
 * @param {string} lineStart Compare Value
 * @param {function(err, message)} callback Callback function
 * @param {number} attempts Maximum amount of writeFile calls before error
 * @param {number} delay Delay between writeFile calls in ms
 */
function removeLineByStart(path, lineStart, callback = () => {}, attempts = 5, delay = 3) {
    insistentReadFile(path, (err, readData, message) => {
        if (err) {
            callback(err, `Remove failed due to: ${message}`);
        } else {
            let writeData = readData.split('\r\n').filter(line => !line.startsWith(lineStart)).join('\r\n');
            insistentWriteFile(path, writeData, (err, message) => {
                if (err) {
                    callback(err, `Remove failed due to: ${message}`);
                } else {
                    callback(null, `Remove success`);
                }
            }, attempts, delay);
        }
    }, attempts, delay);
}

export default { insistentWriteFile, insistentReadFile, insistentAppend, removeLineByStart }
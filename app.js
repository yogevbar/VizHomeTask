// dependencies
const https = require('https');
const express = require('express');
const multer = require('multer');
const queryString = require('querystring');


// app
const app = express();
const storage = multer.memoryStorage();
const upload = multer({storage: storage});

const HOST = 'westcentralus.api.cognitive.microsoft.com';
const SERVICE_KEY = '45125b24b6fe4f3c9d5c6d0b013b0d55';

// upload
app.post('/getImageData', upload.single('image'), (req, res) => {
	const params = {		
		"returnFaceId": "true",
    "returnFaceLandmarks": "false",
    "returnFaceAttributes": "emotion",
  };

	const options = {
		host: HOST,
		method: 'POST',
		path: `/face/v1.0/detect?${queryString.stringify(params)}`,
		headers: {
			'Ocp-Apim-Subscription-Key': SERVICE_KEY,
			'Content-Type': 'application/octet-stream',
			'Content-Length': req.file.buffer.length
		}
	};

	const request = https.request(options, response => {
    res.writeHead(response.statusCode, response.headers);
  	response.pipe(res);
	});

	request.write(req.file.buffer);
	request.end();
});

// start server
let port = process.env.PORT || 4000;
app.listen(port, () => {
  console.log(`Home task API listening on port ${port}`);
});

module.exports = app;

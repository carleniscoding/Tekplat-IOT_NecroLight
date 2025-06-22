const express = require('express');
const path = require('path');

const app = express();

// Serve static files from build/web
app.use(express.static(path.join(__dirname, 'build/web')));

// Handle client-side routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build/web/index.html'));
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

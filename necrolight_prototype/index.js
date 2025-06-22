// This file helps Vercel recognize the project structure
// The actual Flutter web app is in build/web/

module.exports = (req, res) => {
  // This won't be used since we're serving static files
  res.redirect('/index.html');
};

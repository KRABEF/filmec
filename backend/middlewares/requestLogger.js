function requestLogger(req, res, next) {
  const start = Date.now();

  console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl} >>> Запрос получен`);

  const originalSend = res.send;
  res.send = function (body) {
    const duration = Date.now() - start;
    const status = res.statusCode;
    console.log(
      `[${new Date().toISOString()}] ${req.method} ${req.originalUrl} >>> code: ${status} (${duration}ms)`,
    );
    return originalSend.call(this, body);
  };

  next();
}

module.exports = requestLogger;
